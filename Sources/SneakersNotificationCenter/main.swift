//
//  main.swift
//  SneakersNotificationCenterLib
//
//  Created by Ryan Krol on 08/12/2018.
//
//  Song: Illuminate - Tender

import Foundation
import SneakersNotificationCenterLib

import class SwiftToolbox.ConfigHandler
import class SwiftToolbox.EmailHandler
import class SwiftToolbox.FileHandler
import struct SwiftToolbox.EmailConfig
import enum SwiftToolbox.CommonErrors

func run() {

    let emailConfigFile = "/Users/ryankrol/Desktop/ToolboxProjects/SneakersNotificationCenter/Sources/SneakersNotificationCenterLib/emailConfig.json"
    let savedLinksFile = "\(#file.components(separatedBy: "Sources/")[0])Data/saved.txt"

    let emailConfig = try? ConfigHandler<EmailConfig>(configFile: emailConfigFile).load()

    guard let concreteEmailConfig = emailConfig else {
        print(CommonErrors.CouldNotLoadEmailConfig)
        return
    }

    let emailClient = EmailHandler(config: concreteEmailConfig)

    do {

        let existingUrls    = try FileHandler.readLines(fileLoc: savedLinksFile)
        let nikeUrls        = try PageScraper.fetchNikeLinks()
        let sneakerNewsUrls = try PageScraper.fetchJordanSneakerNewsLinks()

        let urls = nikeUrls.union(sneakerNewsUrls)

        // if there are no new shoes, just return
        guard !urls.isSubset(of: existingUrls) else {
            return
        }

        let updateUrls   = existingUrls.union(urls)
        let updateString = updateUrls.joined(separator: "\n")
        try FileHandler.pushString(content: updateString, fileLoc: savedLinksFile)

        let newUrls = urls.subtracting(existingUrls)

        emailClient.sendMail(
            coreUser: "ryankrol.m@gmail.com",
            subject: "Upcoming Sneaker Releases",
            imageAttachmentUrls: Array(newUrls)
        )
    } catch {
        emailClient.sendMail(
            coreUser: "ryankrol.m@gmail.com",
            subject: "Upcoming Sneaker Releases - Error",
            content: "The program failed to run with the following error - \(error)"
        )
    }

}

run()
