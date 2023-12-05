// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

struct CategoryRange {
  var sourceRange: Range<Int>
  var destinationStartIndex: Int

  init(_ line: String) {
    let mapArr = line.components(separatedBy: " ").map({ Int($0)! })
    destinationStartIndex = mapArr[0]
    sourceRange = mapArr[1]..<mapArr[1] + mapArr[2]
  }

  func contains(_ val: Int) -> Bool {
    sourceRange.contains(val)
  }

  func fullyContains(_ inputRange: Range<Int>) -> Bool {
    inputRange.clamped(to: sourceRange) == inputRange
  }

  func destinationIndex(for val: Int) -> Int {
    val - sourceRange.lowerBound + destinationStartIndex
  }

  func destinationRangeFromSourceBounds(lower lowerBound: Int, upper upperBound: Int) -> Range<Int>
  {
    destinationIndex(for: lowerBound)..<destinationIndex(for: upperBound)
  }

  func resolveDestinationRange(for inputRange: Range<Int>) -> (Range<Int>?, [Range<Int>]) {
    if fullyContains(inputRange) {
      // If inputRange is fully inside this range, transform it to the dest.
      return (
        destinationRangeFromSourceBounds(
          lower: inputRange.lowerBound, upper: inputRange.upperBound),
        []
      )
    } else if contains(inputRange.lowerBound) {
      // lowerBound within sourceRange, upper outside
      return (
        destinationRangeFromSourceBounds(
          lower: inputRange.lowerBound, upper: sourceRange.upperBound),
        [sourceRange.upperBound..<inputRange.upperBound]
      )
    } else if contains(inputRange.upperBound - 1) {
      // upperBound within sourceRange, lower outside
      return (
        destinationRangeFromSourceBounds(
          lower: sourceRange.lowerBound, upper: inputRange.upperBound),
        [inputRange.lowerBound..<sourceRange.lowerBound]
      )
    } else if inputRange.overlaps(sourceRange) {
      // sourceRange entirely contained within inputRange
      return (
        destinationRangeFromSourceBounds(
          lower: sourceRange.lowerBound, upper: sourceRange.upperBound),
        [
          inputRange.lowerBound..<sourceRange.lowerBound,
          sourceRange.upperBound..<inputRange.upperBound,
        ]
      )
    } else {
      return (nil, [])
    }
  }
}

struct CategoryMap {
  var mapRanges: [CategoryRange]

  init(_ mapBlock: String) {
    mapRanges = mapBlock.components(separatedBy: "\n")
      .filter { $0.count > 0 }
      .dropFirst().map { CategoryRange($0) }
  }

  func toDestinationRanges(_ sourceRanges: [Range<Int>]) -> [Range<Int>] {
    sourceRanges.flatMap { startRange in
      var rangeQueue = [startRange]
      var destinationRanges = [Range<Int>]()
      while rangeQueue.count > 0 {
        let sourceRange = rangeQueue.removeFirst()
        var stored = false
        for mapRange in mapRanges {
          let (destinationRange, newSourceRanges) = mapRange.resolveDestinationRange(
            for: sourceRange
          )
          if destinationRange != nil {
            assert(
              sourceRange.count
                == newSourceRanges.reduce(destinationRange?.count ?? 0) { $0 + $1.count }
            )
            destinationRanges.append(destinationRange!)
            rangeQueue.append(contentsOf: newSourceRanges)
            stored = true
            break
          }
        }
        // If they aren't broken down or fully matched, they should just be passed onwards
        if !stored {
          destinationRanges.append(sourceRange)
        }
      }
      return destinationRanges
    }
  }
}

@main
struct Day5 {
  static func main() {
    var data = try! String(
      contentsOfFile: "./Sources/day5/day5.txt"
    ).components(separatedBy: "\n\n")
    //    var data = try! String(
    //      contentsOfFile: "./Sources/day5/day5_example.txt"
    //    ).components(separatedBy: "\n\n")
    let seeds: [Int] =
      data
      .removeFirst()
      .components(separatedBy: ": ")[1]
      .components(separatedBy: " ")
      .map { Int($0)! }
    let maps: [CategoryMap] = data.map { CategoryMap($0) }
    print("part1: \(part1(seeds: seeds, maps: maps.map{$0.mapRanges}))")
    print("part2: \(part2(seeds: seeds, maps: maps))")
  }

  static func part1(seeds: [Int], maps: [[CategoryRange]]) -> Int {
    seeds.map { seed in
      maps.reduce(seed) { res, mapRanges in
        mapRanges.first(where: { $0.contains(res) })?.destinationIndex(for: res) ?? res
      }
    }.min()!
  }

  static func part2(seeds: [Int], maps: [CategoryMap]) -> Int {
    let seedRanges = stride(from: 0, to: seeds.count - 1, by: 2).map {
      seeds[$0]..<seeds[$0] + seeds[$0 + 1]
    }
    let locationRanges = seedRanges.flatMap { seedRange in
      maps.reduce([seedRange]) { (sourceRanges: [Range<Int>], categoryMap: CategoryMap) in
        categoryMap.toDestinationRanges(sourceRanges)
      }
    }
    return locationRanges.map { $0.lowerBound }.min()!
  }
}
