// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription


let package = Package(
    name: "ApodiniLIFXExample",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "ApodiniLIFXExample",
            targets: ["ApodiniLIFXExample"]
        )
    ],
    dependencies: [
        .package(
            name: "Apodini",
            url: "https://github.com/Apodini/Apodini.git",
            .branch("develop")
        ),
        .package(
            name: "swift-nio-lifx",
            url: "https://github.com/PSchmiedmayer/Swift-NIO-LIFX.git",
            from: "0.1.1"
        )
    ],
    targets: [
        .target(
            name: "ApodiniLIFXExample",
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
                .product(name: "NIOLIFX", package: "swift-nio-lifx")
            ]
        ),
        .testTarget(
            name: "ApodiniLIFXExampleTests",
            dependencies: ["ApodiniLIFXExample"]
        )
    ]
)
