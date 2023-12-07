// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Parsing

struct PuzzleData {
  var num: Int
  var num2: Int

  init(num: Int, num2: Int) {
    self.num = num
    self.num2 = num2
  }
}

@main
struct Day0 {
  static func main() {
    //    let data = try! String(contentsOf: Bundle.module.url(forResource: "day0", withExtension: "txt")!).trimmingCharacters(
    //      in: .newlines)
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day0_example", withExtension: "txt")!
    ).trimmingCharacters(
      in: .newlines)

    // Parsing
    let dataParser = Parse.init(input: Substring.self) {
      PuzzleData(num: $0, num2: $1)
    } with: {
      Int.parser()
      " "
      Int.parser()
    }

    let puzzleData = try! Many {
      dataParser
    } separator: {
      "\n"
    }.parse(data)

    print("part1: \(part1(data: puzzleData))")
    print("part2: \(part2(data: puzzleData))")
  }

  static func part1(data: [PuzzleData]) -> Int {
    0
  }

  static func part2(data: [PuzzleData]) -> Int {
    0
  }
}
