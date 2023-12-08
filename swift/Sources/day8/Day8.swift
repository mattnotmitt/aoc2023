// The Swift Programming Language
// https://docs.swift.org/swift-book

import AOCUtils
import Foundation
import Parsing

struct Node {
  var name: String
  var left: String
  var right: String

  init(name: String, left: String, right: String) {
    self.name = name
    self.left = left
    self.right = right
  }
}

struct PuzzleData {
  var route: String
  var nodeMap: [String: Node]

  init(route: String, nodes: [Node]) {
    self.route = route
    self.nodeMap = nodes.reduce(
      into: [String: Node](),
      {
        $0[$1.name] = $1
      })
  }
}

@main
struct Day8 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day8", withExtension: "txt")!
    ).trimmingCharacters(in: .newlines)

    // Parsing
    let nodeParser: some Parser<Substring, Node> = Parse(Node.init) {
      Prefix(3).map(String.init)
      " = ("
      Prefix(3).map(String.init)
      ", "
      Prefix(3).map(String.init)
      ")"
    }

    let puzzleParser: some Parser<Substring, PuzzleData> = Parse(PuzzleData.init) {
      Prefix { $0 != "\n" }.map(String.init)
      "\n\n"
      Many {
        nodeParser
      } separator: {
        "\n"
      }
    }

    let puzzleData = try! puzzleParser.parse(data)

    print("part1: \(part1(puzzleData))")
    print("part2: \(part2(puzzleData))")
  }

  static func part1(_ data: PuzzleData) -> Int {
    let nodes = data.nodeMap
    let route = data.route

    var currNode = "AAA"
    var stepCount = 0
    while currNode != "ZZZ" {
      if route[route.index(route.startIndex, offsetBy: stepCount % route.count)] == "R" {
        currNode = nodes[currNode]!.right
      } else {
        currNode = nodes[currNode]!.left
      }
      stepCount += 1
    }
    return stepCount
  }

  static func part2(_ data: PuzzleData) -> Int {
    let nodes = data.nodeMap
    let route = data.route

    var currNodes: [String] = nodes.keys.filter { $0.last == "A" }
    var foundEnd: [Int] = currNodes.map { _ in -1 }
    var stepCount = 0

    while foundEnd.min() == -1 {
      let routeStep = route[route.index(route.startIndex, offsetBy: stepCount % route.count)]
      for (i, currNode) in currNodes.enumerated().filter({ foundEnd[$0.0] == -1 }) {
        if routeStep == "R" {
          currNodes[i] = nodes[currNode]!.right
        } else {
          currNodes[i] = nodes[currNode]!.left
        }
        if currNodes[i].last == "Z" {
          foundEnd[i] = stepCount + 1
        }
      }
      stepCount += 1
    }
    return foundEnd.reduce(1, lcm)
  }
}
