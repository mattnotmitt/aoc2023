// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Parsing
import AOCUtils

struct Hailstone {
  var pos: DoubleP3
  var vel: DoubleP3
  
  var slope2D: Double
  var intercept2D: Double
  
  init(pos: DoubleP3, vel: DoubleP3) {
    self.pos = pos
    self.vel = vel
    
    self.slope2D = vel.y / vel.x
    self.intercept2D =  pos.y - slope2D * pos.x
  }
}

typealias DoubleP3 = (x: Double, y: Double, z: Double)

@main
struct Day24 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day24", withExtension: "txt")!
    ).trimmingCharacters(
      in: .newlines).filter{$0 != " "}

    // Parsing
    let pointParser: some Parser<Substring, DoubleP3> = Parse {
      DoubleP3(x: $0, y: $1, z: $2)
    } with: {
      Double.parser()
      ","
      Double.parser()
      ","
      Double.parser()
    }
    
    let hailstoneParser: some Parser<Substring, Hailstone> = Parse(Hailstone.init) {
      pointParser
      "@"
      pointParser
    }

    let hailstones = try! Many {
      hailstoneParser
    } separator: {
      "\n"
    }.parse(data)

    print("part1: \(part1(hailstones))")
    print("part2: \(part2(hailstones))")
  }

  static func inFuture(stone: Hailstone, point: (Double, Double)) -> Bool {
    return ((point.0 - stone.pos.x) / stone.vel.x) >= 0.0
  }
  
  static func part1(_ hailstones: [Hailstone]) -> Int {
    let range = 200000000000000.0...400000000000000.0
//    let range = 7.0...27.0
    return hailstones.combinations(ofCount: 2)
    .filter { pair in
      let s1 = pair[0]
      let s2 = pair[1]
      if s1.slope2D != s2.slope2D {
        // not parallel or same line
        let x = (s2.intercept2D - s1.intercept2D) / (s1.slope2D - s2.slope2D)
        let y = s1.slope2D * x + s1.intercept2D
        
        if range.contains(x) && range.contains(y) 
            && inFuture(stone: s1, point: (x, y)) 
            && inFuture(stone: s2, point: (x, y))  {
          return true
        }
      }
      return false
    }
    .count
    // 15575 too low
  }

  static func part2(_ hailstones: [Hailstone]) -> Int {
    // using wolfram alpha
    // first three hailstones was all that was necessary
    // result was 155272940103072, 386989974246822, 214769025967097 @ 81, -179, 250
    return 155272940103072 + 386989974246822 + 214769025967097
  }
}
