// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

struct CacheKey: Hashable {
  init(_ rest: String, _ pattern: [Int], _ groupCount: Int) {
    self.rest = rest
    self.pattern = pattern
    self.groupCount = groupCount
  }

  var rest: String
  var pattern: [Int]
  var groupCount: Int
}

struct MemoisedSolutionSolver {
  var cache = [CacheKey: Int]()
  var cacheHits = 0
  var cacheMisses = 0

  mutating func countSolutions(rest: String, pattern: [Int], groupCount: Int) -> Int {
    let cacheKey = CacheKey(rest, pattern, groupCount)

    if let res = cache[cacheKey] {
      return res
    }

    // if we're at the end of the string, check if everything is finished
    if rest.isEmpty {
      return (groupCount == 0 && pattern.isEmpty) ? 1 : 0
    }

    var solutions = 0

    for char in rest.first == "?" ? ["#", "."] : [rest.first!] {
      if char == "#" {
        // if group is still valid
        if groupCount < pattern.first ?? 0 {
          solutions += countSolutions(
            rest: String(rest.dropFirst()), pattern: pattern, groupCount: groupCount + 1)
        }
        // if char == "." and still in damaged group
      } else if groupCount > 0 {
        // and the group matches the current group in the provided patterns
        if !pattern.isEmpty && groupCount == pattern.first! {
          solutions += countSolutions(
            rest: String(rest.dropFirst()), pattern: Array(pattern.dropFirst()), groupCount: 0)
        }
        // if nothing interesting, continue
      } else {
        solutions += countSolutions(rest: String(rest.dropFirst()), pattern: pattern, groupCount: 0)
      }
    }

    cache[cacheKey] = solutions
    return solutions
  }
}

@main
struct Day12 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day12", withExtension: "txt")!
    )
    .trimmingCharacters(in: .newlines)
    .components(separatedBy: .newlines)

    let rows: [(String, [Int])] = data.map {
      let parts = $0.components(separatedBy: " ")
      return (parts[0], parts[1].components(separatedBy: ",").map { Int($0)! })
    }

    print("part1: \(part1(rows: rows))")
    print("part2: \(part2(rows: rows))")
  }

  static func part1(rows: [(String, [Int])]) -> Int {
    var solver = MemoisedSolutionSolver()
    return rows.enumerated().map { (i, row) in
      // add a working spring at the end to finish the groups
      solver.countSolutions(rest: row.0 + ".", pattern: row.1, groupCount: 0)
    }.reduce(0, +)
  }

  static func part2(rows: [(String, [Int])]) -> Int {
    var solver = MemoisedSolutionSolver()
    return rows.enumerated().map { (i, row) in
      solver.countSolutions(
        rest: Array(repeating: row.0, count: 5).joined(separator: "?") + ".",
        pattern: Array(Array(repeating: row.1, count: 5).joined()),
        groupCount: 0
      )
    }.reduce(0, +)
  }
}
