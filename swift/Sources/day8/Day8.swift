// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Parsing
import AOCUtils

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

@main
struct Day8 {
  static func main() {
      let data = try! String(contentsOf: Bundle.module.url(forResource: "day8", withExtension: "txt")!).trimmingCharacters(
        in: .newlines).components(separatedBy: "\n\n")
//    let data = try! String(
//      contentsOf: Bundle.module.url(forResource: "day8_example", withExtension: "txt")!
//    ).trimmingCharacters(
//      in: .newlines).components(separatedBy: "\n\n")
      
    // Parsing
    let lineParser = Parse.init(input: Substring.self) {
      Prefix(3)
      " = ("
      Prefix(3)
      ", "
      Prefix(3)
      ")"
    }
    let nodeParser = lineParser.map{
      Node(name: String($0), left: String($1), right: String($2))
    }

    let nodes = try! Many {
      nodeParser
    } separator: {
      "\n"
    }.parse(data[1]).reduce(into: [String: Node](), {
      $0[$1.name] = $1
    })

    print("part1: \(part1(route: data[0], nodes: nodes))")
    print("part2: \(part2(route: data[0], nodes: nodes))")
  }

  static func part1(route: String, nodes: [String: Node]) -> Int {
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

  static func part2(route: String, nodes: [String: Node]) -> Int {
    var currNodes: [String] = nodes.keys.filter{$0.last == "A"}
    var foundEnd: [Int] = currNodes.map{_ in -1}
    var stepCount = 0
    
    while foundEnd.min() == -1 {
      let routeStep = route[route.index(route.startIndex, offsetBy: stepCount % route.count)]
      for (i, currNode) in currNodes.enumerated().filter({foundEnd[$0.0] == -1}) {
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
