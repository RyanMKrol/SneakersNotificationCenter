// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SneakersNotificationCenter",
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "1.7.4"),
        .package(url: "https://github.com/IBM-Swift/Swift-SMTP.git", from: "5.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SneakersNotificationCenterLib",
            dependencies: ["SwiftSoup", "SwiftSMTP"]),
        .target(
            name: "SneakersNotificationCenter",
            dependencies: ["SneakersNotificationCenterLib"]),
        .testTarget(
            name: "SneakersNotificationCenterTests",
            dependencies: ["SneakersNotificationCenterLib"]),
    ]
)
