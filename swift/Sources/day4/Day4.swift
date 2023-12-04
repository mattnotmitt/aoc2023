// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

class Card {
  var id: Int
  var winningNumbers = Set<Int>()
  var scratchedNumbers = Set<Int>()

  var matchCount: Int
  var score: Int

  init(_ line: String) {
    let lineArr = line.components(separatedBy: ": ")
    id = Int(lineArr[0].split(separator: " ")[1])!
    let gameArr = lineArr[1].components(separatedBy: " | ")
    winningNumbers = Set(
      gameArr[0].components(separatedBy: " ").filter { $0.count > 0 }.map { Int($0)! }
    )
    scratchedNumbers = Set(
      gameArr[1].components(separatedBy: " ").filter { $0.count > 0 }.map { Int($0)! }
    )

    matchCount = winningNumbers.intersection(self.scratchedNumbers).count
    score = matchCount == 0 ? 0 : Int(pow(Float(2), Float(matchCount - 1)))
  }
}

@main
struct Day4 {
  static func main() {
    var data = try! String(contentsOfFile: "./Sources/day4/day4.txt").components(separatedBy: "\n")
    data.removeAll(where: { $0.count == 0 })
    let cards: [Card] = data.map { Card($0) }
    print("part1: \(part1(cards: cards))")
    print("part2: \(part2(cards: cards))")
  }

  static func part1(cards: [Card]) -> Int {
    cards.reduce(0) { $0 + $1.score }
  }

  static func part2(cards: [Card]) -> Int {
    var countMap = cards.reduce(into: [Int: Int](), { $0[$1.id] = 1 })
    for card in cards where card.matchCount > 0 {
      for i in card.id + 1...card.id + card.matchCount {
        countMap[i]! += countMap[card.id]!
      }
    }

    return countMap.values.reduce(0, +)
  }
}
