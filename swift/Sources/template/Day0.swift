// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@main
struct Day0 {
  static func main() {
    let data = try! String(contentsOfFile: "./Sources/day0/0.txt").components(separatedBy: "\n")
    print("part1: \(part1(data: data))")
    print("part2: \(part2(data: data))")
  }

  static func part1(data: [String]) -> Int {
    0
  }

  static func part2(data: [String]) -> Int {
    0
  }
}
