// The Swift Programming Language
// https://docs.swift.org/swift-book

import AOCUtils
import Foundation

struct RockMap: Hashable {
  var roundRocks = Set<Point>()
  var cubeRocks = Set<Point>()
  var mapRows: Int
  var rowLength: Int

  init(input: [String]) {
    mapRows = input.count
    rowLength = input.first!.count
    input.enumerated().forEach { (x, row) in
      row.enumerated().forEach { (y, c) in
        if c == "#" {
          cubeRocks.insert(Point(x, y))
        } else if c == "O" {
          roundRocks.insert(Point(x, y))
        }
      }
    }
  }

  var cycleCache = [Set<Point>: Set<Point>]()

  mutating func cycle() {
    if let res = cycleCache[roundRocks] {
      roundRocks = res
      return
    }

    let old = roundRocks

    moveNorth()
    moveWest()
    moveSouth()
    moveEast()

    cycleCache[old] = roundRocks
  }

  var northCache = [Set<Point>: Set<Point>]()

  mutating func moveNorth() {
    if let res = northCache[roundRocks] {
      roundRocks = res
      return
    }

    let sortedRoundRocks = Array(roundRocks).sorted(by: { $0.x * 1000 + $0.y < $1.x * 1000 + $1.y })
    let newRoundRocks = sortedRoundRocks.reduce(into: Set<Point>()) { newRoundRocks, roundRock in
      for x in (0..<roundRock.x).reversed() {
        if cubeRocks.contains(Point(x, roundRock.y))
          || newRoundRocks.contains(Point(x, roundRock.y))
        {
          newRoundRocks.insert(Point(x + 1, roundRock.y))
          return
        }
      }
      newRoundRocks.insert(Point(0, roundRock.y))
    }
    assert(newRoundRocks.count == roundRocks.count)

    northCache[roundRocks] = newRoundRocks
    roundRocks = newRoundRocks
  }

  var eastCache = [Set<Point>: Set<Point>]()

  mutating func moveEast() {
    if let res = eastCache[roundRocks] {
      roundRocks = res
      return
    }

    let sortedRoundRocks = Array(roundRocks).sorted(by: { $0.x + $0.y * 1000 > $1.x + $1.y * 1000 })
    let newRoundRocks = sortedRoundRocks.reduce(into: Set<Point>()) { newRoundRocks, roundRock in
      for y in (roundRock.y..<rowLength) {
        if cubeRocks.contains(Point(roundRock.x, y))
          || newRoundRocks.contains(Point(roundRock.x, y))
        {
          newRoundRocks.insert(Point(roundRock.x, y - 1))
          return
        }
      }
      newRoundRocks.insert(Point(roundRock.x, rowLength - 1))
    }
    assert(newRoundRocks.count == roundRocks.count)

    eastCache[roundRocks] = newRoundRocks
    roundRocks = newRoundRocks
  }

  var southCache = [Set<Point>: Set<Point>]()

  mutating func moveSouth() {
    if let res = southCache[roundRocks] {
      roundRocks = res
      return
    }

    let sortedRoundRocks = Array(roundRocks).sorted(by: { $0.x * 1000 + $0.y > $1.x * 1000 + $1.y })
    let newRoundRocks = sortedRoundRocks.reduce(into: Set<Point>()) { newRoundRocks, roundRock in
      for x in (roundRock.x..<mapRows) {
        if cubeRocks.contains(Point(x, roundRock.y))
          || newRoundRocks.contains(Point(x, roundRock.y))
        {
          newRoundRocks.insert(Point(x - 1, roundRock.y))
          return
        }
      }
      newRoundRocks.insert(Point(mapRows - 1, roundRock.y))
    }
    assert(newRoundRocks.count == roundRocks.count)

    southCache[roundRocks] = newRoundRocks
    roundRocks = newRoundRocks
  }

  var westCache = [Set<Point>: Set<Point>]()

  mutating func moveWest() {
    if let res = westCache[roundRocks] {
      roundRocks = res
      return
    }

    let sortedRoundRocks = Array(roundRocks).sorted(by: { $0.x + $0.y * 1000 < $1.x + $1.y * 1000 })
    let newRoundRocks = sortedRoundRocks.reduce(into: Set<Point>()) { newRoundRocks, roundRock in
      for y in (0..<roundRock.y).reversed() {
        if cubeRocks.contains(Point(roundRock.x, y))
          || newRoundRocks.contains(Point(roundRock.x, y))
        {
          newRoundRocks.insert(Point(roundRock.x, y + 1))
          return
        }
      }
      newRoundRocks.insert(Point(roundRock.x, 0))
    }
    assert(newRoundRocks.count == roundRocks.count)

    westCache[roundRocks] = newRoundRocks
    roundRocks = newRoundRocks
  }

  func structuralLoad() -> Int {
    roundRocks.map { mapRows - $0.x }.reduce(0, +)
  }
}

@main
struct Day14 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day14", withExtension: "txt")!
    ).trimmingCharacters(
      in: .newlines
    ).components(separatedBy: "\n")

    print("part1: \(part1(data: data))")
    print("part2: \(part2(data: data))")
  }

  static func part1(data: [String]) -> Int {
    var rockMap = RockMap(input: data)
    rockMap.moveNorth()
    return rockMap.structuralLoad()
  }

  static func part2(data: [String]) -> Int {
    var rockMap = RockMap(input: data)

    var loopCache = [Set<Point>]()

    var i = 0
    var maxCount = 1_000_000_000
    var loopResolved = false
    while i < maxCount {
      rockMap.cycle()
      let loopIndex = loopCache.firstIndex(of: rockMap.roundRocks)
      if !loopResolved && loopIndex != nil {
        loopResolved = true
        maxCount = (maxCount - i) % (i - loopIndex!)
        i = 0
      }
      loopCache.append(rockMap.roundRocks)
      i += 1
    }

    return rockMap.structuralLoad()
  }
}
