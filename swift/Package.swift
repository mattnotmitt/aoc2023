// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let dependencies: [Target.Dependency] = [
  .product(name: "Parsing", package: "swift-parsing"),
  "AOCUtils"
]

let package = Package(
  name: "aoc2023",
  platforms: [
    .macOS(.v13)
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-parsing", .upToNextMajor(from: "0.7.0")),
    .package(url: "https://github.com/apple/swift-format.git", .upToNextMajor(from: "509.0.0")),
    .package(url: "https://github.com/apple/swift-numerics", revision: "1883189"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .executableTarget(
      name: "day0",
      dependencies: dependencies,
      resources: [
        .process("day0.txt"),
        .process("day0_example.txt")
      ]
    ),
    .target(
      name: "AOCUtils",
      dependencies: [
        .product(name: "Numerics", package: "swift-numerics"),
      ]
    ),
    .executableTarget(
      name: "day1"
    ),
    .executableTarget(
      name: "day4"
    ),
    .executableTarget(
      name: "day5"
    ),
    .executableTarget(
      name: "day6"
    ),
    .executableTarget(
      name: "day7",
      dependencies: dependencies,
      resources: [
        .process("day7.txt"),
        .process("day7_example.txt")
      ]
    ),
    .executableTarget(
      name: "day8",
      dependencies: dependencies,
      resources: [
        .process("day8.txt")
      ]
    ),
  ]
)
