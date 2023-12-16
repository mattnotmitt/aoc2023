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
}

public enum Moves {
  case n
  case e
  case s
  case w
}
