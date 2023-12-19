// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Parsing

struct PuzzleData {
  var workflows: [String: Workflow]
  var ratings: [Rating]

  init(workflows: [Workflow], ratings: [Rating]) {
    self.workflows = workflows.reduce(into: [String: Workflow]()) {
      $0[$1.name] = $1
    }
    self.ratings = ratings
  }
}

struct Workflow {
  var name: String
  var rules: [Rule]
  var fallthroughWorkflow: String

  init(name: String, rules: [Rule], defaultWorkflow: String) {
    self.name = name
    self.rules = rules
    self.fallthroughWorkflow = defaultWorkflow
  }

  func evaluate(_ rating: Rating) -> String {
    for rule in rules {
      if let workflow = rule.evaluate(rating) {
        return workflow
      }
    }
    return fallthroughWorkflow
  }
}

struct Rule {
  var target: String
  var operation: Operation
  var value: Int
  var workflow: String

  init(target: String, operation: String, value: Int, workflow: String) {
    self.target = target
    self.operation = Operation(rawValue: operation) ?? Operation.err
    self.value = value
    self.workflow = workflow
  }

  func evaluate(_ rating: Rating) -> String? {
    var targetValue = -1
    switch target {
    case "x": targetValue = rating.x
    case "m": targetValue = rating.m
    case "a": targetValue = rating.a
    case "s": targetValue = rating.s
    default: assert(false, "Shouldn't ever get here")
    }
    switch operation {
    case .gt: return targetValue > value ? workflow : nil
    case .lt: return targetValue < value ? workflow : nil
    case .err: assert(false, "Shouldn't ever get here")
    }
    return ""
  }
}

enum Operation: String {
  case gt = ">"
  case lt = "<"
  case err = "X"
}

struct Rating {
  var x: Int
  var m: Int
  var a: Int
  var s: Int

  func sum() -> Int {
    x + m + a + s
  }
}

@main
struct Day19 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day19", withExtension: "txt")!
    )
    .trimmingCharacters(in: .newlines)  // remove trailing whitespace
    .replacing(#/,(\w*\})/#, with: { ";\($0.1)" })  // replace final comma in workflow with semicolon for easy parsing

    // Parsing
    let ruleParser: some Parser<Substring, Rule> = Parse(Rule.init) {
      Prefix(1).map(String.init)  // category
      Prefix(1).map(String.init)  // operator
      Int.parser()  // value
      ":"  // workflow
      Prefix { $0 != "," && $0 != ";" }.map(String.init)
    }

    let workflowParser: some Parser<Substring, Workflow> = Parse(Workflow.init) {
      PrefixUpTo("{").map(String.init)  // workflow name
      "{"
      Many {  // rule
        ruleParser
      } separator: {
        ","
      }
      ";"
      PrefixUpTo("}").map(String.init)  // fallthrough workflow
      "}"
    }

    let ratingsParser: some Parser<Substring, Rating> = Parse(Rating.init) {
      "{x="
      Int.parser()
      ",m="
      Int.parser()
      ",a="
      Int.parser()
      ",s="
      Int.parser()
      "}"
    }

    let puzzleData = try! Parse(PuzzleData.init) {
      Many {
        workflowParser
      } separator: {
        Whitespace(1, .vertical)
      } terminator: {
        Whitespace(2, .vertical)
      }
      Many {
        ratingsParser
      } separator: {
        Whitespace(1, .vertical)
      }
    }.parse(data)

    print("part1: \(part1(ratings: puzzleData.ratings, workflows: puzzleData.workflows))")
    print("part2: \(part2(workflows: puzzleData.workflows))")
  }

  static func part1(ratings: [Rating], workflows: [String: Workflow]) -> Int {
    ratings.reduce(0) { res, rating in
      var next = "in"
      while !["A", "R"].contains(next) {
        next = workflows[next]!.evaluate(rating)
      }
      return res + (next == "A" ? rating.sum() : 0)
    }
  }

  static func evaluate(
    workflows: inout [String: Workflow], at curr: String, ranges: [String: Range<Int>]
  ) -> Int {
    // End state
    if curr == "A" {
      return ranges.values.reduce(1) { $0 * $1.count }
    } else if curr == "R" {
      return 0
    }

    var combinations = 0
    var fallthroughRanges = ranges

    for rule in workflows[curr]!.rules {
      // if we're checking multiple rules we use the fallthrough ranges from the previous rule
      var passRanges = fallthroughRanges
      switch rule.operation {
      case .gt:
        passRanges[rule.target] = passRanges[rule.target]!.clamped(to: rule.value + 1..<4001)
        fallthroughRanges[rule.target] = fallthroughRanges[rule.target]!.clamped(
          to: 1..<rule.value + 1)
      case .lt:
        passRanges[rule.target] = passRanges[rule.target]!.clamped(to: 1..<rule.value)
        fallthroughRanges[rule.target] = fallthroughRanges[rule.target]!.clamped(
          to: rule.value..<4001)
      case .err: assert(false, "Shouldn't ever get here")
      }
      // evaluate pass state of this rule
      combinations += evaluate(
        workflows: &workflows, at: rule.workflow, ranges: passRanges)
    }
    // evaluate fallthrough of this workflow
    combinations += evaluate(
      workflows: &workflows, at: workflows[curr]!.fallthroughWorkflow, ranges: fallthroughRanges)
    return combinations
  }

  static func part2(workflows _workflows: [String: Workflow]) -> Int {
    var workflows = _workflows
    return evaluate(
      workflows: &workflows, at: "in",
      ranges: [
        "x": Range(1...4000),
        "m": Range(1...4000),
        "a": Range(1...4000),
        "s": Range(1...4000),
      ])
  }
}
