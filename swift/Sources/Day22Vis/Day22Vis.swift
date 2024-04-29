// The Swift Programming Language
// https://docs.swift.org/swift-book

//import Foundation
//import Parsing
//import AOCUtils
import SceneKit
import SwiftUI

//class Brick: Comparable {
//  var range: ClosedRange<Point3D>
//  var points: [Point3D]
//
//  init(frontEnd: Point3D, backEnd: Point3D) {
//    self.range = ClosedRange(unorderedLeft: frontEnd, right: backEnd)
//    self.points = Brick.allPoints(range: self.range)
//  }
//  
//  static func == (lhs: Brick, rhs: Brick) -> Bool {
//    lhs.range == rhs.range
//  }
//  
//  static func < (lhs: Brick, rhs: Brick) -> Bool {
//    lhs.range.upperBound.z < rhs.range.upperBound.z
//  }
//  
//  static func allPoints(range: ClosedRange<Point3D>) -> [Point3D] {
//    var dir: Direction3D = .n
//    var count: Int = -1
//    switch range.upperBound - range.lowerBound {
//    case let res where res.x > 0:
//      dir = .s
//      count = res.x
//    case let res where res.x < 0:
//      dir = .n
//      count = abs(res.x)
//    case let res where res.y > 0:
//      dir = .e
//      count = res.y
//    case let res where res.y < 0:
//      dir = .w
//      count = abs(res.y)
//    case let res where res.z > 0:
//      dir = .u
//      count = res.z
//    case let res where res.z < 0:
//      dir = .d
//      count = abs(res.z)
//    case let res where res.x == 0 && res.y == 0 && res.z == 0:
//      return [range.lowerBound]
//    default:
//      assert(false, "brick not straight")
//    }
//    
//    var points = [range.lowerBound]
//    for _ in 1...count {
//      points.append(points.last!.move(dir: dir))
//    }
//    assert(points.last == range.upperBound)
//    return points
//  }
//  
//  func allZ() -> Set<Int> {
//    Set(range.lowerBound.z...range.upperBound.z)
//  }
//  
//  func pointsByZ(z: Int) -> [Point3D] {
//    let ret = points.filter{$0.z == z}
//    assert(ret.count > 0)
//    return ret
//  }
//  
//  func move(dir: Direction3D, count: Int = 1) {
//    range = range.lowerBound.move(
//      dir: dir, count: count
//    )...range.upperBound.move(
//      dir: dir, count: count
//    )
//    points = Brick.allPoints(range: range)
//  }
//  
//}
//
//class FallenBrick: Brick, Hashable {
//  var supporting = Set<FallenBrick>()
//  var standingOn = Set<FallenBrick>()
//  var id: Int
//  
//  init(id: Int, brick: Brick) {
//    self.id = id
//    super.init(frontEnd: brick.range.lowerBound, backEnd: brick.range.upperBound)
//  }
//  
//  func hash(into hasher: inout Hasher) {
//    hasher.combine(range)
//  }
//}
//
//struct Day22 {
//  static func main() {
//    let data = try! String(
//      contentsOf: Bundle.module.url(forResource: "day22", withExtension: "txt")!
//    ).trimmingCharacters(
//      in: .newlines)
//
//    // Parsing
//    let pointParser: some Parser<Substring, Point3D> = Parse(Point3D.init) {
//      Int.parser()
//      ","
//      Int.parser()
//      ","
//      Int.parser()
//    }
//
//    let bricks = try! Many {
//      Parse(Brick.init) {
//        pointParser
//        "~"
//        pointParser
//      }
//    } separator: {
//      "\n"
//    }.parse(data).sorted()
//    
//    let fallenBricks = settleBricks(bricks: bricks)
//
//    print("part1: \(part1(bricks: fallenBricks))")
//    print("part2: \(part2(bricks: fallenBricks))")
//  }
//  
//  static func settleBricks(bricks: [Brick]) -> [FallenBrick] {
//    // drop all bricks and build support graph
//    var bricksByZ = [Int: Set<FallenBrick>]()
//    var fallenBricks = [FallenBrick]()
//    for (id, brick) in bricks.enumerated() {
//      let fallenBrick = FallenBrick(id: id, brick: brick)
//      var brickSupported = false
//      while (fallenBrick.range.lowerBound.z > 1 && !brickSupported) {
//        fallenBrick.move(dir: .d)
//        let newZ = fallenBrick.range.lowerBound.z
//        let newZPoints = Set(fallenBrick.pointsByZ(z: newZ))
//        for zBrick in bricksByZ[newZ, default: []] {
//          if !Set(zBrick.pointsByZ(z: newZ)).isDisjoint(with: newZPoints) {
//            zBrick.supporting.insert(fallenBrick)
//            fallenBrick.standingOn.insert(zBrick)
//            brickSupported = true
//          }
//        }
//      }
//      if brickSupported {
//        fallenBrick.move(dir: .u)
//      }
//      fallenBricks.append(fallenBrick)
//      fallenBrick.allZ().forEach{
//        bricksByZ[$0, default: Set<FallenBrick>()].insert(fallenBrick)
//      }
//    }
//    return fallenBricks
//  }
//
//  static func part1(bricks: [FallenBrick]) -> Int {
//    // check for supports
//    bricks.filter{
//      $0.supporting.allSatisfy{$0.standingOn.count > 1}
//    }.count
//  }
//
//  static func part2(bricks: [FallenBrick]) -> Int {
//    bricks.map{
//      var Q = Array($0.supporting.filter{$0.standingOn.count == 1})
//      var displacedBricks = Set(Q)
//      while !Q.isEmpty {
//        let curr = Q.removeFirst()
//        for candidate in curr.supporting {
//          if !displacedBricks.contains(candidate) &&
//            displacedBricks.isSuperset(of: candidate.standingOn) {
//            displacedBricks.insert(candidate)
//            Q.append(candidate)
//          }
//        }
//      }
//      return displacedBricks.count
//    }.reduce(0, +)
//  }
//}

