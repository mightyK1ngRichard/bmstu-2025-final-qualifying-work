// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkAPI",
    platforms: [
        .macOS(.v15),
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NetworkAPI",
            targets: ["NetworkAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.24.2"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.28.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NetworkAPI",
            dependencies: [
                .product(name: "GRPC", package: "grpc-swift"),
                .product(name: "SwiftProtobuf", package: "swift-protobuf")
            ]
        ),
    ]
)
