// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorPluginDiagnostics",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CapacitorPluginDiagnostics",
            targets: ["DiagnosticPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "DiagnosticPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/DiagnosticPlugin"),
        .testTarget(
            name: "DiagnosticPluginTests",
            dependencies: ["DiagnosticPlugin"],
            path: "ios/Tests/DiagnosticPluginTests")
    ]
)