class BrickScene: SCNScene {
  private var planetNode: SCNNode?
  private var brickMaterial: SCNMaterial?
  private var lightNode: SCNNode?
  
  override init() {
    super.init()
    background.contents = CGColor.black
    rootNode.position = SCNVector3(x: 0, y: 0, z: -8)
    createLight()
    createBrickMaterial()
    addPlanetNode()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func createBrickMaterial() {
    let brickMaterial = SCNMaterial()
    brickMaterial.lightingModel = .physicallyBased
    brickMaterial.diffuse.contents = Bundle.module.url(forResource: "Clay001_Color", withExtension: "jpg")!
    brickMaterial.displacement.contents = Bundle.module.url(forResource: "Clay001_Displacement", withExtension: "jpg")!
    brickMaterial.displacement.intensity = 0.1
    brickMaterial.normal.contents = Bundle.module.url(forResource: "Clay001_NormalGL", withExtension: "jpg")!
    brickMaterial.roughness.contents = Bundle.module.url(forResource: "Clay001_Roughness", withExtension: "jpg")!
    brickMaterial.roughness.intensity = 0.1
    self.brickMaterial = brickMaterial
  }
  
  func createLight() {
    let light = SCNLight()
    light.type = .directional
    
    let lightNode = SCNNode()
    lightNode.light = light
    lightNode.position = SCNVector3(0, 0, -8)
    self.rootNode.addChildNode(lightNode)
    self.lightNode = lightNode
  }
  
  func addPlanetNode() {
    let planetGeometry = SCNSphere(radius: 1)
    planetGeometry.materials =	[brickMaterial!]
    
    let planetNode = SCNNode(geometry: planetGeometry)
    planetNode.position = SCNVector3(0, 0, 0)
    self.rootNode.addChildNode(planetNode)
    self.planetNode = planetNode
  }
}

@main
struct Day22_App: App {
  private let scene = BrickScene()
  private let cameraNode = createCameraNode()
  
  var body: some Scene {
    WindowGroup {
      SceneView(scene: scene, pointOfView: cameraNode, options: .allowsCameraControl)
    }
  }
  
  static func createCameraNode() -> SCNNode {
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    return cameraNode
  }
}
