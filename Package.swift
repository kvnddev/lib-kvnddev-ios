// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "KvndDev",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "KvndDev", targets: ["KvndDev"]),
        .library(name: "KvndDevObjC", targets: ["KvndDevObjC"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "KvndDevObjC"
        ),
        .target(
            name: "KvndDev",
            dependencies: [
                .target(name: "KvndDevObjC")
            ]
        ),
        .testTarget(
            name: "KvndDevTests",
            dependencies: ["KvndDev"],
            resources: [
                .copy("README"),
            ]
        ),
    ]
)
