import SpriteKit
import GameplayKit

class GamePlay: SKScene {
    
    let engine = Engine()
    var memory = Memory.shared
    var playerBoard = [SKShapeNode]()
    
    override func didMove(to view: SKView) {
        playerBoard = engine.makeSpriteArray(from: self)
        setPlayerBoard()
    }
    
    func setPlayerBoard() {
        for box in playerBoard {
            for value in memory.board {
                if box.name == value.name && value.userData == ["marked": true] {
                    box.fillColor = UIColor.blue
                    box.userData = ["marked": true]
                }
            }
        }
    }
    
    
}
