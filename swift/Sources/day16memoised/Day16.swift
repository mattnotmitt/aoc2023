// The Swift Programming Language
// https://docs.swift.org/swift-book

import AOCUtils
import Foundation

struct Ray : Hashable {
  var location: Point
  var direction: Point
  
  init(loc: Point, dir: Point) {
    self.location = loc
    self.direction = dir
  }
}

struct ExploreMemoised {
  var grid: [[Character]]
  var cache = [Ray:[Point]]()
  
  mutating func explore(with rayIn: Ray, _ exploredJunctions: inout Set<Ray>) -> [Point] {
    if let res = cache[rayIn] {
      return res
    }
    
    var energised = [Point]()
    var ray = rayIn
    var rayExplored = false
    
    while ray.location.x >= 0 && ray.location.x < grid.count
      && ray.location.y >= 0 && ray.location.y < grid.first!.count
    {
      energised.append(ray.location)
      
      switch grid[ray.location.x][ray.location.y] {
      case "\\":
        ray.direction = ray.direction.flipped()
      case "/":
        ray.direction = Point(0, 0) - ray.direction.flipped()
      case "|" where ray.direction.abs().y == 1:
        rayExplored = true
        if exploredJunctions.contains(ray) {
          break
        }
        exploredJunctions.insert(ray)
        energised.append(contentsOf: explore(with: Ray(loc: ray.location + Point(1, 0), dir: Point(1, 0)), &exploredJunctions))
        energised.append(contentsOf: explore(with: Ray(loc: ray.location + Point(-1, 0), dir: Point(-1, 0)), &exploredJunctions))
      case "-" where ray.direction.abs().x == 1:
        rayExplored = true
        if exploredJunctions.contains(ray) {
          break
        }
        exploredJunctions.insert(ray)
        energised.append(contentsOf: explore(with: Ray(loc: ray.location + Point(0, 1), dir: Point(0, 1)), &exploredJunctions))
        energised.append(contentsOf: explore(with: Ray(loc: ray.location + Point(0, -1), dir: Point(0, -1)), &exploredJunctions))
      default: break;
      }
      if rayExplored {
        break
      }
      ray.location = ray.location + ray.direction
    }
    
    cache[rayIn] = energised
    return energised
  }
}

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

  static func part1(grid: [[Character]]) -> Int {
    var memo = ExploreMemoised(grid: grid)
    var exploredJunctions = Set<Ray>()
    return Set(memo.explore(with: Ray(loc: Point(0, 0), dir: Point(0, 1)), &exploredJunctions)).count
  }

  static func part2(grid: [[Character]]) -> Int {
    var memo = ExploreMemoised(grid: grid)
    let val =
      ((0..<grid.count).flatMap {
        [
          Ray(loc: Point($0, 0), dir: Point(0, 1)),
          Ray(loc: Point($0, grid.first!.count - 1), dir: Point(0, -1)),
        ]
      }
      + (0..<grid.first!.count).flatMap {
        [
          Ray(loc: Point(0, $0), dir: Point(1, 0)),
          Ray(loc: Point(grid.count - 1, $0), dir: Point(-1, 0)),
        ]
      })
      .map {
        var exploredJunctions = Set<Ray>()
        return Set(memo.explore(with: $0, &exploredJunctions)).count }.max()!
    return val
  }
}
