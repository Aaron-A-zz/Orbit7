//
//  GameOver.swift
//  Orbit 7
//
//  Created by Aaron Ackerman on 1/17/15.
//  Copyright (c) 2015 Mav3r1ck. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        
        backgroundColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
        var message = won ? "You Won!" : "You Lost, Try again!"
        
        let label = SKLabelNode(fontNamed: "DIN Condensed")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.whiteColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        runAction(SKAction.sequence([
            SKAction.waitForDuration(5.0),
            SKAction.runBlock() {
                
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = Menu(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}