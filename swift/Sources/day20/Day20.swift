// The Swift Programming Language
// https://docs.swift.org/swift-book

import AOCUtils
import Foundation
import Parsing

enum State {
  case low
  case high

  func flip() -> State {
    self == .low ? .high : .low
  }
}

typealias Pulse = (src: String, dest: String, state: State)

protocol Module {
  var name: String { get }
  var destinations: [String] { get }
  mutating func receiveAndSendPulses(pulse: Pulse) -> [Pulse]
}

struct Broadcaster: Module {
  var name = "broadcaster"
  var destinations: [String]

  init(destinations: [String]) {
    self.destinations = destinations
  }

  mutating func receiveAndSendPulses(pulse: Pulse) -> [Pulse] {
    destinations.map { (src: name, dest: $0, state: pulse.state) }
  }
}

struct FlipFlop: Module {
  var name: String
  var destinations: [String]
  var state: State = .low

  init(name: String, destinations: [String]) {
    self.name = name
    self.destinations = destinations
  }

  mutating func receiveAndSendPulses(pulse: Pulse) -> [Pulse] {
    if pulse.state == .low {
      state = state.flip()
      return destinations.map { (src: name, dest: $0, state: state) }
    }
    return []
  }
}

struct Conjunction: Module {
  var name: String
  var destinations: [String]
  var receivedStates = [String: State]()

  init(name: String, destinations: [String]) {
    self.name = name
    self.destinations = destinations
  }

  mutating func setReceivedStates(_ states: [String: State]) {
    receivedStates = states
  }

  mutating func receiveAndSendPulses(pulse: Pulse) -> [Pulse] {
    receivedStates[pulse.src] = pulse.state
    let newState: State = receivedStates.values.allSatisfy { $0 == .high } ? .low : .high
    return destinations.map { (src: name, dest: $0, state: newState) }
  }
}

struct PuzzleData {
  var modules: [String: Module]

  init(modules: [Module]) {
    var mapModules = modules.reduce(into: [String: Module]()) {
      $0[$1.name] = $1
    }

    // Set initial states for Conjunction sources to low
    for con in mapModules.values.filter({ $0 is Conjunction }) {
      mapModules.values.filter { $0.destinations.contains(con.name) }
        .forEach {
          _ = mapModules[con.name]!.receiveAndSendPulses(
            pulse: (src: $0.name, dest: con.name, state: .low))
        }
    }
    self.modules = mapModules
  }
}

@main
struct Day20 {
  static func main() {
    let data = try! String(
      contentsOf: Bundle.module.url(forResource: "day20", withExtension: "txt")!
    ).trimmingCharacters(
      in: .newlines)

    let destinationParser: some Parser<Substring, [String]> = Parse([String].init) {
      Many {
        Prefix { $0 != "," && $0 != "\n" }.map(String.init)
      } separator: {
        ", "
      }
    }

    let broadcasterParser: some Parser<Substring, Module> = Parse(Broadcaster.init) {
      "broadcaster"
      " -> "
      destinationParser
    }

    let flipFlopParser: some Parser<Substring, Module> = Parse(FlipFlop.init) {
      "%"
      Prefix { $0 != " " }.map(String.init)
      " -> "
      destinationParser
    }

    let conjunctionParser: some Parser<Substring, Module> = Parse(Conjunction.init) {
      "&"
      Prefix { $0 != " " }.map(String.init)
      " -> "
      destinationParser
    }

    // Parsing
    let dataParser: some Parser<Substring, PuzzleData> = Parse(PuzzleData.init) {
      Many {
        OneOf {
          broadcasterParser
          flipFlopParser
          conjunctionParser
        }
      } separator: {
        Whitespace(1, .vertical)
      }
    }
    let puzzleData = try! dataParser.parse(data)
    print("part1: \(part1(data: puzzleData))")
    print("part2: \(part2(data: puzzleData))")
  }

  static func part1(data: PuzzleData) -> Int {
    var modules = data.modules
    var pulseCount = (low: 0, high: 0)
    for _ in 0..<1000 {
      var pulses: [Pulse] = [(src: "button", dest: "broadcaster", state: .low)]
      while !pulses.isEmpty {
        let pulse = pulses.removeFirst()
        // print("\(pulse.src) -\(pulse.state)-> \(pulse.dest)")
        pulseCount.low += pulse.state == .low ? 1 : 0
        pulseCount.high += pulse.state == .high ? 1 : 0
        if modules[pulse.dest] != nil {
          pulses.append(contentsOf: modules[pulse.dest]!.receiveAndSendPulses(pulse: pulse))
        }
      }
    }
    return pulseCount.low * pulseCount.high
  }

  static func part2(data: PuzzleData) -> Int {
    var modules = data.modules
    var buttonPresses = 0

    // Find Conjunction that feeds into rx
    let rxConj =
      modules.values.first { $0 is Conjunction && $0.destinations.contains("rx") } as! Conjunction
    var rxConjSources = rxConj.receivedStates.keys.reduce(into: [String: Int]()) { $0[$1] = -1 }

    while !rxConjSources.values.allSatisfy({ $0 != -1 }) {
      buttonPresses += 1
      var pulses: [Pulse] = [(src: "button", dest: "broadcaster", state: .low)]
      while !pulses.isEmpty {
        let pulse = pulses.removeFirst()
        if rxConjSources.keys.contains(pulse.src) && pulse.state == .high {
          rxConjSources[pulse.src] = buttonPresses
        }
        if modules[pulse.dest] != nil {
          pulses.append(contentsOf: modules[pulse.dest]!.receiveAndSendPulses(pulse: pulse))
        }
      }
    }
    return rxConjSources.values.reduce(1, lcm)
  }
}
