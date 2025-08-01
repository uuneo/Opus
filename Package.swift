// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Opus",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Opus",
            targets: ["Opus", "libopus"]),
        .library(
            name: "libopus",
            targets: ["libopus"]
        )
    ],
    dependencies: [ ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .binaryTarget(name: "libopus", path: "Sources/libopus/libopus.xcframework"),
        .target(
            name: "Opus",
            dependencies: ["libopus"],
            path: "Sources/Opus",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("ogg"),
                .headerSearchPath("opusenc"),
                .headerSearchPath("opusfile")
            ]
        ),

    ]
)
