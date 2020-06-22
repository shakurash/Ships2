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
                        box.fillColor = UIColor.blue
                        box.userData = ["marked": true]
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
                                    box.fillColor = UIColor.blue
                                    box.userData = ["marked": true]
                                } else if box.name == box2 {
                                    box.fillColor = UIColor.blue
                                    box.userData = ["marked": true]
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
                                    box.fillColor = UIColor.blue
                                    box.userData = ["marked": true]
                                } else if box.name == box2 {
                                    box.fillColor = UIColor.blue
                                    box.userData = ["marked": true]
                                } else if box.name == box3 {
                                    box.fillColor == UIColor.blue
                                    box.userData = ["marked": true]
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
                                    box.fillColor = UIColor.blue
                                    box.userData = ["marked": true]
                                } else if box.name == box2 {
                                    box.fillColor = UIColor.blue
                                    box.userData = ["marked": true]
                                } else if box.name == box3 {
                                    box.fillColor = UIColor.blue
                                    box.userData = ["marked": true]
                                } else if box.name == box4 {
                                    box.fillColor = UIColor.blue
                                    box.userData = ["marked": true]
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
        return enemyArray
    }
    
    func aiRandomShipCoordinates() -> String {
        let cord1 = Int.random(in: 0...9)
        let cord2 = Int.random(in: 0...9)
        return "\(cord1)\(cord2)e"
    }
    
    func blockBoxesAround(grid: [SKShapeNode]) {
        for box in grid {
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
