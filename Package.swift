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
            name: "PersistenceClient",
            targets: ["PersistenceClient"]
        ),
        .library(
            name: "KeychainClient",
            targets: ["KeychainClient"]
        ),
        .library(
            name: "KeychainClientLive",
            targets: ["KeychainClientLive"]
        ),
        .library(
            name: "ApiClient",
            targets: ["ApiClient"]
        ),
        .library(
            name: "AuthClient",
            targets: ["AuthClient"]
        ),
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
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PersistenceClient",
            dependencies: []
        ),
        .target(
            name: "KeychainClient",
            dependencies: []
        ),
        .target(
            name: "KeychainClientLive",
            dependencies: [
                "KeychainClient"
            ]
        ),
        .target(
            name: "ApiClient",
            dependencies: []
        ),
        .target(
            name: "AuthClient",
            dependencies: [
                "ApiClient",
                "KeychainClient",
                "PersistenceClient"
            ]
        ),
        .target(
            name: "ContactsClient",
            dependencies: [
                "SharedModels"
            ]
        ),
        .target(
            name: "ContactsFeature",
            dependencies: [
                "ContactsClient",
                "SharedModels",
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
        .testTarget(
            name: "AuthClientTests",
            dependencies: ["AuthClient"]
        ),
    ]
)
