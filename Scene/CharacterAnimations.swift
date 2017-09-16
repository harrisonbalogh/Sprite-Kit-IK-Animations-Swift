//
//  Animations.swift
//  Harxer
//
//  Created by Harrison Balogh on 7/25/16.
//  Copyright © 2016 Harxer. All rights reserved.
//

import SpriteKit

struct CharacterAnimations {
    
    static fileprivate let animationSpeedAdjuster: Double = 1
    
    // =================================================================================================== WALK ANIMATION =================================

    // WALK FOOT (front)
    static let frontFootWalk = SKAction.sequence([
        SKAction.move(to: CGPoint(x: -10, y: -40), duration: 0.5 * animationSpeedAdjuster),
        SKAction.move(to: CGPoint(x:  -2, y: -38), duration: 0.25 * animationSpeedAdjuster),
        SKAction.move(to: CGPoint(x:  10, y: -40), duration: 0.25 * animationSpeedAdjuster)
    ])
    
    // WALK FOOT (back)
    static let backFootWalk = SKAction.sequence([
        SKAction.move(to: CGPoint(x:  -2, y: -38), duration: 0.25 * animationSpeedAdjuster),
        SKAction.move(to: CGPoint(x:  10, y: -40), duration: 0.25 * animationSpeedAdjuster),
        SKAction.move(to: CGPoint(x: -10, y: -40), duration: 0.5 * animationSpeedAdjuster)
    ])
    
    // START WALK FOOT (front)
    static let frontFootStartWalk = SKAction.sequence([
        SKAction.move(to: CGPoint(x:  8, y: -37), duration: 0.3 * animationSpeedAdjuster),
        SKAction.move(to: CGPoint(x: 10, y: -40), duration: 0.3 * animationSpeedAdjuster)
    ])
    
    // START WALK FOOT (back)
    static let backFootStartWalk = SKAction.sequence([
        SKAction.move(to: CGPoint(x: -10, y: -40), duration: 0.6 * animationSpeedAdjuster)
    ])
    
    // WALK SWING HAND (front)
    static let frontHandWalkSwing = SKAction.sequence([
        SKAction.rotate(toAngle: 15 * CGFloat(M_PI) / 180, duration: 0.5 * animationSpeedAdjuster),
        SKAction.rotate(toAngle: -(15 * CGFloat(M_PI) / 180), duration: 0.5 * animationSpeedAdjuster)
    ])
    
    // WALK SWING HAND (back)
    static let backHandWalkSwing = SKAction.sequence([
        SKAction.rotate(toAngle: -(15 * CGFloat(M_PI) / 180), duration: 0.5 * animationSpeedAdjuster),
        SKAction.rotate(toAngle: 15 * CGFloat(M_PI) / 180, duration: 0.5 * animationSpeedAdjuster)
    ])
    
    // START WALK SWING HAND (front)
    static let frontHandStartWalkSwing = SKAction.sequence([
        SKAction.rotate(toAngle: -(15 * CGFloat(M_PI) / 180), duration: 0.6 * animationSpeedAdjuster)
    ])
    
    // START WALK SWING HAND (back)
    static let backHandStartWalkSwing = SKAction.sequence([
        SKAction.rotate(toAngle: 15 * CGFloat(M_PI) / 180, duration: 0.6 * animationSpeedAdjuster)
    ])
    
    // START WALK HIP
    static let hipStartWalk = SKAction.sequence([
        SKAction.move(by: CGVector(dx: 0, dy: -2), duration: 0.6 * animationSpeedAdjuster)
    ])
    
    // WALK HIP
    static let hipWalk = SKAction.sequence([
        SKAction.move(by: CGVector(dx: 0, dy: 1), duration: 0.25 * animationSpeedAdjuster),
        SKAction.move(by: CGVector(dx: 0, dy: -1), duration: 0.25 * animationSpeedAdjuster)
    ])
    
    // WALK HEAD
    static let headWalk = SKAction.sequence([
        SKAction.rotate(byAngle: 4 * CGFloat(M_PI) / 180, duration: 0.25 * animationSpeedAdjuster),
        SKAction.rotate(byAngle: -4 * CGFloat(M_PI) / 180, duration: 0.25 * animationSpeedAdjuster)
    ])
    
