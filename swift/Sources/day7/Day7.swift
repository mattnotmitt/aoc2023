// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Parsing

enum HandType: Int {
  case highCard = 1
  case onePair = 2
  case twoPair = 3
  case threeOfAKind = 4
  case fullHouse = 5
  case fourOfAKind = 6
  case fiveOfAKind = 7
}

struct Hand {
  var cards: String
  var bid: Int

  var type: HandType
  var jokerfiedType: HandType

  init(cards: String, bid: Int) {
    self.cards = cards
    self.bid = bid
    type = Hand.getHandType(cards: cards, jokerfied: false)
    jokerfiedType = Hand.getHandType(cards: cards, jokerfied: true)
  }

  static func getHandType(cards: String, jokerfied: Bool) -> HandType {
    let letterCounts = Set(cards).map { card in cards.filter { $0 == card }.count }
    let jokerCount = jokerfied ? cards.filter { $0 == "J" }.count : 0
    switch letterCounts.sorted(by: >) {
    case [5],
      [4, 1] where jokerCount > 0,
      [3, 2] where jokerCount > 0:
      return .fiveOfAKind
    case [4, 1],
      [3, 1, 1] where jokerCount > 0,
      [2, 2, 1] where jokerCount == 2:
      return .fourOfAKind
    case [3, 2],
      [2, 2, 1] where jokerCount == 1:
      return .fullHouse
    case [3, 1, 1],
      [2, 1, 1, 1] where jokerCount > 0:
      return .threeOfAKind
    case [2, 2, 1]:
      return .twoPair
    case [2, 1, 1, 1],
      [1, 1, 1, 1, 1] where jokerCount > 0:
      return .onePair
    default:
      return .highCard
    }
  }

  static let cardStrength = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
  static let jokerfiedCardStrength = [
    "A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J",
  ]

  func compareToHand(_ rhs: Hand, jokerfied: Bool) -> Bool {
    // true if rhs is greater than lhs
    let leftType = jokerfied ? self.jokerfiedType : self.type
    let rightType = jokerfied ? rhs.jokerfiedType : rhs.type
    let strengths = jokerfied ? Hand.jokerfiedCardStrength : Hand.cardStrength

    if leftType != rightType {
      return leftType.rawValue < rightType.rawValue
    }
    for (l, r) in zip(self.cards, rhs.cards) {
      if l != r {
        return strengths.firstIndex(of: String(l))! > strengths.firstIndex(
          of: String(r))!
      }
    }
    return false
  }
}

@main
struct Day7 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day7", withExtension: "txt")!
    )
    .trimmingCharacters(in: .newlines)
    // let data = try! String(contentsOf: Bundle.module.url(forResource: "day7_example", withExtension: "txt")!)
    //   .trimmingCharacters(in: .newlines)

    // Parsing
    let handParser = Parse.init(input: Substring.self) {
      Hand(cards: String($0), bid: $1)
    } with: {
      Prefix(5)
      " "
      Int.parser()
    }

    let hands = try! Many {
      handParser
    } separator: {
      "\n"
    }.parse(data)

    print("part1: \(part1(hands: hands))")
    print("part2: \(part2(hands: hands))")
  }

  static func part1(hands: [Hand]) -> Int {
    let rankedHands =
      hands
      .sorted(by: { $0.compareToHand($1, jokerfied: false) })
      .enumerated()

    return rankedHands.map { ($0 + 1) * $1.bid }
      .reduce(0, +)
  }

  static func part2(hands: [Hand]) -> Int {
    let rankedHands =
      hands
      .sorted(by: { $0.compareToHand($1, jokerfied: true) })
      .enumerated()

    return rankedHands.map { ($0 + 1) * $1.bid }
      .reduce(0, +)
  }
}
