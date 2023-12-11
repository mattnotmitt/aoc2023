public struct Point: Hashable {
  public var x: Int
  public var y: Int

  public init(_ x: Int, _ y: Int) {
    self.x = x
    self.y = y
  }

  public func flipped() -> Point {
    return Point(y, x)
  }

  public static func + (left: Point, right: Point) -> Point {
    return Point(left.x + right.x, left.y + right.y)
  }

  public static func - (left: Point, right: Point) -> Point {
    return Point(left.x - right.x, left.y - right.y)
  }

  public func abs() -> Point {
    return Point(Swift.abs(x), Swift.abs(y))
  }

  public func manhattanDistance(to: Point) -> Int {
    let absDiff = (self - to).abs()
    return absDiff.x + absDiff.y
  }
}
