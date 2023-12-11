// The Swift Programming Language
// https://docs.swift.org/swift-book

import AOCUtils
import Foundation
import Parsing

@main
struct Day11 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day11", withExtension: "txt")!
    ).trimmingCharacters(
      in: .newlines
    ).components(separatedBy: "\n").map { Array($0) }

    let empties = findEmptyRowsCols(image: data)

    var galaxies = [Point]()
    for x in 0..<data.count {
      for y in 0..<data.last!.count {
        if data[x][y] == "#" {
          galaxies.append(Point(x, y))
        }
      }
    }

    print("part1: \(part1(galaxies: galaxies, empties: empties))")
    print("part2: \(part2(galaxies: galaxies, empties: empties))")
  }

  static func findEmptyRowsCols(image: [[Character]]) -> [Point] {
    var lines = [Point]()
    for (i, row) in image.enumerated() {
      if row.allSatisfy({ $0 == "." }) {
        lines.append(Point(i, -1))
      }
    }
    for (i, col) in transpose(image).enumerated() {
      if col.allSatisfy({ $0 == "." }) {
        lines.append(Point(-1, i))
      }
    }
    return lines
  }

  static func intersects(galaxyPair: (Point, Point), emptyLine: (Point)) -> Bool {
    return Range(unorderedLeft: galaxyPair.0.x, right: galaxyPair.1.x).contains(emptyLine.x)
      || Range(unorderedLeft: galaxyPair.0.y, right: galaxyPair.1.y).contains(emptyLine.y)
  }

  static func findDistancesWithShift(galaxies: [Point], empties: [Point], shift: Int = 2) -> [Int] {
    Array(
      galaxies.enumerated().map { i, fromGalaxy in
        galaxies.enumerated().compactMap { j, toGalaxy in
          i > j
            ? fromGalaxy.manhattanDistance(to: toGalaxy) + empties.filter {
              intersects(galaxyPair: (fromGalaxy, toGalaxy), emptyLine: $0)
            }.count * (shift - 1) : nil
        }
      }.joined())
  }

  static func part1(galaxies: [Point], empties: [Point]) -> Int {
    return findDistancesWithShift(galaxies: galaxies, empties: empties).reduce(0, +)
  }

  static func part2(galaxies: [Point], empties: [Point]) -> Int {
    return findDistancesWithShift(galaxies: galaxies, empties: empties, shift: 1_000_000).reduce(
      0, +)
  }
}
