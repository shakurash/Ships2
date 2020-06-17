import SpriteKit
import GameplayKit

class Configuration: SKScene {
    
    private var rotated = false
    private var grid = [SKShapeNode]()
    private var shipToDeploy = SKSpriteNode()
    private var pickedShip: SKNode?
    private var shipCounter = 10
    private var shipSpawner = SKShapeNode()
    
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
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let picked = pickedShip {
                let touchLocation = touch.location(in: self)
                picked.position = touchLocation
                markGrid(with: touchLocation)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { //drop the ship
        guard let shipDroped = pickedShip else { return }
        checkIfShipCanLand(ship: shipDroped)
    }
    
    //MARK: marking grids with colors depending if user moves the ship above grid (turn green) or drop (turn red)
    func markGrid(with location: CGPoint) {
        for box in grid {
            if box.contains(location) {
                box.fillColor = UIColor.green
            } else {
                box.fillColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1.0)
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
        shipSpawner = shipYard as! SKShapeNode
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
            shipSize = CGSize(width: 50, height: 100)
        case 2...3:
            shipName = "bigShip"
            shipSize = CGSize(width: 50, height: 150)
        case 1:
            shipName = "battleShip"
            shipSize = CGSize(width: 50, height: 200)
        default: fatalError()
        }
        let ship = SKSpriteNode(imageNamed: shipName)
        ship.position = shipSpawner.position
        ship.zPosition = 1
        ship.size = shipSize
        addChild(ship)
        shipToDeploy = ship
    }
    
    func deployAnotherShip() {
        if shipCounter > 1 {
            shipCounter -= 1
            deployTheShip()
        }
    }
    
    func checkIfShipCanLand(ship: SKNode) {
        var didLand = false
        var counter = grid.count
        
        for box in grid {   //check if ship touches on of the box if yes then snap it
            if box.contains(ship.position) {
                ship.position = box.position
                pickedShip = nil
                didLand = true
                deployAnotherShip()
            }
            counter -= 1
        }   //if ship is not in array position then back him to the starting point (shipYard)
        if counter <= 0 && didLand == false {
            ship.position = self.shipSpawner.position
            self.pickedShip = nil
        }
    }
    
    //MARK: Rotation functions
    func changeShipOrientation() {
        
        let rotateAction = SKAction.rotate(toAngle: .pi / 1.5, duration: 0.5)
        shipSpawner.run(rotateAction)
//        shipYard!.run(rotateAction)
//        let rotateAction = SKAction.rotate(toAngle: .pi / 1.5, duration: 0.5)
//        let spawner = shipSpawner as! SKShapeNode
//        shipSpawner?.run(rotateAction) as! SKShapeNode
//        spawner.run(rotateAction)
        //print(shipSpawner)
        print("rotate")
    }
    
    func rotation() { //if rotate button was pressed change the global rotation
        rotated = !rotated
        changeShipOrientation()
        print("rotation")
    }
}

