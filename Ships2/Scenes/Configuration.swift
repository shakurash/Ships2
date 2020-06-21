import SpriteKit
import GameplayKit

class Configuration: SKScene {
    
    private var rotated = false
    private var grid = [SKShapeNode]()
    private var shipToDeploy = SKSpriteNode()
    private var pickedShip: SKSpriteNode?
    private var shipCounter = 2
    private var shipSpawner = SKShapeNode()
    private var rotateButton = SKSpriteNode()
    private var resetButton = SKSpriteNode()
    private var playButton = SKSpriteNode()
    
    var gameViewController = GameViewController()
    let engine = Engine()
    let memory = Memory.shared
    
    override func didMove(to view: SKView) {
        makeButtonSprites()
        grid = engine.makeSpriteArray(from: self)
        makeShipYard()
        deployTheShip()
    }
    
    //MARK: - touches behavior - grabing, moving and puting ship on array
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: self) //pickup the ship
            if shipToDeploy.contains(position) {
                self.pickedShip = shipToDeploy
            } else if rotateButton.contains(position) {
                rotation()
            } else if resetButton.contains(position){
                gameViewController.presentScene(view: self.view!, sceneName: "Configuration")
            } else if playButton.contains(position) {
                setUserData()
                gameViewController.presentScene(view: self.view!, sceneName: "GamePlay")
                
            }
        }
    }
    
    func setUserData() {
        for box in grid {
            if box.userData == ["marked": true] {
                let save = Board(name: box.name!, userData: box.userData as! [String : Bool])
                memory.board.append(save)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let picked = pickedShip {
                let touchLocation = touch.location(in: self)
                picked.position = touchLocation
                markGrid(with: touchLocation, and: picked)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { //drop the ship
        guard let shipDroped = pickedShip,
            let loc = touches.first?.location(in: self)
            else { return }
        checkIfShipCanLand(ship: shipDroped, location: loc)
    }
    
    //MARK: - marking grids with colors depending if user moves the ship above grid (turn green) or drop (turn red)
    func markGrid(with location: CGPoint, and ship: SKSpriteNode) {
        let cordX = locationRotation().x //set the coordinates corresponding to the actual rotation
        let cordY = locationRotation().y
        for box in grid {
            if box.contains(location) && box.fillColor != UIColor.red {
                box.fillColor = UIColor.green
            } else if (ship.name == "mediumShip" || ship.name == "bigShip" || ship.name == "battleShip") && box.contains(CGPoint(x: location.x - cordX, y: location.y - cordY)) && box.fillColor != UIColor.red {
                box.fillColor = UIColor.green
            } else if (ship.name == "bigShip" || ship.name == "battleShip") && box.contains(CGPoint(x: location.x + cordX, y: location.y + cordY)) && box.fillColor != UIColor.red {
                box.fillColor = UIColor.green
            } else if ship.name == "battleShip" && box.contains(CGPoint(x: location.x - (cordX * 2), y: location.y - (cordY * 2))) && box.fillColor != UIColor.red {
                box.fillColor = UIColor.green
            } else if box.fillColor != UIColor.red {
                box.fillColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1.0)
            }
        }
    }
    
    func blockBoxes(ship: SKSpriteNode) { //block boxes making them red depending on ship size
        let cordX = locationRotation().x
        let cordY = locationRotation().y
        
        for box in grid {
            if ship.name == "smallShip" {
                if box.contains(ship.position) {
                    box.userData = ["marked": true]
                }
            } else if ship.name == "mediumShip" {
                if box.contains(CGPoint(x: ship.position.x + cordX , y: ship.position.y + cordY)) ||
                    box.contains(CGPoint(x: ship.position.x - (cordX / 2), y: ship.position.y - (cordY / 2)))
                {
                    box.userData = ["marked": true]
                }
            } else if ship.name == "bigShip" {
                if box.contains(ship.position) ||
                    box.contains(CGPoint(x: ship.position.x - cordX, y: ship.position.y - cordY)) ||
                    box.contains(CGPoint(x: ship.position.x + cordX, y: ship.position.y + cordY))
                {
                    box.userData = ["marked": true]
                }
            } else if ship.name == "battleShip" {
                if box.contains(CGPoint(x: ship.position.x + cordX , y: ship.position.y + cordY)) ||
                    box.contains(CGPoint(x: ship.position.x - cordX, y: ship.position.y - cordY)) ||
                    box.contains(CGPoint(x: ship.position.x + (cordX * 2), y: ship.position.y + (cordY * 2))) ||
                    box.contains(CGPoint(x: ship.position.x - (cordX * 2), y: ship.position.y - (cordY * 2)))
                {
                    box.userData = ["marked": true]
                }
            }
            
            if box.userData?["marked"] as? Bool == true { //marking boxes where ship lays help mark boxes around each block every time
                let posX = box.position.x
                let posY = box.position.y
                for box in grid {
                    if box.contains(CGPoint(x: CGFloat(posX - 50), y: posY)) ||
                        box.contains(CGPoint(x: CGFloat(posX + 50), y: posY)) ||
                        box.contains(CGPoint(x: posX, y: (posY + 50))) ||
                        box.contains(CGPoint(x: posX, y: (posY - 50))) ||
                        box.contains(CGPoint(x: (posX + 50), y: (posY + 50))) ||
                        box.contains(CGPoint(x: (posX - 50), y: (posY - 50))) ||
                        box.contains(CGPoint(x: (posX + 50), y: (posY - 50))) ||
                        box.contains(CGPoint(x: (posX - 50), y: (posY + 50))) ||
                        box.contains(CGPoint(x: posX, y: posY))
                    {
                        box.fillColor = UIColor.red
                    }
                }
            }
        }
    }
    
    //MARK: - preparing the scene
    func makeShipYard() {
        guard let shipYard = self.childNode(withName: "shipYard") else { return }
        shipSpawner = shipYard as! SKShapeNode
        
    }
    
    func makeButtonSprites() {
        guard
            let label = self.childNode(withName: "rotate"),
            let reset = self.childNode(withName: "reset"),
            let play = self.childNode(withName: "play")
            else { return }
        rotateButton = label as! SKSpriteNode
        resetButton = reset as! SKSpriteNode
        resetButton.isHidden = true
        playButton = play as! SKSpriteNode
        playButton.isHidden = true
    }
    
    //MARK: - managing ships spawn and placing them on array
    
    func deployTheShip() {
        var shipName = String()
        var shipSize = CGSize()
        
        switch shipCounter {
        case 7...10:
            shipName = "smallShip"
            shipSize = CGSize(width: 50, height: 50)
        case 4...6:
            shipName = "mediumShip"
            shipSize = CGSize(width: 30, height: 100)
        case 2...3:
            shipName = "bigShip"
            shipSize = CGSize(width: 50, height: 150)
        case 1:
            shipName = "battleShip"
            shipSize = CGSize(width: 50, height: 200)
        default: fatalError()
        }
        let ship = SKSpriteNode(imageNamed: shipName)
        ship.name = shipName
        ship.position = shipSpawner.position
        ship.zPosition = 1
        ship.size = shipSize
        
        if rotated {
            let rotateAction = SKAction.rotate(byAngle: .pi / 2, duration: 0.01)
            ship.run(rotateAction)
        }
        
        addChild(ship)
        shipToDeploy = ship
    }
    
    func deployAnotherShip() {
        if shipCounter > 0 {
            shipCounter -= 1
        }
        if shipCounter < 10 {
            resetButton.isHidden = false
        } else {
            resetButton.isHidden = true
        }
        if shipCounter == 0 {
            playButton.isHidden = false
        } else {
            deployTheShip()
        }
    }
    
    func checkIfShipCanLand(ship: SKSpriteNode, location: CGPoint) {
        var didLand = false
        var counter = grid.count
        let cordX = locationRotation().x
        let cordY = locationRotation().y
        
        for box in grid { //check if ship touches the box and boxes arent occupied then snap ship to the boxes
            
            if box.contains(ship.position) && box.fillColor != UIColor.red {
                let currentShipBoxPosition = box //remember the position (where currently user is holding ship) to pass it futher and drop/snap ship correctly
                if ship.name == "smallShip" { didLand = shipAllowedToDrop(in: box, with: ship, cordX: cordX, cordY: cordY) }
                else {
                    for box in grid {
                        if box.contains(CGPoint(x: location.x - cordX, y: location.y - cordY)) && box.fillColor != UIColor.red {
                            if ship.name == "mediumShip" { didLand = shipAllowedToDrop(in: currentShipBoxPosition, with: ship, cordX: cordX, cordY: cordY) }
                            else {
                                for box in grid {
                                    if box.contains(CGPoint(x: location.x + cordX, y: location.y + cordY)) && box.fillColor != UIColor.red {
                                        if ship.name == "bigShip" { didLand = shipAllowedToDrop(in: currentShipBoxPosition, with: ship, cordX: cordX, cordY: cordY) }
                                        else {
                                            for box in grid {
                                                if box.contains(CGPoint(x: location.x - (cordX * 2), y: location.y - (cordY * 2))) && box.fillColor != UIColor.red {
                                                    didLand = shipAllowedToDrop(in: currentShipBoxPosition, with: ship, cordX: cordX, cordY: cordY)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            
            counter -= 1
        } //if ship is not in array position then back him to the starting point (shipYard)
        if counter <= 0 && didLand == false {
            ship.position = self.shipSpawner.position
            self.pickedShip = nil
        }
    }
    
    func shipAllowedToDrop(in box: SKShapeNode, with ship: SKSpriteNode, cordX: CGFloat ,cordY: CGFloat) -> Bool {
        if ship.name == "mediumShip" || ship.name == "battleShip" { //different snap to grid if ship is medium or battle and depends on orientation
            ship.position = CGPoint(x: box.position.x - (cordX / 2), y: box.position.y - (cordY / 2))
        } else {
            ship.position = box.position
        }
        pickedShip = nil
        blockBoxes(ship: ship)
        deployAnotherShip()
        return true
    }
    
    //MARK: - Rotation functions
    func changeShipOrientation() {
        var rotateAction = SKAction()
        if !rotated {
            rotateAction = SKAction.rotate(byAngle: .pi / -2, duration: 0.5)
        } else {
            rotateAction = SKAction.rotate(byAngle: .pi / 2, duration: 0.5)
        }
        shipSpawner.run(rotateAction)
        if shipToDeploy.contains(shipSpawner.position) {
            shipToDeploy.run(rotateAction)
        }
    }
    
    func rotation() { //if rotate button was pressed change the global rotation
        rotated = !rotated
        changeShipOrientation()
    }
    
    func locationRotation() -> (x: CGFloat,y: CGFloat) {
        var x: CGFloat = 0
        var y: CGFloat = 0
        if !rotated {
            y = 50
            return (x , y)
        } else {
            x = 50
            return (x, y)
        }
    }
    
}

