// swift-tools-version:5.10
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
    ],
    dependencies: [
        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.3.0"),
    ],
    targets: [
        .target(
            name: "T2ScholaCoreSwift",
            dependencies: ["Kanna"]),
        .testTarget(
            name: "T2ScholaCoreSwiftTests",
            dependencies: ["T2ScholaCoreSwift"],
            resources: [.process("HTML")]
        ),
    ]
)
