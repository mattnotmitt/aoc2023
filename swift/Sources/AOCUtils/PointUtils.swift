import Algorithms

public struct Point: Hashable, Comparable {
  public var x: Int
  public var y: Int

  public init(_ x: Int, _ y: Int) {
    self.x = x
    self.y = y
  }

  public func flipped() -> Point {
    Point(y, x)
  }

  public static func + (left: Point, right: Point) -> Point {
    Point(left.x + right.x, left.y + right.y)
  }

  public static func - (left: Point, right: Point) -> Point {
    Point(left.x - right.x, left.y - right.y)
  }

  public static func < (lhs: Point, rhs: Point) -> Bool {
    lhs.x * 1000 + lhs.y < rhs.x * 1000 + rhs.y
  }

  public func abs() -> Point {
    Point(Swift.abs(x), Swift.abs(y))
  }

  public func manhattanDistance(to: Point) -> Int {
    let absDiff = (self - to).abs()
    return absDiff.x + absDiff.y
  }

  public func move(dir: Direction, count: Int = 1) -> Point {
    switch dir {
    case .n:
      return self + Point(-count, 0)
    case .e:
      return self + Point(0, count)
    case .s:
      return self + Point(count, 0)
    case .w:
      return self + Point(0, -count)
    }
  }
}

public enum Direction {
  case n
  case e
  case s
  case w

  public func flipped() -> Direction {
    switch self {
    case .n:
      return .s
    case .e:
      return .w
    case .s:
      return .n
    case .w:
      return .e
    }
  }
}

extension [Point] {
  public func areaOfPolygon() -> Int {
    // shoelace formula
    abs(
      self.adjacentPairs().reduce(0) {
        $0 + (($1.0.x * $1.1.y) - ($1.1.x * $1.0.y))
      }) / 2
  }
}
