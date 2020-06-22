import SpriteKit
import Foundation

class Memory {
    static var shared = Memory()
    var board = [Board]()
    var turn = Bool()

    private init() { }
}
