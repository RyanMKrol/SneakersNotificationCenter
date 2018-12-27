// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SneakersNotificationCenter",
    dependencies: [
        .package(url: "https://github.com/RyanMKrol/SwiftToolbox.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "SneakersNotificationCenterLib",
            dependencies: ["SwiftToolbox"]),
        .target(
            name: "SneakersNotificationCenter",
            dependencies: ["SneakersNotificationCenterLib"]),
        .testTarget(
            name: "SneakersNotificationCenterTests",
            dependencies: ["SneakersNotificationCenterLib"]),
    ]
)