    // START WALK HEAD
    static let headStartWalk = SKAction.sequence([
        SKAction.wait(forDuration: 0.35 * animationSpeedAdjuster),
        SKAction.rotate(byAngle: -6 * CGFloat(M_PI) / 180, duration: 0.25 * animationSpeedAdjuster)
    ])
    
    // WALK CHEST
    static let chestWalk = SKAction.sequence([
        SKAction.rotate(byAngle: 2 * CGFloat(M_PI) / 180, duration: 0.25 * animationSpeedAdjuster),
        SKAction.rotate(byAngle: -2 * CGFloat(M_PI) / 180, duration: 0.25 * animationSpeedAdjuster)
    ])
    
    // START WALK CHEST
    static let chestStartWalk = SKAction.sequence([
        SKAction.rotate(byAngle: -6 * CGFloat(M_PI) / 180, duration: 0.6 * animationSpeedAdjuster)
    ])
    
    // =================================================================================================== RUN ANIMATION =================================
    // RUN FOOT (front)
    static let frontFootRun = SKAction.sequence([
        SKAction.move(to: CGPoint(x: -17.5, y: -35.8), duration: 0.50 * animationSpeedAdjuster),
        SKAction.move(to: CGPoint(x: -29.9, y: -25.1), duration: 0.1 * animationSpeedAdjuster),
        SKAction.move(to: CGPoint(x: -25.9, y: -12.7), duration: 0.15 * animationSpeedAdjuster),
        SKAction.move(to: CGPoint(x:  22, y: -35.8), duration: 0.45 * animationSpeedAdjuster)
    ])
    // RUN FOOT (back)
    static let backFootRun = SKAction.sequence([
        SKAction.move(to: CGPoint(x: -25.9, y: -12.7), duration: 0.15 * animationSpeedAdjuster),
        SKAction.move(to: CGPoint(x:  22, y: -35.8), duration: 0.45 * animationSpeedAdjuster),
        SKAction.move(to: CGPoint(x: -17.5, y: -35.8), duration: 0.50 * animationSpeedAdjuster),
        SKAction.move(to: CGPoint(x: -29.9, y: -25.1), duration: 0.1 * animationSpeedAdjuster)
    ])
    // START RUN FOOT (front)
    static let frontFootStartRun = SKAction.sequence([
        SKAction.move(to: CGPoint(x: 7, y: -32.3), duration: 0.3 * animationSpeedAdjuster),
        SKAction.move(to: CGPoint(x: 11.3, y: -35.8), duration: 0.1 * animationSpeedAdjuster)
    ])
    // START RUN FOOT (back)
    static let backFootStartRun = SKAction.sequence([
        SKAction.move(to: CGPoint(x: -17.5, y: -35.8), duration: 0.3 * animationSpeedAdjuster),
        SKAction.move(to: CGPoint(x: -29.9, y: -25.1), duration: 0.1 * animationSpeedAdjuster)
        
    ])
    // RUN HIP
    static let hipRun = SKAction.sequence([
        SKAction.move(by: CGVector(dx:-12, dy: 0), duration: 0.45 * animationSpeedAdjuster),
        SKAction.move(by: CGVector(dx:  6, dy: 6), duration: 0.075 * animationSpeedAdjuster),
        SKAction.move(by: CGVector(dx:  6, dy:-6), duration: 0.075 * animationSpeedAdjuster)
    ])
    // START RUN HIP 
    static let hipStartRun = SKAction.sequence([
        SKAction.move(by: CGVector(dx: 12, dy: -6), duration: 0.4 * animationSpeedAdjuster)
    ])
    // RUN CHEST
    static let chestRun = SKAction.sequence([
        SKAction.rotate( byAngle: 8 * CGFloat(M_PI) / 180, duration: 0.45 * animationSpeedAdjuster),
        SKAction.rotate(byAngle: -8 * CGFloat(M_PI) / 180, duration: 0.15 * animationSpeedAdjuster)
    ])
    // START RUN CHEST
    static let chestStartRun = SKAction.sequence([
        SKAction.rotate(byAngle: -20 * CGFloat(M_PI) / 180, duration: 0.4 * animationSpeedAdjuster)
    ])
    // RUN HEAD
    static let headRun = SKAction.sequence([
        SKAction.rotate( byAngle: 6 * CGFloat(M_PI) / 180, duration: 0.45 * animationSpeedAdjuster),
        SKAction.rotate(byAngle: -6 * CGFloat(M_PI) / 180, duration: 0.15 * animationSpeedAdjuster)
    ])
    // START RUN HEAD
    static let headStartRun = SKAction.sequence([
        SKAction.rotate(byAngle: -8 * CGFloat(M_PI) / 180, duration: 0.4 * animationSpeedAdjuster)
    ])
    // RUN SWING FOREARM (front)
    static let frontForearmRunSwing = SKAction.sequence([
        SKAction.rotate(toAngle: 140 * CGFloat(M_PI) / 180, duration: 0.6 * animationSpeedAdjuster),
        SKAction.rotate( toAngle: 90 * CGFloat(M_PI) / 180, duration: 0.6 * animationSpeedAdjuster)
    ])
    // RUN SWING UPPERARM (front)
    static let frontUpperarmRunSwing = SKAction.sequence([
        SKAction.rotate( toAngle: (15 * CGFloat(M_PI) / 180), duration: 0.6 * animationSpeedAdjuster),
        SKAction.rotate(toAngle: -(60 * CGFloat(M_PI) / 180), duration: 0.6 * animationSpeedAdjuster)
    ])
    // START RUN SWING UPPERARM (front)
    static let frontUpperarmStartRunSwing = SKAction.sequence([
        SKAction.rotate(toAngle: -(15 * CGFloat(M_PI) / 180), duration: 0.4 * animationSpeedAdjuster)
    ])
    // RUN SWING UPPERARM (back)
    static let backUpperarmRunSwing = SKAction.sequence([
        SKAction.rotate(toAngle: -(60 * CGFloat(M_PI) / 180), duration: 0.6 * animationSpeedAdjuster),
        SKAction.rotate( toAngle: (15 * CGFloat(M_PI) / 180), duration: 0.6 * animationSpeedAdjuster)
    ])
    // START RUN SWING UPPERARM (back)
    static let backUpperarmStartRunSwing = SKAction.sequence([
        SKAction.rotate(toAngle: 15 * CGFloat(M_PI) / 180, duration: 0.4 * animationSpeedAdjuster)
    ])
    // RUN SWING FOREARM (back)
    static let backForearmRunSwing = SKAction.sequence([
        SKAction.rotate(  toAngle: 90 * CGFloat(M_PI) / 180, duration: 0.6 * animationSpeedAdjuster),
        SKAction.rotate(toAngle: 140 * CGFloat(M_PI) / 180, duration: 0.6 * animationSpeedAdjuster)
    ])
    // START RUN SWING FOREARM (back)
    static let backForearmStartRunSwing = SKAction.sequence([
        SKAction.rotate(toAngle: 100 * CGFloat(M_PI) / 180, duration: 0.4 * animationSpeedAdjuster)
    ])
    
