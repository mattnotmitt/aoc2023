// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import AOCUtils

struct NodeReference: Hashable {
  var loc: Point
  var dir: Direction
  var straightCount: Int
}

class Node: Comparable, Hashable {
  var loc: Point
  var dir: Direction
  var straightCount: Int
  var gScore: Int
  var fScore: Int
  
  init(loc: Point, dir: Direction, straightCount: Int, gScore: Int, fScore: Int) {
    self.loc = loc
    self.dir = dir
    self.straightCount = straightCount
    self.gScore = gScore
    self.fScore = fScore
  }
  
  static func < (lhs: Node, rhs: Node) -> Bool {
    lhs.fScore < rhs.fScore
  }
  
  static func == (lhs: Node, rhs: Node) -> Bool {
    lhs.loc == rhs.loc && lhs.dir == rhs.dir && lhs.straightCount == rhs.straightCount
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(loc)
    hasher.combine(dir)
    hasher.combine(straightCount)
  }
  
  func getReference() -> NodeReference {
    NodeReference(loc: loc, dir: dir, straightCount: straightCount)
  }
}

@main
struct Day17 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day17", withExtension: "txt")!
    ).trimmingCharacters(
      in: .newlines).components(separatedBy: "\n").map{ $0.map{Int(String($0))!}}

    print("part1: \(part1(grid: data))")
    print("part2: \(part2(grid: data))")
  }
  
  static func printPath(max: (Int,Int), cameFrom: [NodeReference: NodeReference], end: NodeReference) {
    var allPoints = [end.loc]
    var curr = end
    while let prev = cameFrom[curr] {
      allPoints.append(prev.loc)
      curr = prev
    }
    
    for x in 0..<max.0 {
      var line = ""
      for y in 0..<max.1 {
        line += allPoints.contains(Point(x,y)) ? "#" : "."
      }
      print(line)
    }
  }
  
  static func runAStar(grid: [[Int]], start: Point, goal: Point, minStraight: Int = 0, maxStraight: Int = 3) -> Int {
    var allNodes = [
      Node(
        loc: start, dir: .e, straightCount: 0,
        gScore: 0, fScore: start.manhattanDistance(to: goal)
      ),
      Node(
        loc: start, dir: .s, straightCount: 0,
        gScore: 0, fScore: start.manhattanDistance(to: goal)
      )
    ].reduce(into: [NodeReference: Node]()) { $0[$1.getReference()] = $1 }
    var cameFrom = [NodeReference: NodeReference]()
    var openSet = PriorityQueue(allNodes.values)
    
    while !openSet.isEmpty() {
      let curr = openSet.popMin()
      
      if curr.loc == goal && curr.straightCount >= minStraight && curr.straightCount <= maxStraight {
//          printPath(max: (grid.count, grid.first!.count), cameFrom: cameFrom, end: curr.getReference())
          return curr.gScore
      }
      
      for dir in [Direction]([.n, .e, .s, .w]) {
        if curr.dir.flipped() == dir ||
          (curr.dir != dir && curr.straightCount < minStraight) ||
          (curr.dir == dir && curr.straightCount == maxStraight) {
          continue
        }
        let nextLoc = curr.loc.move(dir: dir)
        if !(nextLoc.x >= 0 && nextLoc.x < grid.count
            && nextLoc.y >= 0 && nextLoc.y < grid.first!.count) {
          continue
        }
        
        let neighbour = Node(
          loc: nextLoc, dir: dir,
          straightCount: dir == curr.dir ? curr.straightCount + 1 : 1,
          gScore: curr.gScore + grid[nextLoc.x][nextLoc.y],
          fScore: 0
        )
        
        if neighbour.gScore < allNodes[neighbour.getReference()]?.gScore ?? Int.max {
          allNodes[neighbour.getReference()] = neighbour
          cameFrom[neighbour.getReference()] = curr.getReference()
          neighbour.fScore = neighbour.gScore + nextLoc.manhattanDistance(to: goal)
          if !openSet.contains(neighbour) {
            openSet.insert(neighbour)
          }
        }
      }
    }
    
    return -1
  }

  static func part1(grid: [[Int]]) -> Int {
    runAStar(grid: grid, start: Point(0,0), goal: Point(grid.count - 1, grid.first!.count - 1))
  }

  static func part2(grid: [[Int]]) -> Int {
    runAStar(
      grid: grid, start: Point(0,0), goal: Point(grid.count - 1, grid.first!.count - 1),
      minStraight: 4, maxStraight: 10
    )
  }
}
