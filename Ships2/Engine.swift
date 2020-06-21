import SpriteKit
import Foundation

struct Engine {
    
    func makeSpriteArray(from view: SKScene) -> [SKShapeNode] {
        var twoDimensionalArray = [SKShapeNode]()
        var squareFirstNumber = 0
        var squareSecondNumber = 0
        var counter = 9
        var count = 9
        
        while counter >= 0 {
            while count >= 0 {
                let stringName = "\(squareFirstNumber)"+"\(squareSecondNumber)"
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
