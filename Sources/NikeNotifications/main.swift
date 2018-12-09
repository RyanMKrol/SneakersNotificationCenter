//
//  main.swift
//  NikeNotification
//
//  Created by Ryan Krol on 08/12/2018.
//
//  Song: Illuminate - Tender

import Foundation
import NikeNotificationsLib

do {
    let existingUrls = try FileInteractions.fetch()
    let newUrls = try PageScraper.fetch()

    if newUrls.isSubset(of: existingUrls) {
        throw CommonErrors.NoNewShoes
    }

    let updateUrls = existingUrls.union(newUrls)
    let updateString = updateUrls.joined(separator: "\n")
    try FileInteractions.push(urls: updateString)

    let mailClient = EmailClient()

    mailClient.sendMail("ryankrol.m@gmail.com", images: newUrls)
} catch {
    print(error)
}
