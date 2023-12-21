// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import AOCUtils

struct Node {
  var point: Point
  var stepCount: Int
  var prev: Point
  var dir: Direction?
}

@main
struct Day21 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day21", withExtension: "txt")!
    )
      .trimmingCharacters(in: .newlines)
      .components(separatedBy: "\n").map {
        Array($0)
      }

    print("part1: \(part1(data: data))")
    print("part2: \(part2(data: data))")
  }
  
  static func bfs(grid: [[Character]], start: Point, steps: Int = 64) -> Int {
    let root = Node(point: start, stepCount: 0, prev: Point(-1,-1))
    
    var Q = [Node]()
    var allNodes = [Point: Node]()
    Q.append(root)
    allNodes[root.point] = (root)
    
    while !Q.isEmpty {
      let curr = Q.removeFirst()
      if curr.stepCount > steps {
        return Set(allNodes.values.filter{$0.stepCount % 2 == (steps % 2 == 0 ? 0 : 1)}.map{$0.point}).count
      }
      
      for dir in [Direction]([.n, .e, .s, .w]) {
        if curr.dir?.flipped() == dir {
          continue
        }
        
        let nextLoc = curr.point.move(dir: dir)
        if grid[nextLoc.x %% grid.count][nextLoc.y %% grid.first!.count] == "#"
        {
          continue
        }
        
        
        if allNodes[nextLoc] == nil {
          let neighbour = Node(
            point: nextLoc, stepCount: curr.stepCount + 1, prev: curr.point, dir: dir
          )
          Q.append(neighbour)
          allNodes[nextLoc] = (neighbour)
        }
      }
    }
    return 0
  }

  static func part1(data: [[Character]]) -> Int {
    let joined = data.joined()
    let startIndex = joined.distance(from: joined.startIndex, to: joined.firstIndex(of: "S")!)
    let startPoint = Point(startIndex / data.count, startIndex % data.count)
    assert(data[startPoint.x][startPoint.y] == "S")
    return bfs(grid: data, start: startPoint, steps: 64)
  }

  static func part2(data: [[Character]]) -> Int {
    0
  }
}
