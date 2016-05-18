//
//  Menu.swift
//  Orbit 7
//
//  Created by Aaron Ackerman on 1/17/15.
//  Copyright (c) 2015 Mav3r1ck. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation


var gameLevel: Int?
var gameSpeed: UInt32?
var gamelvlLable = ""
var gameObjective: Int!

class Menu: SKScene {
    
    var audioPlayer = AVAudioPlayer()
    let gameScene = GameScene()
    let mygameLabel = SKLabelNode()
    let sunNode = SKSpriteNode(imageNamed: "sunDot@2x")
    let redNode = SKSpriteNode(imageNamed: "redDot@2x")
    let greenNode = SKSpriteNode(imageNamed: "greenDot@2x")
    let purpleNode = SKSpriteNode(imageNamed: "purpleDot@2x")
    let blueNode = SKSpriteNode(imageNamed: "blueDot@2x")
    
    override func didMoveToView(view: SKView) {
        
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Spiraling",ofType: "wav")!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: alertSound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            audioPlayer.numberOfLoops = -1
        } catch var error1 as NSError {
            print(error1)
        }

        
        // Level Label
        mygameLabel.fontName = "DIN Condensed"
        mygameLabel.fontSize = 40
        mygameLabel.fontColor = SKColor.whiteColor()
        mygameLabel.position = CGPoint(x: size.width/2, y: size.height/1.29)
        mygameLabel.text = "Orbit 7"
        addChild(mygameLabel)

        
        // Add Stars!
        let stars = SKEmitterNode(fileNamed: "Stars")
        stars!.position = CGPointMake(400, 200)
        addChild(stars!)
        
        // Background Color
        backgroundColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
        func addOrbitingToShape(shape: SKSpriteNode, orbitSize: CGSize, rotateDegrees: Double, reverseOrbit: Bool, duration: NSTimeInterval) {
            
            let orbitPathOrigin = CGPoint(x: view.center.x - orbitSize.width / 2, y: view.center.y - orbitSize.height / 2)
            let orbitPathRect = CGRect(origin: orbitPathOrigin, size: orbitSize)
            let orbitPath = CGPathCreateWithEllipseInRect(orbitPathRect, nil)
            
            var transform = CGAffineTransformIdentity
            transform = CGAffineTransformTranslate(transform, view.center.x, view.center.y)
            transform = CGAffineTransformRotate(transform, CGFloat(rotateDegrees * M_PI / 180))
            transform = CGAffineTransformTranslate(transform, -view.center.x, -view.center.y)
            let rotatedOrbitPath = CGPathCreateCopyByTransformingPath(orbitPath, &transform)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = rotatedOrbitPath
            shapeLayer.strokeColor = UIColor.clearColor().CGColor
            shapeLayer.lineWidth = 0.5
            shapeLayer.lineDashPattern = [5, 1.5]
            shapeLayer.fillColor = UIColor.clearColor().CGColor
            view.layer.addSublayer(shapeLayer)
            
            var spriteKitTransform = CGAffineTransformIdentity
            spriteKitTransform = CGAffineTransformTranslate(spriteKitTransform, view.center.x, view.center.y)
            spriteKitTransform = CGAffineTransformRotate(spriteKitTransform, CGFloat(90 * M_PI / 180))
            spriteKitTransform = CGAffineTransformTranslate(spriteKitTransform, -view.center.x, -view.center.y)
            let spriteKitPath = CGPathCreateCopyByTransformingPath(shapeLayer.path, &spriteKitTransform)
            
            
            if reverseOrbit == false {
                let orbitActionTwo = SKAction.followPath(spriteKitPath!, asOffset: false, orientToPath: true, duration: duration)
                shape.runAction(SKAction.repeatActionForever(orbitActionTwo))
                
            } else if reverseOrbit == true {
                
                
                let orbitActionTwo = SKAction.followPath(spriteKitPath!, asOffset: false, orientToPath: true, duration: duration)
                shape.runAction(SKAction.repeatActionForever(orbitActionTwo.reversedAction()))
            }
        
        
    }
        
