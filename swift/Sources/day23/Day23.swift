// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import AOCUtils

@main
struct Day23 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day23_example", withExtension: "txt")!
    )
    .trimmingCharacters(in: .newlines)
    .components(separatedBy: "\n").map {
      Array($0)
    }

    print("part1: \(part1(data: data))")
    print("part2: \(part2(data: data))")
  }

  static func longestPath(grid: [[Character]], start: Point) -> Int {
    var curr: [(Point, [Point])] = [(start, [start])]
    var steps = 0
    while !curr.isEmpty {
        var newBatch: [(Point, [Point])] = []
        for (next, seen) in curr {
          let directions: [Direction] = switch grid[next.x][next.y] {
            case ".": Direction.allCases
            case "^": [.n]
            case ">": [.e]
            case "v": [.s]
            case "<": [.w]
            default: fatalError()
            }
            for direction in directions {
              let loc = next.move(dir: direction)
              if !((0..<grid.count).contains(loc.x) && (0..<grid.last!.count).contains(loc.y))
                  || seen.contains(loc)
                  || grid[loc.x][loc.y] == "#" {
                continue
              }
              newBatch.append((loc, seen + [loc]))
            }
        }
        curr = newBatch
        steps += 1
    }
    return steps - 1
  }
  
  static func part1(data: [[Character]]) -> Int {
    longestPath(grid: data, start: Point(0, 1))
  }

  static func part2(data: [[Character]]) -> Int {
    0
  }
}
