// The Swift Programming Language
// https://docs.swift.org/swift-book

import AOCUtils
import Foundation
import Parsing

struct DigPlanStep {
  var direction: Direction
  var count: Int
  var direction2: Direction
  var count2: Int

  init(dirStr: String, count: Int, colourCode: String) {
    switch dirStr {
    case "U": direction = .n
    case "R": direction = .e
    case "D": direction = .s
    case "L": direction = .w
    default:
      direction = .n
      assert(false, "never should get here")
    }
    self.count = count
    switch colourCode.last {
    case "0": direction2 = .e
    case "1": direction2 = .s
    case "2": direction2 = .w
    case "3": direction2 = .n
    default:
      direction2 = .n
      assert(false, "never should get here")
    }
    self.count2 = Int(colourCode.dropLast(), radix: 16)!
  }
}

@main
struct Day18 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day18", withExtension: "txt")!
    ).trimmingCharacters(
      in: .newlines)

    // Parsing
    let dataParser: some Parser<Substring, DigPlanStep> = Parse(DigPlanStep.init) {
      Prefix(1).map(String.init)
      " "
      Int.parser()
      " (#"
      Prefix(6).map(String.init)
      ")"
    }

    let DigPlanStep = try! Many {
      dataParser
    } separator: {
      "\n"
    }.parse(data)

    print("part1: \(part1(data: DigPlanStep))")
    print("part2: \(part2(data: DigPlanStep))")
  }

  static func part1(data: [DigPlanStep]) -> Int {
    var perimeter = 0
    let allDigVertices = data.reduce(into: [Point(0, 0)]) {
      perimeter += $1.count
      return $0.append($0.last!.move(dir: $1.direction, count: $1.count))
    }
    assert(allDigVertices.first == allDigVertices.last)
    return 1 + perimeter / 2 + allDigVertices.areaOfPolygon()
  }

  static func part2(data: [DigPlanStep]) -> Int {
    var perimeter = 0
    let allDigVertices = data.reduce(into: [Point(0, 0)]) {
      perimeter += $1.count2
      return $0.append($0.last!.move(dir: $1.direction2, count: $1.count2))
    }
    assert(allDigVertices.first == allDigVertices.last)
    return 1 + perimeter / 2 + allDigVertices.areaOfPolygon()
  }
}
