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
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(addSquareBox),SKAction.waitForDuration(0.9)])
            ))
    }
    
    // Random CGFloats
    func randomA() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return randomA() * (max - min) + min
    }
    
  
    //Func Add Squares
    func addSquareBox() {
        
        var randomShape = Shape.randomShape().createSpriteNode()
        
        let actualY = random(min: randomShape.size.height, max: size.height - randomShape.size.height)
        randomShape.position = CGPoint(x: size.width + randomShape.size.width/2, y: actualY)
        
        var actualDuration = random(min: CGFloat(5.0 * gameSpeed), max: CGFloat(10 * gameSpeed)) //change speed of adding shapes.
        
        // Move Objects
        var bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(-1000, 9.75))
        bezierPath.addLineToPoint(CGPointMake(100, 0))
        bezierPath.addCurveToPoint(CGPointMake(-289.5, 232.5), controlPoint1: CGPointMake(-146.5, 169.5), controlPoint2: CGPointMake(-221, 232.5))
        bezierPath.addCurveToPoint(CGPointMake(-420.5, 169.5), controlPoint1: CGPointMake(-358, 232.5), controlPoint2: CGPointMake(-420.5, 169.5))
        bezierPath.addLineToPoint(CGPointMake(-1000, 0))
        
        let actionMoveOne = SKAction.followPath(bezierPath.CGPath, duration: NSTimeInterval(actualDuration))
        
        // End ActionMove
        let actionMoveDone = SKAction.removeFromParent()
        
        randomShape.runAction(SKAction.sequence([actionMoveOne,actionMoveDone]))
        
        if playerlife < 1 {
            let loseAction = SKAction.runBlock() {
                let reveal = SKTransition.fadeWithDuration(0.1)
                let gameOverScene = GameOverScene(size: self.size, won: false)
                self.view?.presentScene(gameOverScene, transition: reveal)
                self.audioPlayerTwo.stop()
            }
            
            randomShape.runAction(SKAction.sequence([loseAction]))
            
        }
        addChild(randomShape)
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
