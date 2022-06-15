// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "videocall",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "ContactsClient",
            targets: ["ContactsClient"]
        ),
        .library(
            name: "ContactsFeature",
            targets: ["ContactsFeature"]
        ),
        .library(
            name: "SharedModels",
            targets: ["SharedModels"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ContactsClient",
            dependencies: []
        ),
        .target(
            name: "ContactsFeature",
            dependencies: [
                "ContactsClient",
                "SharedModels"
            ]
        ),
        .target(
            name: "SharedModels",
            dependencies: []
        ),
        .testTarget(
            name: "ContactsClientTests",
            dependencies: ["ContactsClient"]
        ),
    ]
)
