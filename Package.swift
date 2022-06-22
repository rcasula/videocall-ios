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
            name: "AppFeature",
            targets: ["AppFeature"]
        ),
        .library(
            name: "LoginFeature",
            targets: ["LoginFeature"]
        ),
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
        .library(
            name: "SharedExtensions",
            targets: ["SharedExtensions"]
        ),
        .library(
            name: "SharedViews",
            targets: ["SharedViews"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "AuthClient",
                "LoginFeature",
                "ContactsClient",
                "ContactsFeature",
                "SharedExtensions"
            ]
        ),
        .target(
            name: "LoginFeature",
            dependencies: [
                "AuthClient",
                "SharedExtensions",
                "SharedViews"
            ]
        ),
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
                "AuthClient",
                "ContactsClient",
                "SharedModels",
            ]
        ),
        .target(
            name: "SharedModels",
            dependencies: []
        ),
        .target(
            name: "SharedExtensions",
            dependencies: []
        ),
        .target(
            name: "SharedViews",
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
