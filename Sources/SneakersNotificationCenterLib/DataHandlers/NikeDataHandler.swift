//
//  NikeDataHandler.swift
//  SneakersNotificationCenterLib
//
//  Created by Ryan Krol on 20/12/2018.
//
//  Song: High Again - Hoodie Allen

import Foundation
import SwiftToolbox
import SwiftSoup

class NikeDataHandler: PageDataHandler {

    let url = URL(string: "https://www.nike.com/gb/launch")!
    var result: Set<String>?

    typealias processedData = Set<String>

    /**
     Processor for links on the Nike Launches page

     - Parameter htmlDoc: The page we want to parse
     - throws: When we can't parse the page
     - returns: A set of links for images on the page
     */
    internal func parseHtml(htmlDoc: Document) throws -> Set<String> {
        let links = try htmlDoc.getElementsByTag("link")

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
