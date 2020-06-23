import SpriteKit
import Foundation

class Memory {
    static var shared = Memory()
    var board = [Board]()
    var turn = Bool()
    var shipHitPoints = [String:Int]()
    var playerShipHitPoints = [String:Int]()

    private init() { }
}
