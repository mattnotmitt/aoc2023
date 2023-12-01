// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@main
struct Day1 {
    static func main() {
        do {
            let data = try String(contentsOfFile: "./Sources/day1/1.txt").components(separatedBy: "\n")
            print("part1: \(part1(data: data))")
            print("part2: \(part2(data: data))")
        } catch {

        }
    }

    static func part1(data: [String]) -> Int {
        var sum = 0
        for line in data {
            let numeric: String = line.filter({(c: Character) -> Bool in 
                c.isNumber
            })
            sum += Int(numeric.prefix(1) + numeric.suffix(1)) ?? 0
        }

        return sum
    }

    static let numbers = [
        "one": 1,
        "two": 2,
        "three": 3,
        "four": 4,
        "five": 5,
        "six": 6,
        "seven": 7,
        "eight": 8,
        "nine": 9
    ]

    static func part2(data: [String]) -> Int {
        var sum = 0
        for line in data {
            var nums: [Int] = []
            for (i, c) in line.enumerated() {
                if c.isNumber {
                    nums.append(Int(String(c))!)
                } else {
                    let startIndex = line.index(line.startIndex, offsetBy: i)
                    for (t, n) in numbers {    
                        if line[startIndex...].starts(with: t) {
                            nums.append(n)
                            break
                        }
                    }
                }
            }
            sum += nums.first! * 10 + nums.last!
        }

        return sum
    }
}