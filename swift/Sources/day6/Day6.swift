// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@main
struct Day0 {
  static func main() {
    //    var data = try! String(contentsOfFile: "./Sources/day6/day6_example.txt").components(separatedBy: "\n")
    var data = try! String(contentsOfFile: "./Sources/day6/day6.txt").components(separatedBy: "\n")
    data.removeLast()
    let vals1 = data.map {
      $0.components(separatedBy: ": ")[1].components(separatedBy: " ").filter { $0.count > 0 }.map {
        Int($0)!
      }
    }
    let races1 = Array(zip(vals1[0], vals1[1]))
    print("part1: \(part1(races: races1))")
    let race = data.map {
      Int($0.components(separatedBy: ": ")[1].filter { $0 != " " })!
    }
    print("part2: \(part2(race: (race[0], race[1])))")
  }

  static func canWin(distance: Int, timeHeld: Int, totalTime: Int) -> Bool {
    ((totalTime - timeHeld) * timeHeld) > distance
  }

  static func part1(races: [(Int, Int)]) -> Int {
    races.map { (t, d) in
      var lower = -1
      var upper = -1
      for i in 0...t / 2 {
        if lower == -1 && canWin(distance: d, timeHeld: i, totalTime: t) {
          lower = i
        }
        if upper == -1 && canWin(distance: d, timeHeld: t - i, totalTime: t) {
          upper = t - i
        }
      }
      return Range(lower...upper).count
    }.reduce(1, *)
  }

  static func part2(race: (Int, Int)) -> Int {
    let (t, d) = race
    var lower = -1
    var upper = -1
    for i in 0...t / 2 {
      if lower == -1 && canWin(distance: d, timeHeld: i, totalTime: t) {
        lower = i
      }
      if upper == -1 && canWin(distance: d, timeHeld: t - i, totalTime: t) {
        upper = t - i
      }
    }
    return Range(lower...upper).count
  }
}
