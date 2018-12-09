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

    private init() {}

    /**
     Public method for fetching new Nike images

     - throws: When we can't parse the page we're trying to fetch
     - returns: A set of links for images on the page
     */
    public static func fetchNikeLinks() throws -> Set<String> {
        return try fetch(processor: nikeLinkProcessing, url: nikeLaunchesPage)
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
}
