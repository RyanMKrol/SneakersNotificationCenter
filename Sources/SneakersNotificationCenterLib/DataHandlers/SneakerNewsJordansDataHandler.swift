//
//  SneakerNewsJordansDataHandler.swift
//  SneakersNotificationCenterLib
//
//  Created by Ryan Krol on 20/12/2018.
//
//  Song: Love in This Club - Usher, Jeezy

import Foundation
import SwiftToolbox
import SwiftSoup

class SneakerNewsJordansDataHandler: PageDataHandler {

    let url = URL(string: "https://sneakernews.com/air-jordan-release-dates/")!
    var result: Set<String>?

    typealias processedData = Set<String>

    /**
     Processor for links on the Jordan SneakerNews Launches page

     - Parameter htmlDoc: The page we want to parse
     - throws: When we can't parse the page
     - returns: A set of links for images on the page
     */
    internal func parseHtml(htmlDoc: Document) throws -> Set<String> {
        let links = try htmlDoc.getElementsByClass("image-box")

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

