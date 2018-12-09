//
//  FileInteractions.swift
//  NikeNotificationsLib
//
//  Created by Ryan Krol on 08/12/2018.
//
//  Song: Good Cop Bad Cop - Ice Cube

import Foundation

public class FileInteractions {

    enum FileErrors: Error {
        case CouldNotRead
        case CouldNotWrite
        case CouldNotCreate
    }

    private init(){}

    private static let fileLoc = "NikeNotifications/saved.txt"
    private static let fileManager = FileManager.default

    public static func fetch() throws -> Set<String> {

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(fileLoc)
            do {
                let savedLinks = try String(contentsOf: fileURL, encoding: .utf8)
                let urls = savedLinks.split(separator: "\n")

                return Set<String>(urls.map {String($0)})
            } catch {
                throw FileErrors.CouldNotRead
            }
        }

        throw FileErrors.CouldNotRead
    }

    public static func push(urls:String) throws {

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileLoc)

            if (!fileManager.fileExists(atPath:fileURL.path)){
                if (!fileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil)){
                    throw FileErrors.CouldNotCreate
                }
            }
            do {
                try urls.write(to: fileURL, atomically: true, encoding: .utf8)
            }
            catch {
                throw FileErrors.CouldNotWrite
            }
        }
    }
}
