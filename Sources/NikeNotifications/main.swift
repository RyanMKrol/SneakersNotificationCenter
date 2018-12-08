import Foundation
import SwiftyJSON
import SwiftSoup

let waitTask = DispatchSemaphore(value: 0)

let url = URL.init(string: "https://www.nike.com/gb/launch")

let session = URLSession.shared
session.dataTask(with: url!) { (data, response, error) in
    defer { waitTask.signal() }

    let jsonData = String.init(data: data!, encoding: .utf8)!
    let soup = try! SwiftSoup.parse(jsonData)

    let links = try! soup.getElementsByTag("link")

    for link in links {
        if let relValue = try? link.attr("rel"),
            relValue == "preload",
            let link = try? link.attr("href") {
            print(link)
        }

    }

}.resume()

waitTask.wait()
