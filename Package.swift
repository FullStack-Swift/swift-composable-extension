  // swift-tools-version:5.5
  // The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-composable-extension",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "ComposableArchitectureExtension",
      targets: ["ComposableArchitectureExtension"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.33.1")
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "ComposableArchitectureExtension",
      dependencies: [
        .productItem(name: "ComposableArchitecture", package: "swift-composable-architecture", condition: nil)
      ]),
    .testTarget(
      name: "swift-composable-extensionTests",
      dependencies: ["ComposableArchitectureExtension", "ComposableArchitectureExtension"]),
  ]
)
