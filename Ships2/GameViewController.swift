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
    
    @IBOutlet weak var rotateButton: UIButton!
    
    let configuration = Configuration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotateButton.isHidden = true
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
        if sender.currentTitle == "Start" {
            presentScene(view: self.view as! SKView, sceneName: "Configuration")
            rotateButton.isHidden = false
            sender.isHidden = true
        } else if sender.currentTitle == "Rotate" {
            configuration.rotation()
            
        }
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
