import XCTest
@testable import NikeNotifications

final class NikeNotificationsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(NikeNotifications().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
