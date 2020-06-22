import SpriteKit
import GameplayKit

class GamePlay: SKScene {
    
    let engine = Engine()
    var memory = Memory.shared
    private var playerBoard = [SKShapeNode]()
    private var enemyBoard = [SKShapeNode]()
    
    override func didMove(to view: SKView) {
        playerBoard = engine.makeSpriteArray(from: self)
        enemyBoard = engine.setEnemyBoard(view: self)
        setBoards()
    }
    
    func setBoards() {
        for box in playerBoard {
            for value in memory.board {
                if box.name == value.name && value.userData == ["marked": true] {
                    box.fillColor = UIColor.blue
                    box.userData = ["marked": true]
                }
            }
        }
        //enemyBoard = engine.setEnemyBoard(view: self)
    }


    
}
