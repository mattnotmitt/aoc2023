// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let dependencies: [Target.Dependency] = [
  .product(name: "Parsing", package: "swift-parsing"),
  .product(name: "Algorithms", package: "swift-algorithms"),
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
    .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
    .package(url: "https://github.com/apple/swift-collections", revision: "cc1c037")
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
        .product(name: "Collections", package: "swift-collections"),
        .product(name: "Algorithms", package: "swift-algorithms"),
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
    .executableTarget(
      name: "day9",
      dependencies: dependencies,
      resources: [
        .process("day9.txt"),
        .process("day9_example.txt")
      ]
    ),
    .executableTarget(
      name: "day10",
      dependencies: dependencies,
      resources: [
        .process("day10.txt"),
        .process("day10_example.txt"),
        .process("day10_example2.txt")
      ]
    ),
    .executableTarget(
      name: "day11",
      dependencies: dependencies,
      resources: [
        .process("day11.txt"),
        .process("day11_example.txt")
      ]
    ),
    .executableTarget(
      name: "day12",
      resources: [
        .process("day12.txt"),
        .process("day12_example.txt")
      ]
    ),
    .executableTarget(
      name: "day13",
      dependencies: [
        .product(name: "Algorithms", package: "swift-algorithms"),
        "AOCUtils"
      ],
      resources: [
        .process("day13.txt"),
        .process("day13_example.txt")
      ]
    ),
    .executableTarget(
      name: "day14",
      dependencies: [
        "AOCUtils"
      ],
      resources: [
        .process("day14.txt"),
        .process("day14_example.txt")
      ]
    ),
    .executableTarget(
      name: "day15",
      dependencies: [
        .product(name: "Collections", package: "swift-collections"),
      ],
      resources: [
        .process("day15.txt"),
        .process("day15_example.txt")
      ]
    ),
    .executableTarget(
      name: "day16",
      dependencies: [
        "AOCUtils"
      ],
      resources: [
        .process("day16.txt"),
        .process("day16_example.txt")
      ]
    ),
    .executableTarget(
      name: "day17",
      dependencies: [
        "AOCUtils"
      ],
      resources: [
        .process("day17.txt"),
        .process("day17_example.txt")
      ]
    ),
    .executableTarget(
      name: "day18",
      dependencies: [
        "AOCUtils",
        .product(name: "Parsing", package: "swift-parsing"),
      ],
      resources: [
        .process("day18.txt"),
        .process("day18_example.txt")
      ]
    ),
    .executableTarget(
      name: "day19",
      dependencies: [
        "AOCUtils",
        .product(name: "Parsing", package: "swift-parsing"),
      ],
      resources: [
        .process("day19.txt"),
        .process("day19_example.txt")
      ]
    ),
    .executableTarget(
      name: "day20",
      dependencies: [
        "AOCUtils",
        .product(name: "Parsing", package: "swift-parsing"),
      ],
      resources: [
        .process("day20.txt"),
        .process("day20_example.txt"),
        .process("day20_example2.txt")
      ]
    ),
    .executableTarget(
      name: "day21",
      dependencies: [
        "AOCUtils"
      ],
      resources: [
        .process("day21.txt"),
        .process("day21_example.txt")
      ]
    ),
    .executableTarget(
      name: "day22",
      dependencies: [
        "AOCUtils",
        .product(name: "Parsing", package: "swift-parsing"),
      ],
      resources: [
        .process("day22.txt"),
        .process("day22_example.txt")
      ]
    ),
    .executableTarget(
      name: "day23",
      dependencies: [
        "AOCUtils"
      ],
      resources: [
        .process("day23.txt"),
        .process("day23_example.txt")
      ]
    ),
    .executableTarget(
      name: "day24",
      dependencies: [
        "AOCUtils",
        .product(name: "Parsing", package: "swift-parsing"),
      ],
      resources: [
        .process("day24.txt"),
        .process("day24_example.txt")
      ]
    ),
  ]
)
