// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HZNavigationBar",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "HZNavigationBar",
            targets: ["HZNavigationBar"])
    ],
    targets: [
        .target(
            name: "HZNavigationBar",
            path: "Sources",
            exclude: ["../Example", "../Example"],
            sources: ["."]
        )
    ],
    swiftLanguageVersions: [.v5]
)
