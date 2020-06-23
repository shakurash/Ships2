import SpriteKit
import GameplayKit

class GamePlay: SKScene {
    
    let engine = Engine()
    var memory = Memory.shared
    var label = SKLabelNode()
    private var playerBoard = [SKShapeNode]()
    private var enemyBoard = [SKShapeNode]()
    private var playerHits = 0
    private var cpuHits = 0
    
    override func didMove(to view: SKView) {
        playerBoard = engine.makeSpriteArray(from: self)
        enemyBoard = engine.setEnemyBoard(view: self)
        label = childNode(withName: "turn") as! SKLabelNode
        memory.turn = true //set player to move first
        setBoards() //load player ship configuration
        changeTurn() //upload current turn
//        for n in enemyBoard {
//            print(n.userData)
//        }
    }
    
    func setBoards() {
        for box in playerBoard {
            for value in memory.board {
                if box.name == value.name && value.userData == ["marked": true] {
                    box.fillColor = UIColor.green
                    box.userData = ["marked": true]
                }
            }
        }
    }

    func changeTurn() {
        if memory.turn {
            label.text = "Twoja tura"
        } else {
            label.text = "Przeciwnik"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.engine.aiTurn(playerBoard: self.playerBoard)
                self.memory.turn = true
                self.changeTurn()
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first?.location(in: self)
        for box in enemyBoard {
            if box.contains(touch!) && box.userData?["marked"] as? Bool == true && memory.turn {
                box.fillColor = UIColor.yellow
                box.userData?["marked"] = false
                enemyBoard = engine.checkIfShipSinks(box: box, board: enemyBoard)
                playerHits += 1
            } else if box.contains(touch!) && memory.turn && box.fillColor != UIColor.red && box.userData != ["marked": false]{
                box.fillColor = UIColor.red
                memory.turn = false
                changeTurn()
            }
        }
        checkWinCondition()
    }
    
    func checkWinCondition() {
//                print(playerHits)
//        print(cpuHits)
        if playerHits >= 20 {
            print("player win")
        }
        if cpuHits >= 20 {
            print("cpu win")
        }
    }
}
