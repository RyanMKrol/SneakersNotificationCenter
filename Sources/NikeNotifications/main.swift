//
//  main.swift
//  NikeNotification
//
//  Created by Ryan Krol on 08/12/2018.
//

import Foundation
import NikeNotificationsLib

do {
    let urls = try PageScraper.fetch()
    print(urls)
} catch {
    print(error)
}
