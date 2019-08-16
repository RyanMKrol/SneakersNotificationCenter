//
//  PageScraper.swift
//  SneakersNotificationCenterLib
//
//  Created by Ryan Krol on 08/12/2018.
//
//  TV: Ashes To Ashes - Season 2 - Episode 2

import Foundation
import SwiftSoup
import class SwiftToolbox.InteractionHandler

public class PageScraper {

    private init() {}

    /**
     Public method for fetching new Nike images

     - throws: When we can't parse the page we're trying to fetch
     - returns: A set of links for images on the page
     */
    public static func fetchNikeLinks() throws -> Set<String> {
        return try InteractionHandler.fetch(dataHandler: NikeDataHandler())
    }

    /**
     Public method for fetching new SneakerNews Jordan images

     - throws: When we can't parse the page we're trying to fetch
     - returns: A set of links for images on the page
     */
    public static func fetchJordanSneakerNewsLinks() throws -> Set<String> {
        return try InteractionHandler.fetch(dataHandler: SneakerNewsJordansDataHandler())
    }
}
