//
//  Shapes.swift
//  Orbit 7
//
//  Created by Aaron Ackerman on 1/17/15.
//  Copyright (c) 2015 Mav3r1ck. All rights reserved.
//

import Foundation
import SpriteKit


enum Shape: Int {
    
    // Circles
    case RedCircle
    case BlueCircle
    case YellowCircle
    case GreenCircle
    case PurpleCircle
    case BlackCircle
    case Satellite
    
    // MARK: - Private
    
    private var possibleImageNames: [String] {
        switch (self) {
            
        case .RedCircle: return ["redAsteroidS","redAsteroidM","redAsteroidL"]
        case .BlueCircle: return ["blueAsteroidS","blueAsteroidM","blueAsteroidL"]
        case .YellowCircle: return ["asteroid2","asteroid2","asteroid2"]
        case .GreenCircle: return ["greenAsteroidS","greenAsteroidM","greenAsteroidL"]
        case .PurpleCircle: return ["purpleAsteroidS","purpleAsteroidM","purpleAsteroidL"]
        case .BlackCircle: return ["blackAsteroidS","blackAsteroidM","blackAsteroidL"]
        case .Satellite: return ["satelliteS","satelliteM","satelliteL"]
            
        default: return ["satellite"]
        }
    }
    
    private var randomImageName: String {
        let arrayCount = UInt32(possibleImageNames.count)
        let randomIndex = Int(arc4random_uniform(arrayCount))
        return possibleImageNames[randomIndex]
    }
    
    static func randomShape() -> Shape {
        // Find out count of possible shapes
        var maxValue = 0
        while let _ = self.init(rawValue: ++maxValue) {}
        // Generate random number from number of shapes
        let randomNumber = Int(arc4random_uniform(UInt32(maxValue)))
        // Create and return shape
        let shape = self.init(rawValue: randomNumber)!
        
        return shape
    }
    
    func createSpriteNode() -> SKSpriteNode {
        let spriteNode = SKSpriteNode(imageNamed: randomImageName)
        spriteNode.name = name
        return spriteNode
    }
    
    var name: String {
        return "Shape.\(rawValue)"
    }
    
    var score: Int {
        
        switch (self) {
            
            // Circles
        case .RedCircle: return 1 * gameLevel!
        case .BlueCircle: return 2 * gameLevel!
        case .YellowCircle: return 3 * gameLevel!
        case .GreenCircle: return 4 * gameLevel!
        case .PurpleCircle: return 5 * gameLevel!
        case .BlackCircle: return 6 * gameLevel!
        case .Satellite: return -30 * gameLevel!
            
        default: return 0
            
        }
    }
}


let numbersAray = [3, 5, 7, 1, -1, -3, 5, -7]

func randomScore() -> Int {
    
    let unsignedArraycount = UInt32(numbersAray.count)
    let unsignedRandomNumber = arc4random_uniform(unsignedArraycount)
    let randomNumber = Int(unsignedRandomNumber)
    return numbersAray[randomNumber]
    
}
