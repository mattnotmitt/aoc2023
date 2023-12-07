// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

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

  init(from line: String) {
    let lineArr = line.components(separatedBy: .whitespaces)
    cards = lineArr[0]
    bid = Int(lineArr[1])!
    type = Hand.getHandType(cards: cards)
  }

  static func getHandType(cards: String) -> HandType {
    let cardsSet = Set(cards)
    let letterCounts = cardsSet.map { card in cards.filter { $0 == card }.count }
    if cardsSet.count == 1 {
      return .fiveOfAKind
    } else if cardsSet.count == 2 {
      if letterCounts.max() == 4 {
        return .fourOfAKind
      }
      return .fullHouse
    } else if cardsSet.count == 3 {
      if letterCounts.max() == 3 {
        return .threeOfAKind
      }
      return .twoPair
    } else if cardsSet.count == 4 && letterCounts.max() == 2 {
      return .onePair
    }
    return .highCard
  }

  static let cardStrength = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]

  func compareToHand(_ rhs: Hand) -> Bool {
    // true if rhs is greater than lhs
    if self.type != rhs.type {
      return self.type.rawValue < rhs.type.rawValue
    }
    for (l, r) in zip(self.cards, rhs.cards) {
      if l != r {
        return Hand.cardStrength.firstIndex(of: String(l))! > Hand.cardStrength.firstIndex(
          of: String(r))!
      }
    }
    return false
  }
}

struct JokerifiedHand {
  var cards: String
  var bid: Int

  var type: HandType

  init(from line: String) {
    let lineArr = line.components(separatedBy: .whitespaces)
    cards = lineArr[0]
    bid = Int(lineArr[1])!
    type = JokerifiedHand.getHandType(cards: cards)
  }

  static func getHandType(cards: String) -> HandType {
    let letterCounts = Set(cards).map { card in cards.filter { $0 == card }.count }
    let jokerCount = cards.filter { $0 == "J" }.count
    switch letterCounts.sorted(by: >) {
    case [5]:
      return .fiveOfAKind
    case [4, 1]:
      return jokerCount > 0 ? .fiveOfAKind : .fourOfAKind
    case [3, 2]:
      return jokerCount > 0 ? .fiveOfAKind : .fullHouse
    case [3, 1, 1]:
      return jokerCount > 0 ? .fourOfAKind : .threeOfAKind
    case [2, 2, 1]:
      return jokerCount == 2 ? .fourOfAKind : (jokerCount == 1 ? .fullHouse : .twoPair)
    case [2, 1, 1, 1]:
      return jokerCount > 0 ? .threeOfAKind : .onePair
    case [1, 1, 1, 1, 1]:
      return jokerCount == 1 ? .onePair : .highCard
    default:
      return .highCard
    }
  }

  static let cardStrength = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]

  func compareToHand(_ rhs: JokerifiedHand) -> Bool {
    // true if rhs is greater than lhs
    if self.type != rhs.type {
      return self.type.rawValue < rhs.type.rawValue
    }
    for (l, r) in zip(self.cards, rhs.cards) {
      if l != r {
        return JokerifiedHand.cardStrength.firstIndex(of: String(l))! > JokerifiedHand.cardStrength
          .firstIndex(of: String(r))!
      }
    }
    return false
  }
}

@main
struct Day7 {
  static func main() {
    var data = try! String(contentsOfFile: "./Sources/day7/day7.txt").components(separatedBy: "\n")
    //    var data = try! String(contentsOfFile:       "./Sources/day7/day7_example.txt").components(separatedBy: "\n")
    data.removeLast()
    let hands = data.map { Hand(from: $0) }
    print("part1: \(part1(hands: hands))")
    let jokerifiedHands = data.map { JokerifiedHand(from: $0) }
    print("part2: \(part2(hands: jokerifiedHands))")
  }

  static func part1(hands: [Hand]) -> Int {
    let rankedHands =
      hands
      .sorted(by: { $0.compareToHand($1) })
      .enumerated()

    return rankedHands.map { ($0 + 1) * $1.bid }
      .reduce(0, +)
  }

  static func part2(hands: [JokerifiedHand]) -> Int {
    let rankedHands =
      hands
      .sorted(by: { $0.compareToHand($1) })
      .enumerated()

    return rankedHands.map { ($0 + 1) * $1.bid }
      .reduce(0, +)
  }
}
