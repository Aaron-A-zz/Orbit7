//
//  GameScene.swift
//  Orbit 7
//
//  Created by Aaron Ackerman on 1/17/15.
//  Copyright (c) 2015 Mav3r1ck. All rights reserved.
//

import SpriteKit
import AVFoundation


class GameScene: SKScene {
    
    
    var audioPlayer = AVAudioPlayer()
    var audioPlayerTwo = AVAudioPlayer()
    
    var playerScore = 0
    var playerlife = 3
    
    let playerScorelabel = SKLabelNode()
    var gameLevelLable = SKLabelNode()
    
    //Player Life Images
    let playerLifeImage1 = SKSpriteNode(imageNamed: "playerlife.png")
    let playerLifeImage2 = SKSpriteNode(imageNamed: "playerlife.png")
    let playerLifeImage3 = SKSpriteNode(imageNamed: "playerlife.png")
    
    override func didMoveToView(view: SKView) {
        
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Spiraling",ofType: "wav")!)
        
        var error:NSError?
        audioPlayerTwo = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
        audioPlayerTwo.prepareToPlay()
        audioPlayerTwo.play()
        audioPlayerTwo.numberOfLoops = -1
        
        // Set background Color
        backgroundColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
        // Player Score
        playerScorelabel.fontName = "DIN Condensed"
        playerScorelabel.fontSize = 28
        playerScorelabel.fontColor = SKColor.whiteColor()
        playerScorelabel.position = CGPoint(x: size.width/10.0, y: size.height/1.09)
        playerScorelabel.text = "Score: \(playerScore)"
        addChild(playerScorelabel)
        
        // Level Label
        gameLevelLable.fontName = "DIN Condensed"
        gameLevelLable.fontSize = 28
        gameLevelLable.fontColor = SKColor.whiteColor()
        gameLevelLable.position = CGPoint(x: size.width/2, y: size.height/1.09)
        gameLevelLable.text = gamelvlLable
        addChild(gameLevelLable)
        
        // Player Life Image locations
        playerLifeImage1.position = CGPoint(x: size.width/1.10, y: size.height/1.08)
        addChild(playerLifeImage1)
        playerLifeImage2.position = CGPoint(x: size.width/1.075, y: size.height/1.08)
        addChild(playerLifeImage2)
        playerLifeImage3.position = CGPoint(x: size.width/1.05, y: size.height/1.08)
        addChild(playerLifeImage3)
        
        //alert!
        showPauseAlert()
        
        //Background Stars * * *
        let stars = SKEmitterNode(fileNamed: "Stars")
        stars.position = CGPointMake(400, 200)
        addChild(stars)
        
        //Func Add Squares
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(addNodeToScene),SKAction.waitForDuration(0.9)])
            ))
    }
    
    
    @objc private func addNodeToScene() {
        let radius: CGFloat = 50
        let node = Shape.randomShape().createSpriteNode()
        let randomY = radius + CGFloat(arc4random_uniform(UInt32(frame.height - radius * 2)))
        let initialPosition = CGPoint(x: frame.width + radius, y: randomY)
        node.position = initialPosition
        addChild(node)
        
        let endPosition = CGPoint(x: -radius, y: initialPosition.y)
        let action = SKAction.moveTo(endPosition, duration: 3)
        node.runAction(action) {
            node.removeFromParent()
            
        }
        
        if playerlife < 1 {
            let loseAction = SKAction.runBlock() {
                let reveal = SKTransition.fadeWithDuration(0.1)
                let gameOverScene = GameOverScene(size: self.size, won: false)
                self.view?.presentScene(gameOverScene, transition: reveal)
                self.audioPlayerTwo.stop()
            }
            
            node.runAction(SKAction.sequence([loseAction]))
            
        }

    }
    
  
 
    // Adding Touches
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let location = touches.anyObject()?.locationInNode(self)
        var node = self.nodeAtPoint(location!)
        
        // Particles
        func explosion() {
            // Effects
            let sparkEmmiter = SKEmitterNode(fileNamed: "ParticleFire.sks")
            sparkEmmiter.name = "Fire"
            sparkEmmiter.position = location!
            sparkEmmiter.targetNode = self
            sparkEmmiter.particleLifetime = 1
            self.addChild(sparkEmmiter)
            
            // Sounds
            var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("zapzap",ofType: "wav")!)
            
            var error:NSError?
            audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            if  (playerScore > gameObjective) {
                let reveal = SKTransition.fadeWithDuration(0.5)
                let gameOverScene = GameOverScene(size: self.size, won: true)
                self.view?.presentScene(gameOverScene, transition: reveal)
                audioPlayerTwo.stop()
            } else if (playerScore <= -50) {
                let reveal = SKTransition.fadeWithDuration(0.5)
                let gameOverScene = GameOverScene(size: self.size, won: false)
                self.view?.presentScene(gameOverScene, transition: reveal)
                audioPlayerTwo.stop()
            }
            
        }
        
      
        
        func playerScoreUpdate() {
            playerScorelabel.text = "Score: \(playerScore)"
            node.removeFromParent()
        }
        
        if let name = node.name {
            var addedScore = 0
            switch name {
                
                // Circles
            case Shape.RedCircle.name: addedScore = Shape.RedCircle.score
            case Shape.BlueCircle.name: addedScore = Shape.BlueCircle.score
            case Shape.YellowCircle.name: addedScore = Shape.YellowCircle.score
            case Shape.GreenCircle.name: addedScore = Shape.GreenCircle.score
            case Shape.PurpleCircle.name: addedScore = Shape.PurpleCircle.score
            case Shape.BlackCircle.name: addedScore = Shape.BlackCircle.score
            case Shape.Satellite.name: addedScore = Shape.Satellite.score
                
            default: addedScore = 0
            }
            playerScore = playerScore + addedScore
            playerScoreUpdate()
            explosion()
            
        } else {
            
            playerlife--
            
            if playerlife == 2 {
                playerLifeImage3.hidden = true
            } else if playerlife == 1 {
                playerLifeImage3.hidden = true
                playerLifeImage2.hidden = true
            } else if playerlife == 0 {
                playerLifeImage3.hidden = true
                playerLifeImage2.hidden = true
                playerLifeImage1.hidden = true
            } else {
                playerLifeImage3.hidden = false
                playerLifeImage2.hidden = false
                playerLifeImage1.hidden = false
            }
        }
    }
    
 
    
    func showPauseAlert() {
        
        var alert = UIAlertController(title: "\(gamelvlLable)", message: "Destroy the Asteroids! & Avoid the Satellites!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default)  { _ in
            
            })
        self.view?.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let dropDown = SKAction.scaleTo(1.0, duration: 0.2)
        
    }
    
}
