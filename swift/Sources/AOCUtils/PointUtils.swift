import Algorithms
import Foundation

public struct Point2D: Hashable, Comparable {
  public var x: Int
  public var y: Int

  public init(_ x: Int, _ y: Int) {
    self.x = x
    self.y = y
  }

  public func flipped() -> Point2D {
    Point2D(y, x)
  }

  public static func + (left: Point2D, right: Point2D) -> Point2D {
    Point2D(left.x + right.x, left.y + right.y)
  }

  public static func - (left: Point2D, right: Point2D) -> Point2D {
    Point2D(left.x - right.x, left.y - right.y)
  }

  public static func < (lhs: Point2D, rhs: Point2D) -> Bool {
    lhs.x * 1000 + lhs.y < rhs.x * 1000 + rhs.y
  }

  public func abs() -> Point2D {
    Point2D(Swift.abs(x), Swift.abs(y))
  }

  public func manhattanDistance(to: Point2D) -> Int {
    let absDiff = (self - to).abs()
    return absDiff.x + absDiff.y
  }

  public func move(dir: Direction, count: Int = 1) -> Point2D {
    switch dir {
    case .n:
      return self + Point2D(-count, 0)
    case .e:
      return self + Point2D(0, count)
    case .s:
      return self + Point2D(count, 0)
    case .w:
      return self + Point2D(0, -count)
    }
  }
}

public typealias Point = Point2D

public enum Direction2D: CaseIterable {
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

public typealias Direction = Direction2D

extension [Point2D] {
  public func areaOfPolygon() -> Int {
    // shoelace formula
    abs(
      self.adjacentPairs().reduce(0) {
        $0 + (($1.0.x * $1.1.y) - ($1.1.x * $1.0.y))
      }) / 2
  }
}


// 3D Point Utils

public struct Point3D: Hashable, Comparable {
  public var x: Int
  public var y: Int
  public var z: Int

  public init(_ x: Int, _ y: Int, _ z: Int) {
    self.x = x
    self.y = y
    self.z = z
  }

  public static func + (left: Point3D, right: Point3D) -> Point3D {
    Point3D(left.x + right.x, left.y + right.y, left.z + right.z)
  }

  public static func - (left: Point3D, right: Point3D) -> Point3D {
    Point3D(left.x - right.x, left.y - right.y, left.z - right.z)
  }
  
  public static func < (lhs: Point3D, rhs: Point3D) -> Bool {
    lhs.z < rhs.z
  }

  public func move(dir: Direction3D, count: Int = 1) -> Point3D {
    switch dir {
    case .n:
      return self + Point3D(-count, 0, 0)
    case .e:
      return self + Point3D(0, count, 0)
    case .s:
      return self + Point3D(count, 0, 0)
    case .w:
      return self + Point3D(0, -count, 0)
    case .u:
      return self + Point3D(0, 0, count)
    case .d:
      return self + Point3D(0, 0, -count)
    }
  }
}

public enum Direction3D {
  case n
  case e
  case s
  case w
  case u
  case d

  public func flipped() -> Direction3D {
    switch self {
    case .n:
      return .s
    case .e:
      return .w
    case .s:
      return .n
    case .w:
      return .e
    case .u:
      return .d
    case .d:
      return .u
    }
  }
}
