// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StoreKitClient",
    platforms: [
        .iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .visionOS(.v1)
    ],
    products: [
        .singleTargetLibrary("StoreKitClient"),
        .singleTargetLibrary("StoreKitClientLive"),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "StoreKitClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "StoreKitClientLive",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "StoreKitClient"
            ]
        ),
        .testTarget(
            name: "StoreKitClientTests",
            dependencies: [
                "StoreKitClient",
            ]
        ),
    ]
)

extension Product {
    static func singleTargetLibrary(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}
