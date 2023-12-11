// The Swift Programming Language
// https://docs.swift.org/swift-book

import AOCUtils
import Foundation

struct Tile {
  var point: Point
  var pipe: Character
  var prev: Point
  var step: Int

  init(point: Point, pipe: Character, prev: Point, step: Int) {
    self.point = point
    self.pipe = pipe
    self.prev = prev
    self.step = step
  }

  func nextPoint() -> Point {
    let d = (point - prev)
    switch pipe {
    case "|", "-":
      return point + d
    case "L", "7":
      return point + d.flipped()
    case "J", "F":
      return point - d.flipped()
    default:
      return Point(-1, -1)
    }
  }

}

@main
struct Day10 {
  static func main() {
    let grid = try! String(
      contentsOf: Bundle.module.url(forResource: "day10", withExtension: "txt")!
    )
    .trimmingCharacters(in: .newlines)
    .components(separatedBy: "\n")
    .map { Array($0) }

    let path = findPath(grid: grid)
    print("part1: \(part1(path: path))")
    print("part2: \(part2(path: path, gridDimensions: (grid.count, grid.first!.count)))")
  }

  static func findPath(grid: [[Character]]) -> [Tile] {
    // find s & search around for horizontal or vertical pipe
    let gridWidth = grid.first!.count
    let start: Point = Array(grid.joined())
      .firstIndex(of: "S")
      .map { Point(Int($0) / gridWidth, Int($0) % gridWidth) }!
    var path: [Tile] = []
    for (point, pipe) in [
      (Point(start.x + 1, start.y), "|"), (Point(start.x - 1, start.y), "|"),
      (Point(start.x, start.y + 1), "-"),
      (Point(start.x, start.y - 1), "-"),
    ] {
      if grid[point.x][point.y] == pipe.first! {
        path.append(Tile(point: point, pipe: pipe.first!, prev: start, step: 1))
        break
      }
    }
    // follow pipe until back at S & keep count
    while path.last!.pipe != "S" {
      let nextPoint = path.last!.nextPoint()
      path.append(
        Tile(
          point: nextPoint,
          pipe: grid[nextPoint.x][nextPoint.y],
          prev: path.last!.point,
          step: path.last!.step + 1
        ))
    }

    // 'S' should have step 0
    path[path.count - 1].step = 0

    return path
  }

  static func part1(path: [Tile]) -> Int {
    return path.count / 2
  }

  static func part2(path: [Tile], gridDimensions: (Int, Int)) -> Int {
    let pathByPoint = path.reduce(into: [Point: Tile]()) { $0[$1.point] = $1 }

    // nonzero winding rule
    // https://en.wikipedia.org/wiki/Nonzero-rule
    var enclosedTiles = 0
    // technically this should be per row (or per-ray) but it should be zero after each
    // row is processed
    var windingNumber = 0
    for x in 0...gridDimensions.0 {
      // for each row, scan through each tile and keep track of the winding number when path found
      for y in 0...gridDimensions.1 {
        if let tile = pathByPoint[Point(x, y)] {
          // if it's on the path, check if we can find out the direction
          if let tileBelow = pathByPoint[Point(x + 1, y)] {
            if tile.prev == tileBelow.point {
              // clockwise
              windingNumber += 1
            } else if tileBelow.prev == tile.point {
              // counter-clockwise
              windingNumber -= 1
            }
          }
        } else {
          // if the winding number isn't zero, it's inside the loop
          if windingNumber != 0 {
            enclosedTiles += 1
          }
        }
      }
      assert(windingNumber == 0)
    }
    return enclosedTiles
  }
}
