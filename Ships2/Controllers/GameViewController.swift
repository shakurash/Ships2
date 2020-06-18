//
//  GameViewController.swift
//  Ships2
//
//  Created by Robert on 16/06/2020.
//  Copyright © 2020 Robert. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentScene(view: self.view as! SKView, sceneName: "GameScene")
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
            presentScene(view: self.view as! SKView, sceneName: "Configuration")
            sender.isHidden = true
    }
    
    func presentScene(view: SKView, sceneName: String) {
        //    if let view = self.view as! SKView? {
        if let scene = SKScene(fileNamed: sceneName) {
            scene.scaleMode = .aspectFill
            view.presentScene(scene, transition: .fade(with: UIColor.white, duration: 0.5))
            view.showsFPS = true
        }
    }
    
}
