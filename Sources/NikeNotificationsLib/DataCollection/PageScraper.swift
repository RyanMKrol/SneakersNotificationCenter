//
//  PageScraper.swift
//  NikeNotificationsLib
//
//  Created by Ryan Krol on 08/12/2018.
//
//  TV: Ashes To Ashes - Season 2 - Episode 2

import Foundation
import SwiftSoup

public class PageScraper {

    private static let nikeLaunchesPage = URL(string: "https://www.nike.com/gb/launch")!
    private static let sneakerNewsJordansPage = URL(string: "https://sneakernews.com/air-jordan-release-dates/")!

    private init() {}

    /**
     Public method for fetching new Nike images

     - throws: When we can't parse the page we're trying to fetch
     - returns: A set of links for images on the page
     */
    public static func fetchNikeLinks() throws -> Set<String> {
        return try fetch(processor: nikeLinkProcessing, url: nikeLaunchesPage)
    }

    public static func fetchJordanSneakerNewsLinks() throws -> Set<String> {
        return try fetch(processor: jordanSneakerNewsLinkProcessing, url: sneakerNewsJordansPage)
    }

    /**
     A wrapper for calling scraping page data, will handle data, and exceptions

     - returns: The URLs of sneakers on the page
     - throws: Any exceptions related to scraping the page, or parsing the response
     */
    private static func fetch
        (processor: @escaping (Document) throws -> Set<String>,
        url: URL
    ) throws -> Set<String> {

        var apiResult: Set<String>? = nil
        var error: Error? = nil

        PageScraper.call(parseLinks: processor, url: url) { (result: Result) in
            switch result {
            case .success(let callbackResult):
                apiResult = callbackResult
            case .failure(let callbackError):
                error = callbackError
            }
        }

        if let error = error {
            throw error
        }

        guard let result = apiResult else {
            throw APIErrors.NoData
        }

        return result
    }

    /**
     Scrapes the page and grabs the images we want to use

     - Parameter parseLinks: The processor we want to use to parse data from the page
     - Parameter url: The URL of the page we want data from
     - Parameter completion: The callback to call once the data has been handled (or not)
     */
    private static func call(
        parseLinks: @escaping (Document) throws -> Set<String>,
        url: URL,
        completion: @escaping (Result<Set<String>>) -> Void
    ) {
        let waitTask = DispatchSemaphore(value: 0)

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { waitTask.signal() }

            completion(Result {

                guard let data = data else {
                    throw APIErrors.NoData
                }

                let pageData = String.init(data: data, encoding: .utf8)!
                let parsedHtml = try! SwiftSoup.parse(pageData)

                return try parseLinks(parsedHtml)
            })
        }.resume()

        waitTask.wait()
    }

    /**
     Processor for links on the Nike Launches page

     - Parameter page: The page we want to parse
     - throws: When we can't parse the page
     - returns: A set of links for images on the page
     */
    private static func nikeLinkProcessing(page: Document) throws -> Set<String> {

        let links = try page.getElementsByTag("link")

        let linksArray = links.map({ (link) -> String? in
            guard (try? link.attr("rel")) == "preload" else {
                return nil
            }

            guard let linkHref = try? link.attr("href") else {
                return nil
            }

            return linkHref
        }).compactMap({$0})

        return Set<String>(linksArray)
    }

    /**
     Processor for links on the Jordan SneakerNews Launches page

     - Parameter page: The page we want to parse
     - throws: When we can't parse the page
     - returns: A set of links for images on the page
     */
    private static func jordanSneakerNewsLinkProcessing(page: Document) throws -> Set<String> {

        let links = try page.getElementsByClass("image-box")

        let imageSources = links.map { (link) -> String? in

            // get the image from the <a> tag
            guard let innerImage = try? link.child(0).html() else {
                return nil
            }

            // recreate an image tag from the inner html
            guard let imageDom = try? SwiftSoup.parseBodyFragment(innerImage) else {
                return nil
            }

            // grab that image tab, and the associated source
            guard let imageSource = try? imageDom.getElementsByTag("img").first()?.attr("src") else {
                return nil
            }

            return imageSource
        }.compactMap({$0})

        return Set<String>(imageSources)
    }
}
