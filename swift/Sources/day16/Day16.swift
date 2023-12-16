// The Swift Programming Language
// https://docs.swift.org/swift-book

import AOCUtils
import Foundation

@main
struct Day16 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day16", withExtension: "txt")!
    ).trimmingCharacters(
      in: .newlines
    ).split(separator: "\n").map { Array($0) }

    print("part1: \(part1(grid: data))")
    print("part2: \(part2(grid: data))")
  }

  static func explore(_ grid: [[Character]], with ray: (loc: Point, dir: Point)) -> Int {
    var energised = [Point]()
    var exploredJunc = [Point]()
    var unprocessedRays = [ray]
    while unprocessedRays.count > 0 {
      var ray = unprocessedRays.removeFirst()
      var rayExplored = false
      
      while ray.loc.x >= 0 && ray.loc.x < grid.count
        && ray.loc.y >= 0 && ray.loc.y < grid.first!.count
      {
        energised.append(ray.loc)
        
        switch grid[ray.loc.x][ray.loc.y] {
        case "\\":
          ray.dir = ray.dir.flipped()
        case "/":
          ray.dir = Point(0, 0) - ray.dir.flipped()
        case "|" where ray.dir.abs().y == 1:
          if exploredJunc.contains(ray.loc) {
            rayExplored = true
            break
          }
          exploredJunc.append(ray.loc)
          ray.dir = Point(1, 0)
          unprocessedRays.append((loc: ray.loc + Point(-1, 0), dir: Point(-1, 0)))
        case "-" where ray.dir.abs().x == 1:
          if exploredJunc.contains(ray.loc) {
            rayExplored = true
            break
          }
          exploredJunc.append(ray.loc)
          ray.dir = Point(0, 1)
          unprocessedRays.append((loc: ray.loc + Point(0, -1), dir: Point(0, -1)))
        default: break
        }
        if rayExplored {
          break
        }
        ray = (loc: ray.loc + ray.dir, dir: ray.dir)
      }
    }
    return Set(energised).count
  }

  static func part1(grid: [[Character]]) -> Int {
    return explore(grid, with: (Point(0, 0), Point(0, 1)))
  }

  static func part2(grid: [[Character]]) -> Int {
    return
      ((0..<grid.count).flatMap {
        [
          (loc: Point($0, 0), dir: Point(0, 1)),
          (loc: Point($0, grid.first!.count - 1), dir: Point(0, -1)),
        ]
      }
      + (0..<grid.first!.count).flatMap {
        [
          (loc: Point(0, $0), dir: Point(1, 0)),
          (loc: Point(grid.count - 1, $0), dir: Point(-1, 0)),
        ]
      })
      .map { explore(grid, with: $0) }.max()!
  }
}
