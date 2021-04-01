// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
        name: "SmartInfrastructure",
        platforms: [
            .macOS(.v10_15)
        ],
        products: [
            .executable(
                    name: "SmartInfrastructure",
                    targets: ["SmartInfrastructure"]
            )
        ],
        dependencies: [
            .package(
                    name: "Apodini",
                    url: "https://github.com/Apodini/Apodini.git",
                    .branch("develop")
            ),
            .package(name: "swift-argument-parser", url: "https://github.com/apple/swift-argument-parser", from: "0.3.2"),
            .package(name: "swift-log", url: "https://github.com/apple/swift-log.git", from: "1.4.0"),
            .package(name: "swift-nio", url: "https://github.com/apple/swift-nio.git", from: "2.25.1"),
            .package(name: "swift-nio-ip", url: "https://github.com/PSchmiedmayer/Swift-NIO-IP.git", from: "0.0.1")
        ],
        targets: [
            .target(
                    name: "SmartInfrastructure",
                    dependencies: [
                        .product(name: "Apodini", package: "Apodini"),
                        .product(name: "ApodiniJobs", package: "Apodini"),
                        .product(name: "ApodiniREST", package: "Apodini"),
                        .product(name: "ApodiniOpenAPI", package: "Apodini"),
                        .target(name: "ApodiniLIFX")
                    ]
            ),
            .target(
                    name: "ApodiniLIFX",
                    dependencies: [
                        .product(name: "Apodini", package: "Apodini"),
                        .target(name: "NIOLIFX")
                    ]
            ),
            .target(
                    name: "lifx",
                    dependencies: [
                        .product(name: "ArgumentParser", package: "swift-argument-parser"),
                        .product(name: "Logging", package: "swift-log"),
                        .target(name: "NIOLIFX")
                    ]
            ),
            .target(
                    name: "NIOLIFX",
                    dependencies: [
                        .product(name: "Logging", package: "swift-log"),
                        .product(name: "NIO", package: "swift-nio"),
                        .product(name: "NIOIP", package: "swift-nio-ip")
                    ]
            ),
            .testTarget(
                    name: "NIOLIFXTests",
                    dependencies: [
                        .target(name: "NIOLIFX")
                    ]
            ),
            .testTarget(
                    name: "SmartInfrastructureTests",
                    dependencies: ["SmartInfrastructure"]
            )
        ]
)
