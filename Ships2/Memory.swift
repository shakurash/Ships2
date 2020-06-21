import SpriteKit
import Foundation

class Memory {
    static var shared = Memory()
    var board = [Board]()

    private init() { }
}