    // =================================================================================================== UPHILL WALK ANIMATION =================================
    
    
    // The follow should be changed from RUN to UPHILL_WALK, as this is what this may look like
//    // RUN FOOT (front)
//    static let frontFootRun = SKAction.sequence([
//        SKAction.moveTo(CGPoint(x: -28, y: -42), duration: 0.4 * animationSpeedAdjuster),
//        SKAction.moveTo(CGPoint(x: -24, y: -30), duration: 0.2 * animationSpeedAdjuster),
//        SKAction.moveTo(CGPoint(x:  -7, y: -34), duration: 0.1 * animationSpeedAdjuster),
//        SKAction.moveTo(CGPoint(x:  17, y: -42), duration: 0.1 * animationSpeedAdjuster)
//        ])
//    
//    // RUN FOOT (back)
//    static let backFootRun = SKAction.sequence([
//        SKAction.moveTo(CGPoint(x: -24, y: -30), duration: 0.2 * animationSpeedAdjuster),
//        SKAction.moveTo(CGPoint(x:  -7, y: -34), duration: 0.1 * animationSpeedAdjuster),
//        SKAction.moveTo(CGPoint(x:  17, y: -42), duration: 0.1 * animationSpeedAdjuster),
//        SKAction.moveTo(CGPoint(x: -28, y: -42), duration: 0.4 * animationSpeedAdjuster)
//        ])
//    
//    // START RUN FOOT (front)
//    static let frontFootStartRun = SKAction.sequence([
//        SKAction.moveTo(CGPoint(x: 16, y: -36), duration: 0.4 * animationSpeedAdjuster),
//        SKAction.moveTo(CGPoint(x: 17, y: -42), duration: 0.1 * animationSpeedAdjuster)
//        ])
//    
//    // START RUN FOOT (back)
//    static let backFootStartRun = SKAction.sequence([
//        SKAction.moveTo(CGPoint(x: -28, y: -40), duration: 0.5 * animationSpeedAdjuster)
//        ])
//    
//    // RUN HIP
//    static let hipRun = SKAction.sequence([
//        SKAction.moveBy(CGVector(dx: 10, dy: 2), duration: 0.2 * animationSpeedAdjuster),
//        SKAction.moveBy(CGVector(dx:-10, dy: -2), duration: 0.2 * animationSpeedAdjuster)
//        ])
//    
//    // START RUN HIP
//    static let hipStartRun = SKAction.sequence([
//        SKAction.moveBy(CGVector(dx: 10, dy: -7), duration: 0.5 * animationSpeedAdjuster)
//        ])
//    
//    // RUN CHEST
//    static let chestRun = SKAction.sequence([
//        SKAction.rotateByAngle( 2 * CGFloat(M_PI) / 180, duration: 0.2 * animationSpeedAdjuster),
//        SKAction.rotateByAngle(-2 * CGFloat(M_PI) / 180, duration: 0.2 * animationSpeedAdjuster)
//        ])
//    
//    // START RUN CHEST
//    static let chestStartRun = SKAction.sequence([
//        SKAction.rotateByAngle(-20 * CGFloat(M_PI) / 180, duration: 0.5 * animationSpeedAdjuster)
//        ])
//    
//    // RUN HEAD
//    static let headRun = SKAction.sequence([
//        SKAction.rotateByAngle( 6 * CGFloat(M_PI) / 180, duration: 0.2 * animationSpeedAdjuster),
//        SKAction.rotateByAngle(-6 * CGFloat(M_PI) / 180, duration: 0.2 * animationSpeedAdjuster)
//        ])
//    
//    // START RUN HEAD
//    static let headStartRun = SKAction.sequence([
//        SKAction.rotateByAngle(-8 * CGFloat(M_PI) / 180, duration: 0.5 * animationSpeedAdjuster)
//        ])
//    
//    // RUN SWING UPPERARM (front)
//    static let frontUpperarmRunSwing = SKAction.sequence([
//        SKAction.rotateToAngle( (30 * CGFloat(M_PI) / 180), duration: 0.4 * animationSpeedAdjuster),
//        SKAction.rotateToAngle(-(30 * CGFloat(M_PI) / 180), duration: 0.4 * animationSpeedAdjuster)
//        ])
//    
//    // START RUN SWING UPPERARM (front)
//    static let frontUpperarmStartRunSwing = SKAction.sequence([
//        SKAction.rotateToAngle(-(15 * CGFloat(M_PI) / 180), duration: 0.5 * animationSpeedAdjuster)
//        ])
//    
//    // RUN SWING UPPERARM (back)
//    static let backUpperarmRunSwing = SKAction.sequence([
//        SKAction.rotateToAngle(-(30 * CGFloat(M_PI) / 180), duration: 0.4 * animationSpeedAdjuster),
//        SKAction.rotateToAngle( (30 * CGFloat(M_PI) / 180), duration: 0.4 * animationSpeedAdjuster)
//        ])
//    
//    // START RUN SWING UPPERARM (back)
//    static let backUpperarmStartRunSwing = SKAction.sequence([
//        SKAction.rotateToAngle(15 * CGFloat(M_PI) / 180, duration: 0.5 * animationSpeedAdjuster)
//        ])
    
}

