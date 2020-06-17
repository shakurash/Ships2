import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        createShipWaves()
        createRain()
        createWaves()
    }
    
    func createShipWaves() {
        guard let emitter = SKEmitterNode(fileNamed: "ShipWaves") else { return }
        emitter.position = CGPoint(x: 220, y: 165)
        addChild(emitter)
    }
    
    func createRain() {
        guard let emitter = SKEmitterNode(fileNamed: "Rain") else { return }
        emitter.position = CGPoint(x: 375, y: 1230)
        addChild(emitter)
    }
    
    func createWaves() {
        var waveCounter = 15 //set amount of animated waves
        while waveCounter >= 0 {
            let wave = SKSpriteNode(imageNamed: "wave")
            
            wave.size = CGSize(width: 40, height: 40)
            wave.position = CGPoint(x: .random(in: 20...700), y: .random(in: 20...290))
            
            if wave.position.y < 180 { //if waves is below ship it will become front of him else hide behind
                wave.zPosition = 3
            } else {
                wave.zPosition = 1
            }
            
            wave.alpha = 0.0
            addChild(wave)
            waveCounter -= 1
            
            guard let action = SKAction(named: "wave") else { return }
            
            let waveSpeed = CGFloat.random(in: 0.75...0.95)
            let spd = SKAction.speed(by: waveSpeed, duration: .random(in: 2...3))
            let wait =  SKAction.wait(forDuration: .random(in: 0.5...2))
            
            let sequence = SKAction.sequence([spd, wait, action, spd.reversed()]) //need to add reversed speed otherwise waves after few loops will do matrix :D (very slow move)
            wave.run(SKAction.repeatForever(sequence))
        }
    }
    
}

