// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

struct MapRange {
  var sourceRange: Range<Int>
  var destStartIndex: Int
  
  init(_ line: String) {
    let mapArr = line.components(separatedBy: " ").map({ Int($0)! })
    destStartIndex = mapArr[0]
    sourceRange = mapArr[1]..<mapArr[1]+mapArr[2]
  }
  
  func isValid(val: Int) -> Bool {
    sourceRange.contains(val)
  }
  
  func destIndex(val: Int) -> Int {
    val - sourceRange.lowerBound + destStartIndex
  }
}

@main
struct Day5 {
  static func main() {
    var data = try! String(contentsOfFile: "./Sources/day5/day5.txt").components(separatedBy: "\n\n")
//    var data = try! String(contentsOfFile: "./Sources/day5/day5_example.txt").components(separatedBy: "\n\n")
    let seeds: [Int] = data
      .removeFirst()
      .components(separatedBy: ": ")[1]
      .components(separatedBy: " ")
      .map{ Int($0)! }
    let maps: [[MapRange]] = data.map{ mapBlock in
      mapBlock
        .components(separatedBy: "\n")
        .filter({ $0.count > 0 })
        .dropFirst().map({ MapRange($0) })
    }
    print("part1: \(part1(seeds: seeds, maps: maps))")
    print("part2: \(part2(seeds: seeds, maps: maps))")
  }

  static func part1(seeds: [Int], maps: [[MapRange]]) -> Int {
    seeds.map{ seed in
      return maps.reduce(seed, { res, mapRanges in
        if let range = mapRanges.first(where: {$0.isValid(val: res)}) {
          return range.destIndex(val: res)
        }
        return res
      })
    }.min()!
  }

  static func part2(seeds: [Int], maps: [[MapRange]]) -> Int {
    stride(from: 0, to: seeds.count - 1, by: 2).map{
      seeds[$0] ..< seeds[$0] + seeds[$0+1]
    }.flatMap({ seedRange in
      [Int](seedRange).map{ seed in
        maps.reduce(seed, { res, mapRanges in
          if let range = mapRanges.first(where: {$0.isValid(val: res)}) {
            return range.destIndex(val: res)
          }
          return res
        })
      }
    }).min()!
  }
}
