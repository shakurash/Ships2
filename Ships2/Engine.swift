import SpriteKit
import Foundation

struct Engine {
    
    func aiTurn(playerBoard: [SKShapeNode]) { //this is gonna be super AI brain
        var didHit = false
        while !didHit {
            let coordinates = aiRandomShipCoordinates()
            let properCoord = coordinates.dropLast()
            for box in playerBoard {
                if box.name == String(properCoord) && box.fillColor != UIColor.red && box.userData == ["marked": true] {
                    box.fillColor = UIColor.red
                    didHit = true
                } else if box.name == String(properCoord) && box.fillColor == UIColor.red {
                    didHit = false
                } else if box.name == String(properCoord) && box.fillColor != UIColor.red {
                    box.fillColor = UIColor.red
                    didHit = true
                }
            }
        }
    }
    
    func setEnemyBoard(view: SKScene) -> [SKShapeNode]{
        var shipCounter = 10
        let enemyArray = makeSpriteArray(from: view, enemy: true)
        var status = false
        while shipCounter > 0 {
            let coordinates = aiRandomShipCoordinates() //generate location to place the ship
            //let rotateShip = Bool.random()
            
            for box in enemyArray {
                if box.name == coordinates && box.fillColor != UIColor.red {
                    switch shipCounter {
                        
                    case 7...10: //set smallShip
                        box.userData = ["marked": true]
                        box.userData = ["ship": "smallShip\(shipCounter)"]
                        status = true
                        
                    case 4...6: //mediumShip
                        let posX = box.position.x
                        let posY = box.position.y
                        let box1 = box.name
                        var box2: String? = nil
                        for box in enemyArray {
                            if box.contains(CGPoint(x: posX, y: posY - 50)) && box.fillColor != UIColor.red {
                                box2 = box.name!
                            }
                        }
                        if box1 != nil && box2 != nil {
                            for box in enemyArray {
                                if box.name == box1 {
                                    box.userData = ["marked": true]
                                    box.userData = ["ship": "mediumShip\(shipCounter)"]
                                } else if box.name == box2 {
                                    box.userData = ["marked": true]
                                    box.userData = ["ship": "mediumShip\(shipCounter)"]
                                }
                            }
                            status = true
                        }
                        
                    case 2...3: //bigShip
                        let posX = box.position.x
                        let posY = box.position.y
                        let box1 = box.name
                        var box2: String? = nil
                        var box3: String? = nil
                        for box in enemyArray {
                            if box.contains(CGPoint(x: posX, y: posY - 50)) && box.fillColor != UIColor.red {
                                box2 = box.name!
                                for box in enemyArray {
                                    if box.contains(CGPoint(x: posX, y: posY - 100)) && box.fillColor != UIColor.red {
                                        box3 = box.name!
                                    }
                                }
                            }
                        }
                        if box1 != nil && box2 != nil && box3 != nil{
                            for box in enemyArray {
                                if box.name == box1 {
                                    box.userData = ["marked": true]
                                    box.userData = ["ship": "bigShip\(shipCounter)"]
                                } else if box.name == box2 {
                                    box.userData = ["marked": true]
                                    box.userData = ["ship": "bigShip\(shipCounter)"]
                                } else if box.name == box3 {
                                    box.userData = ["marked": true]
                                    box.userData = ["ship": "bigShip\(shipCounter)"]
                                }
                            }
                            status = true
                        }
                        
                    case 1:  //battleShip
                        let posX = box.position.x
                        let posY = box.position.y
                        let box1 = box.name
                        var box2: String? = nil
                        var box3: String? = nil
                        var box4: String? = nil
                        for box in enemyArray {
                            if box.contains(CGPoint(x: posX, y: posY - 50)) && box.fillColor != UIColor.red {
                                box2 = box.name!
                                for box in enemyArray {
                                    if box.contains(CGPoint(x: posX, y: posY - 100)) && box.fillColor != UIColor.red {
                                        box3 = box.name!
                                        for box in enemyArray {
                                            if box.contains(CGPoint(x: posX, y: posY - 150)) && box.fillColor != UIColor.red {
                                                box4 = box.name!
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if box1 != nil && box2 != nil && box3 != nil && box4 != nil{
                            for box in enemyArray {
                                if box.name == box1 {
                                    box.userData = ["marked": true]
                                    box.userData = ["ship": "battleShip"]
                                } else if box.name == box2 {
                                    box.userData = ["marked": true]
                                    box.userData = ["ship": "battleShip"]
                                } else if box.name == box3 {
                                    box.userData = ["marked": true]
                                    box.userData = ["ship": "battleShip"]
                                } else if box.name == box4 {
                                    box.userData = ["marked": true]
                                    box.userData = ["ship": "battleShip"]
                                }
                            }
                            status = true
                        }
                        
                    default: fatalError("case not found for shipCounter in Engine.setEnemyBoard")
                    }
                    
                    if status {
                        blockBoxesAround(grid: enemyArray)
                        shipCounter -= 1
                        status = false
                    }
                }
            }
        }
        blockBoxesAround(grid: enemyArray, hide: true) //hide red boxes
        return enemyArray
    }
    
    func aiRandomShipCoordinates() -> String {
        let cord1 = Int.random(in: 0...9)
        let cord2 = Int.random(in: 0...9)
        return "\(cord1)\(cord2)e"
    }
    
    func checkIfShipSinks(box: SKShapeNode, board: [SKShapeNode]) -> [SKShapeNode] {
        let posX = box.position.x
        let posY = box.position.y
        var isShipSinked = true
        for box in board {
            if (box.contains(CGPoint(x: CGFloat(posX - 50), y: posY)) ||
            box.contains(CGPoint(x: CGFloat(posX + 50), y: posY)) ||
            box.contains(CGPoint(x: posX, y: (posY + 50))) ||
            box.contains(CGPoint(x: posX, y: (posY - 50))) ) && box.userData == ["marked": true]
            {
                isShipSinked = false
            }
        }
        if isShipSinked {
            let shipType = box.userData?["ship"] as? String
            blockBoxesAround(grid: board, sink: true, ship: shipType)
        }
        return board
    }
    
    func blockBoxesAround(grid: [SKShapeNode], hide: Bool? = false, sink: Bool? = false, ship: String? = nil) {
        var status = true
        for box in grid {
            if sink! { // if entire ship is hitted then mark red all squares around it
                status = false
            }
            if box.userData?["marked"] as? Bool == status { //marking boxes where ship lays help mark boxes around each block every time
                let posX = box.position.x
                let posY = box.position.y
                for box in grid {
                    if (box.contains(CGPoint(x: CGFloat(posX - 50), y: posY)) ||
                        box.contains(CGPoint(x: CGFloat(posX + 50), y: posY)) ||
                        box.contains(CGPoint(x: posX, y: (posY + 50))) ||
                        box.contains(CGPoint(x: posX, y: (posY - 50))) ||
                        box.contains(CGPoint(x: (posX + 50), y: (posY + 50))) ||
                        box.contains(CGPoint(x: (posX - 50), y: (posY - 50))) ||
                        box.contains(CGPoint(x: (posX + 50), y: (posY - 50))) ||
                        box.contains(CGPoint(x: (posX - 50), y: (posY + 50))) ||
                        box.contains(CGPoint(x: posX, y: posY)) ) && box.userData != ["marked": false]
                    {
                        if hide! { // when AI stops putting ship on board hide all red boxes (turn back to default board color)
                            box.fillColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1.0)
                        } else {
                            box.fillColor = UIColor.red
                        }
                    }
                }
            }
        }
    }
    
    func makeSpriteArray(from view: SKScene, enemy: Bool? = false) -> [SKShapeNode] {
        var twoDimensionalArray = [SKShapeNode]()
        var squareFirstNumber = 0
        var squareSecondNumber = 0
        var counter = 9
        var count = 9
        
        while counter >= 0 {
            while count >= 0 {
                var stringName = "\(squareFirstNumber)"+"\(squareSecondNumber)"
                if enemy != false {
                    stringName = stringName + "e"
                }
                if let square: SKShapeNode = view.childNode(withName: stringName) as? SKShapeNode {
                    twoDimensionalArray.append(square)
                }
                squareSecondNumber += 1
                count -= 1
            }
            squareFirstNumber += 1
            squareSecondNumber = 0
            count = 9
            counter -= 1
        }
        return twoDimensionalArray
    }
}
