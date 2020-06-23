import SpriteKit
import GameplayKit

class GamePlay: SKScene {
    
    var gameViewController = GameViewController()
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
    }
    
    func setBoards() {
        for box in playerBoard {
            for value in memory.board {
                if box.name == value.name && value.userData == ["marked": true] {
                    box.fillColor = UIColor.green
                    box.userData = ["marked": true, "ship": value.shipName]
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
                let status = self.engine.aiTurn(playerBoard: self.playerBoard)
                if status { //if ai hit the ship then repeat the move witout changing the turn
                    self.cpuHits += 1
                    self.checkWinCondition()
                    self.changeTurn()
                } else {
                self.memory.turn = true
                self.changeTurn()
                }
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
            } else if box.contains(touch!) && memory.turn && box.fillColor != UIColor.red && box.userData?["marked"] as? Bool != false {
                box.fillColor = UIColor.red
                memory.turn = false
                changeTurn()
            }
        }
        checkWinCondition()
    }
    
    func checkWinCondition() {
        if playerHits >= 20 {
            endGame(winner: "player")
        }
        if cpuHits >= 20 {
            endGame(winner: "cpu")
        }
    }
    
    func endGame(winner: String) {
        if winner == "player" {
            
        } else {
            
        }
    }
}
