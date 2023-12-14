// The Swift Programming Language
// https://docs.swift.org/swift-book

import AOCUtils
import Algorithms
import Foundation

@main
struct Day13 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day13", withExtension: "txt")!
    ).trimmingCharacters(
      in: .newlines
    ).components(separatedBy: "\n\n").map {
      $0.components(separatedBy: "\n").map { Array($0) }
    }

    print("part1: \(part1(patterns: data))")
    print("part2: \(part2(patterns: data))")
  }

  static func hammingDistance(s1: [Character], s2: [Character]) -> Int {
    zip(s1, s2).filter { $0 != $1 }.count
  }

  static func findMirror(in pattern: [[Character]], maxSmudges: Int = 0) -> Int {
    var mirror = 0
    for (low, high) in (0..<pattern.count).adjacentPairs() {
      var isValid = true
      var distances = [Int]()

      for (nextLow, nextHigh) in zip(
        pattern.prefix(through: low).reversed(), pattern.suffix(from: high))
      {
        distances.append(hammingDistance(s1: nextLow, s2: nextHigh))
        if distances.last! > maxSmudges {
          isValid = false
          break
        }
      }

      if isValid && distances.reduce(0, +) == maxSmudges {
        mirror = high
        break
      }
    }
    return mirror
  }

  static func part1(patterns: [[[Character]]]) -> Int {
    patterns.map {
      findMirror(in: $0) * 100 + findMirror(in: transpose($0))
    }.reduce(0, +)
  }

  static func part2(patterns: [[[Character]]]) -> Int {
    patterns.map {
      findMirror(in: $0, maxSmudges: 1) * 100 + findMirror(in: transpose($0), maxSmudges: 1)
    }.reduce(0, +)
  }
}
