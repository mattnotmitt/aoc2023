// The Swift Programming Language
// https://docs.swift.org/swift-book

import AOCUtils
import Foundation

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

  static func bfs(grid: [[Character]], start: Point, steps: Int = 64) -> [Node] {
    let root = Node(point: start, stepCount: 0, prev: Point(-1, -1))

    var Q = [Node]()
    var allNodes = [Point: Node]()
    Q.append(root)
    allNodes[root.point] = (root)

    while !Q.isEmpty {
      let curr = Q.removeFirst()
      if curr.stepCount > steps {
        return Array(allNodes.values)
      }

      for dir in [Direction]([.n, .e, .s, .w]) {
        if curr.dir?.flipped() == dir {
          continue
        }

        let nextLoc = curr.point.move(dir: dir)
        if grid[nextLoc.x %% grid.count][nextLoc.y %% grid.first!.count] == "#" {
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
    return []
  }

  static func part1(data: [[Character]]) -> Int {
    let joined = data.joined()
    let startIndex = joined.distance(from: joined.startIndex, to: joined.firstIndex(of: "S")!)
    let startPoint = Point(startIndex / data.count, startIndex % data.count)
    assert(data[startPoint.x][startPoint.y] == "S")
    return bfs(grid: data, start: startPoint, steps: 64).compactMap { getCount(n: $0, steps: 64) }
      .count
  }

  static func getCount(n: Node, steps: Int) -> Point? {
    (0..<131).contains(n.point.x) && (0..<131).contains(n.point.y) && n.stepCount <= steps
      && n.stepCount % 2 == (steps % 2 == 0 ? 0 : 1) ? n.point : nil
  }

  static func part2(data: [[Character]]) -> Int {
    let joined = data.joined()
    let startIndex = joined.distance(from: joined.startIndex, to: joined.firstIndex(of: "S")!)
    let startPoint = Point(startIndex / data.count, startIndex % data.count)
    assert(data[startPoint.x][startPoint.y] == "S")

    let stepCount = 26_501_365

    // 26501365 / 131 (data.count) = 202300
    let width = stepCount / data.count
    // 26501365 % 131 (data.count) = 65
    // get odd state for completed tile
    let oddState = bfs(grid: data, start: startPoint, steps: data.count).compactMap {
      getCount(n: $0, steps: data.count)
    }.count
    let evenState = bfs(grid: data, start: startPoint, steps: data.count + 1).compactMap {
      getCount(n: $0, steps: data.count + 1)
    }.count
    // get state at 65
    let tipCount = data.count - 1
    let smEdgeCount = data.count / 2 - 1
    let lgEdgeCount = tipCount + 65

    let nState = bfs(grid: data, start: Point(130, 65), steps: tipCount).compactMap {
      getCount(n: $0, steps: tipCount)
    }.count
    let neStateSm = bfs(grid: data, start: Point(130, 0), steps: smEdgeCount).compactMap {
      getCount(n: $0, steps: smEdgeCount)
    }.count
    let neStateLg = bfs(grid: data, start: Point(130, 0), steps: lgEdgeCount).compactMap {
      getCount(n: $0, steps: lgEdgeCount)
    }.count
    let eState = bfs(grid: data, start: Point(65, 0), steps: tipCount).compactMap {
      getCount(n: $0, steps: tipCount)
    }.count
    let seStateSm = bfs(grid: data, start: Point(0, 0), steps: smEdgeCount).compactMap {
      getCount(n: $0, steps: smEdgeCount)
    }.count
    let seStateLg = bfs(grid: data, start: Point(0, 0), steps: lgEdgeCount).compactMap {
      getCount(n: $0, steps: lgEdgeCount)
    }.count
    let sState = bfs(grid: data, start: Point(0, 65), steps: tipCount).compactMap {
      getCount(n: $0, steps: tipCount)
    }.count
    let swStateSm = bfs(grid: data, start: Point(0, 130), steps: smEdgeCount).compactMap {
      getCount(n: $0, steps: smEdgeCount)
    }.count
    let swStateLg = bfs(grid: data, start: Point(0, 130), steps: lgEdgeCount).compactMap {
      getCount(n: $0, steps: lgEdgeCount)
    }.count
    let wState = bfs(grid: data, start: Point(65, 130), steps: tipCount).compactMap {
      getCount(n: $0, steps: tipCount)
    }.count
    let nwStateSm = bfs(grid: data, start: Point(130, 130), steps: smEdgeCount).compactMap {
      getCount(n: $0, steps: smEdgeCount)
    }.count
    let nwStateLg = bfs(grid: data, start: Point(130, 130), steps: lgEdgeCount).compactMap {
      getCount(n: $0, steps: lgEdgeCount)
    }.count
    // figure out how many of each there are
    return oddState * Int(pow(Double(width - 1), 2))  // filling
      + evenState * Int(pow(Double(width), 2))
      + (width) * (neStateSm + seStateSm + swStateSm + nwStateSm)  // small edge
      + (width - 1) * (neStateLg + seStateLg + swStateLg + nwStateLg)  // larger edge
      + nState + eState + sState + wState  // tips
  }
}
