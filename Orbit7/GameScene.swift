//
//  GameScene.swift
//  Orbit7
//
//  Created by James Martinez on 2/7/15.
//  Copyright (c) 2015 Aaron Ackerman. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

  // MARK: - SKScene

  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)

    NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "addNodeToScene", userInfo: nil, repeats: true)
  }

  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    super.touchesBegan(touches, withEvent: event)

    let touch = event.allTouches()?.anyObject() as? UITouch
    if let touch = touch {
      let touchPoint = touch.locationInNode(self)
      let node = nodesAtPoint(touchPoint).first as? SKNode
      if let node = node {
        node.removeFromParent()
      }
    }
  }

  // MARK: - Private

  @objc private func addNodeToScene() {
    let radius: CGFloat = 50
    let node = SKShapeNode(circleOfRadius: radius)
    let randomY = radius + CGFloat(arc4random_uniform(UInt32(frame.height - radius * 2)))
    let initialPosition = CGPoint(x: frame.width + radius, y: randomY)
    node.position = initialPosition
    node.fillColor = UIColor.whiteColor()
    node.lineWidth = 0
    addChild(node)

    let endPosition = CGPoint(x: -radius, y: initialPosition.y)
    let action = SKAction.moveTo(endPosition, duration: 3)
    node.runAction(action) {
      node.removeFromParent()
    }
  }
}