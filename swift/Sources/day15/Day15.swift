// The Swift Programming Language
// https://docs.swift.org/swift-book

import Collections
import Foundation

@main
struct Day0 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day15", withExtension: "txt")!
    ).trimmingCharacters(
      in: .newlines
    ).components(separatedBy: ",")

    print("part1: \(part1(data: data))")
    print("part2: \(part2(data: data))")
  }

  @inline(__always)
  static func HASH(_ str: String) -> Int {
    str.reduce(
      0,
      { (res, c) in
        ((res + Int(c.asciiValue!)) * 17) % 256
      })
  }

  static func part1(data: [String]) -> Int {
    data.lazy.map(HASH).reduce(0, +)
  }

  static func part2(data: [String]) -> Int {
    var boxes = Array(repeating: OrderedDictionary<String, Int>(), count: 256)
    data.forEach { str in
      let remove = str.contains("-")
      let parts = str.components(separatedBy: ["-", "="])
      let label = parts[0]
      let boxIndex = HASH(label)
      if remove {
        if boxes[boxIndex][label] != nil {
          boxes[boxIndex][label] = nil
        }
      } else {
        let focalLength = Int(parts[1])
        boxes[boxIndex][label] = focalLength
      }
    }
    return boxes.enumerated().reduce(0) { (res, box) in
      res
        + box.element.enumerated().reduce(0) { (boxRes, lens) in
          boxRes + (box.offset + 1) * (lens.offset + 1) * lens.element.value
        }
    }
  }
}
