// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

struct Day12Data {

}

@main
struct Day12 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day12_example", withExtension: "txt")!
    ).trimmingCharacters(
      in: .newlines
    ).components(separatedBy: .newlines)

    let rows: [(String, [Int])] = data.map {
      let parts = $0.components(separatedBy: " ")
      return (parts[0], parts[1].components(separatedBy: ",").map { Int($0)! })
    }

    print("part1: \(part1(rows: rows))")
    print("part2: \(part2(rows: rows))")
  }

  static func isValidArrangement(_ record: String, _ pattern: [Int]) -> Bool {
    var queue = String(record)
    var recordPattern = [Int]()
    var currCount = 0

    while queue.count > 0 && queue.first != "?" {
      if "#" == queue.removeFirst() {
        currCount += 1
      } else if currCount > 0 {
        recordPattern.append(currCount)
        currCount = 0
      }
    }

    if currCount != 0 {
      recordPattern.append(currCount)
    }

    if recordPattern == pattern || (recordPattern.isEmpty && !queue.isEmpty) {
      return true
    } else if queue.count == 0 || recordPattern.count > pattern.count {
      return false
    } else {
      return !queue.isEmpty
        && recordPattern.dropLast() == pattern.prefix(upTo: recordPattern.count - 1)
        && recordPattern.last! <= pattern[recordPattern.count - 1]
    }
  }

  static func generateArrangementsAndCheck(_ record: String, _ pattern: [Int]) -> Int {
    if isValidArrangement(record, pattern) {
      if record.allSatisfy({ $0 != "?" }) {
        return 1
      } else {
        let qmark = record.dropFirst().firstIndex(of: "?")!
        var rec = String(record)
        rec.replaceSubrange(qmark...qmark, with: ".")
        let sum = generateArrangementsAndCheck(rec, pattern)
        rec.replaceSubrange(qmark...qmark, with: "#")
        return sum + generateArrangementsAndCheck(rec, pattern)
      }
    } else {
      return 0
    }
  }

  static func part1(rows: [(String, [Int])]) -> Int {
    rows.enumerated().map { (i, row) in
      return generateArrangementsAndCheck(row.0, row.1)
    }.reduce(0, +)
  }

  static func part2(rows: [(String, [Int])]) -> Int {
    rows.enumerated().map { (i, row) in
      var record = Array(repeating: row.0, count: 5).joined(separator: "?")
      var pattern = Array(Array(repeating: row.1, count: 5).joined())
      print(i)
      return generateArrangementsAndCheck(record, pattern)
    }.reduce(0, +)
  }
}
