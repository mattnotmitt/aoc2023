// The Swift Programming Language
// https://docs.swift.org/swift-book

import Algorithms
import Foundation
import Parsing

struct OasisData {
  var sequence: [Int]

  init(sequence: [Int]) {
    self.sequence = sequence
  }

  func extrapolateSequenceForward() -> [Int] {
    var allSeqs = [sequence]
    while !allSeqs.last!.allSatisfy({ $0 == 0 }) {
      allSeqs.append(allSeqs.last!.adjacentPairs().map { $1 - $0 })
    }
    var revSeqs = Array(allSeqs.dropLast().reversed())
    for i in 0..<(revSeqs.count - 1) {
      revSeqs[i + 1].append(revSeqs[i + 1].last! + revSeqs[i].last!)
    }
    return revSeqs.last!
  }

  func extrapolateSequenceBackward() -> [Int] {
    var allSeqs = [sequence]
    while !allSeqs.last!.allSatisfy({ $0 == 0 }) {
      allSeqs.append(allSeqs.last!.adjacentPairs().map { $1 - $0 })
    }
    var revSeqs = Array(allSeqs.dropLast().reversed())
    for i in 0..<(revSeqs.count - 1) {
      revSeqs[i + 1].prepend(revSeqs[i + 1].first! - revSeqs[i].first!)
    }
    return revSeqs.last!
  }
}

@main
struct Day9 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day9", withExtension: "txt")!
    ).trimmingCharacters(in: .newlines)

    // Parsing
    let sequenceParser: some Parser<Substring, OasisData> = Parse.init(OasisData.init) {
      Many {
        Int.parser()
      } separator: {
        " "
      }
    }

    let puzzleData = try! Many {
      sequenceParser
    } separator: {
      "\n"
    }.parse(data)

    print("part1: \(part1(data: puzzleData))")
    print("part2: \(part2(data: puzzleData))")
  }

  static func part1(data: [OasisData]) -> Int {
    data.map { $0.extrapolateSequenceForward().last! }.reduce(0, +)
  }

  static func part2(data: [OasisData]) -> Int {
    data.map { $0.extrapolateSequenceBackward().first! }.reduce(0, +)
  }
}
