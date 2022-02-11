// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "T2ScholaCoreSwift",
    platforms: [
            .macOS(.v12),
            .iOS(.v15)
        ],
    products: [
        .library(
            name: "T2ScholaCoreSwift",
            targets: ["T2ScholaCoreSwift"]),
        .executable(
            name: "T2ScholaCoreSwiftRun",
            targets: ["T2ScholaCoreSwiftRun"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.2.2"),
    ],
    targets: [
        .target(
            name: "T2ScholaCoreSwift",
            dependencies: ["Kanna"]),
        .target(
            name: "T2ScholaCoreSwiftRun",
            dependencies: [
                "T2ScholaCoreSwift"
            ]),
        .testTarget(
            name: "T2ScholaCoreSwiftTests",
            dependencies: ["T2ScholaCoreSwift"]),
    ]
)
