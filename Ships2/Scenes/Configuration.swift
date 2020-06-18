import SpriteKit
import GameplayKit

class Configuration: SKScene {
    
    private var rotated = false
    private var grid = [SKShapeNode]()
    private var shipToDeploy = SKSpriteNode()
    private var pickedShip: SKSpriteNode?
    private var shipCounter = 10
    private var shipSpawner = SKShapeNode()
    private var rotateButton = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        makeSpriteArray()
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
        guard let shipDroped = pickedShip else { return }
        checkIfShipCanLand(ship: shipDroped)
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
    
    func blockBoxes(ship: SKSpriteNode) {
        let cordX = locationRotation().x
        let cordY = locationRotation().y
        
        for box in grid {
            if ship.name == "smallShip" {
                if box.contains(ship.position) {
                    box.userData = ["marked": true]
                }
            } else if ship.name == "mediumShip" {
                if box.contains(ship.position) || box.contains(CGPoint(x: ship.position.x - cordX, y: ship.position.y - cordY)) {
                    box.userData = ["marked": true]
                }
            } else if ship.name == "bigShip" {
                if box.contains(ship.position) || box.contains(CGPoint(x: ship.position.x - cordX, y: ship.position.y - cordY)) || box.contains(CGPoint(x: ship.position.x + cordX, y: ship.position.y + cordY)) {
                    box.userData = ["marked": true]
                }
            } else if ship.name == "battleShip" {
                if box.contains(ship.position) || box.contains(CGPoint(x: ship.position.x - cordX, y: ship.position.y - cordY)) || box.contains(CGPoint(x: ship.position.x + cordX, y: ship.position.y + cordY)) || box.contains(CGPoint(x: ship.position.x - (cordX * 2), y: ship.position.y - (cordY * 2))) {
                    box.userData = ["marked": true]
                }
            }
            
            if box.userData?["marked"] as? Bool == true {
                //box.fillColor = UIColor.blue
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
    func makeSpriteArray() {
        var squareFirstNumber = 0
        var squareSecondNumber = 0
        var counter = 9
        var count = 9
        
        while counter >= 0 {
            while count >= 0 {
                let stringName = "\(squareFirstNumber)"+"\(squareSecondNumber)"
                if let square: SKShapeNode = self.childNode(withName: stringName) as? SKShapeNode {
                    grid.append(square)
                }
                squareSecondNumber += 1
                count -= 1
            }
            squareFirstNumber += 1
            squareSecondNumber = 0
            count = 9
            counter -= 1
        }
    }
    
    func makeShipYard() {
        guard let shipYard = self.childNode(withName: "shipYard") else { return }
        guard let label = self.childNode(withName: "rotate") else { return }
        shipSpawner = shipYard as! SKShapeNode
        rotateButton = label as! SKSpriteNode
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
        if shipCounter > 1 {
            shipCounter -= 1
            deployTheShip()
        }
    }
    
    func checkIfShipCanLand(ship: SKSpriteNode) {
        var didLand = false
        var counter = grid.count
        let cordX = locationRotation().x
        let cordY = locationRotation().y
        
        for box in grid {
            //check if ship touches the box and boxes arent occupied then snap ship to the boxes
            if box.contains(ship.position) && box.fillColor != UIColor.red {
                
                if ship.name == "mediumShip" || ship.name == "battleShip" { //different snap to grid if ship is medium or battle and depends on orientation
                    ship.position = CGPoint(x: box.position.x - (cordX / 2), y: box.position.y - (cordY / 2))
                } else {
                    ship.position = box.position
                }
                pickedShip = nil
                didLand = true
                blockBoxes(ship: ship)
                deployAnotherShip()
            }
            
            
            counter -= 1
        }   //if ship is not in array position then back him to the starting point (shipYard)
        if counter <= 0 && didLand == false {
            ship.position = self.shipSpawner.position
            self.pickedShip = nil
        }
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

