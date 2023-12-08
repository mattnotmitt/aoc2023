// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Parsing

struct PuzzleData {
  var str: String
  var num2: Int

  init(str: String, num2: Int) {
    self.str = str
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
    let dataParser: some Parser<Substring, PuzzleData> = Parse(PuzzleData.init) {
      Prefix(3).map(String.init)
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