        // Sun Dot
        sunNode.position = CGPoint(x: size.width/2, y:size.height/2)
        sunNode.name = "Sun"
        addChild(sunNode)
        
        
        // Green Asteroid
        let greenCircleOrbitSize = CGSize(width: 200 , height: 200)
        addOrbitingToShape(greenNode, orbitSize: greenCircleOrbitSize, rotateDegrees: 90, reverseOrbit: false, duration: 8)
        greenNode.name = "greenDot"
        addChild(greenNode)
        
        // Red Asteroid
        let redCircleOrbitSize = CGSize(width: sunNode.xScale + 280, height: sunNode.yScale + 500)
        addOrbitingToShape(redNode, orbitSize: redCircleOrbitSize, rotateDegrees: 330, reverseOrbit: false, duration: 5)
        redNode.name = "redDot"
        addChild(redNode)
        
        
        // Blue Asteroid
        let blueCircleOrbitSize = CGSize(width: 500 , height: 540)
        addOrbitingToShape(blueNode, orbitSize: blueCircleOrbitSize, rotateDegrees: 90, reverseOrbit: true, duration: 5)
        blueNode.name = "blueDot"
        addChild(blueNode)
        
        
        // Purple Asteroid
        let purpleCircleOrbitSize = CGSize(width: 700 , height: 650)
        addOrbitingToShape(purpleNode, orbitSize: purpleCircleOrbitSize, rotateDegrees: 45, reverseOrbit: true, duration: 15)
        purpleNode.name = "purpleDot"
        addChild(purpleNode)
        
        
        
}
    
    
    // Game Levels
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touchLocation = (touches.first! as UITouch).locationInNode(self)
        let node = self.nodeAtPoint(touchLocation)
        
        audioPlayer.stop()
        
    
        if node.name == "Sun" {
 
            runAction(SKAction.sequence([
                SKAction.waitForDuration(1.0),
                SKAction.runBlock() {
                    gamelvlLable = "Level One"
                    let reveal = SKTransition.crossFadeWithDuration(0.5)
                    let scene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition:reveal)
                    gameSpeed = 10
                    gameLevel = 1
                    gameObjective = 50
                    
                }
                ]))
        } else if node.name == "greenDot" {
            
            runAction(SKAction.sequence([
                SKAction.waitForDuration(1.0),
                SKAction.runBlock() {
                    gamelvlLable = "Level Two"
                    let reveal = SKTransition.crossFadeWithDuration(0.5)
                    let scene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition:reveal)
                    gameSpeed = 8
                    gameLevel = 2
                    gameObjective = 100
                    
                }
                ]))
            
        } else if node.name == "redDot" {
            
            runAction(SKAction.sequence([
                SKAction.waitForDuration(1.0),
                SKAction.runBlock() {
                    gamelvlLable = "Level Three"
                    let reveal = SKTransition.crossFadeWithDuration(0.5)
                    let scene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition:reveal)
                    gameSpeed = 6
                    gameLevel = 3
                    gameObjective = 150
                }
                ]))
            
        } else if node.name == "blueDot" {
            
            runAction(SKAction.sequence([
                SKAction.waitForDuration(1.0),
                SKAction.runBlock() {
                    gamelvlLable = "Level Four"
                    let reveal = SKTransition.crossFadeWithDuration(0.5)
                    let scene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition:reveal)
                    gameSpeed = 4
                    gameLevel = 4
                    gameObjective = 200
                    
                }
                ]))
            
        } else if node.name == "purpleDot" {
        
            runAction(SKAction.sequence([
                SKAction.waitForDuration(1.0),
                SKAction.runBlock() {
                    gamelvlLable = "Level Five"
                    let reveal = SKTransition.crossFadeWithDuration(0.5)
                    let scene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition:reveal)
                    gameSpeed = 2
                    gameLevel = 5
                    gameObjective = 250
                    
                }
            ]))
        }
    }
    
}