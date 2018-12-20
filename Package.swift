// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SneakersNotificationCenter",
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", .upToNextMajor(from: "1.7.4")),
        .package(url: "https://github.com/IBM-Swift/Swift-SMTP.git", .upToNextMajor(from: "5.1.0")),
        .package(url: "https://github.com/RyanMKrol/SwiftToolbox.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "SneakersNotificationCenterLib",
            dependencies: ["SwiftSoup", "SwiftSMTP", "SwiftToolbox"]),
        .target(
            name: "SneakersNotificationCenter",
            dependencies: ["SneakersNotificationCenterLib"]),
        .testTarget(
            name: "SneakersNotificationCenterTests",
            dependencies: ["SneakersNotificationCenterLib"]),
    ]
)
