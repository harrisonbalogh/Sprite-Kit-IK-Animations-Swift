//
//  PhysicsScene.swift
//  Harxer
//
//  Created by Harrison Balogh on 10/24/15.
//  Copyright © 2015 Harxer. All rights reserved.
//

import SpriteKit

class TestScene: SKScene, SKPhysicsContactDelegate {
    
    var focusedSprite: SKSpriteNode! = nil
    var reachableSprites = [SKSpriteNode]()
    let disallowedReachables = ["Wall", "walkingSprite", "armInterceptor", "animation_marker", "legInterceptor"]
    var movementFocus = false
    var moveLoc = CGPoint()
    var horizontalMoveXDistanceRequest: CGFloat = 0
    
    var touchStartPos: CGPoint = CGPoint(x: 0, y: 0)
    var touchStartTime: TimeInterval = 0
    
    var lastUpdate: CFTimeInterval = 0
    var lastFrameUpdate: CFTimeInterval = 0
    
    var character: CharacterSpriteNode! = nil
    var dummy: CharacterSprite!
    var dummyStepFrameNode: SKNode! = nil
    
    var worldNode: SKNode!
    
    var mode_debug: Bool = false
    var mode_build: Bool = false
    
    // Called immediately after a scene is presented by a view.
    override func didMove(to view: SKView) {
        worldNode = childNode(withName: "worldNode")
        dummyStepFrameNode = worldNode.childNode(withName: "animationPointMapper")
        spawnEntity(EntityID.DUMMY, atPoint: CGPoint(x: 400, y: 40))
        self.physicsWorld.contactDelegate = self
    }
    
    // MARK: - Physics Contact
    
    // Called when two bodies first contact each other.
    func didBegin(_ contact:SKPhysicsContact){
        print("Contact began...")
        if let node = contact.bodyA.node as? SKSpriteNode {
            if !disallowedReachables.contains(node.name!) {
//                character.addContactNode(node)
                dummy.addContactNode(node)
                reachableSprites.append(node)
            }
        }
    }
    // Called when the contact ends between two physics bodies.
    func didEnd(_ contact:SKPhysicsContact){
        print("...contact ended.")
        if let node = contact.bodyA.node as? SKSpriteNode {
            if !disallowedReachables.contains(node.name!) {
//                character.removeContactNode(node)
                dummy.removeContactNode(node)
                if let i = reachableSprites.index(of: node){
                    reachableSprites.remove(at: i)
                }
            }
        }
    }
    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches began...")
        let touch = touches.first!
        let location = touches.first!.location(in: worldNode)
        // Checks touch is on an object
        for node in worldNode.children {
            if let n = node as? SKSpriteNode {
                if node.contains(location) && n.name != "Wall" {
//                    if n.name == "printPoint" {
//                        dummy.printStepPoint(dummyStepFrameNode.position)
//                        n.run(SKAction.sequence([SKAction.scale(by: 1.2, duration: 0.05), SKAction.scale(by: 0.8, duration: 0.05)]))
//                        return
//                    }
                    touchStartPos = location
                    touchStartTime = touch.timestamp
                    focusedSprite = n
                    focusedSprite.removeAllActions()
                    focusedSprite.run(SKAction.move(to: location, duration: 0.5))
                    focusedSprite.physicsBody?.isDynamic = false //might need to set pinned = false
                    return
                }
            }
            
        }
        // Otherwise the character is to move to the touch location
        movementFocus = true
        moveLoc = location
//        horizontalMoveXDistanceRequest = moveLoc.x - character.body_hip.position.x
        horizontalMoveXDistanceRequest = moveLoc.x - dummy.body_hip.position.x
        horizontalMoveXDistanceRequest = min(horizontalMoveXDistanceRequest/20, 2)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touches.first!.location(in: worldNode)
        
        if focusedSprite != nil {
            if (CGFloat(touch.timestamp) - CGFloat(touchStartTime)) > 0.05 {
                touchStartPos = location
                touchStartTime = touch.timestamp
            }
            focusedSprite.removeAllActions()
            focusedSprite.run(SKAction.move(to: location, duration: 0))
        } else if movementFocus {
            moveLoc = location
//            horizontalMoveXDistanceRequest = moveLoc.x - character.body_hip.position.x
            horizontalMoveXDistanceRequest = moveLoc.x - dummy.body_hip.position.x
            horizontalMoveXDistanceRequest = min(horizontalMoveXDistanceRequest/20, 2)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        movementFocus = false
        horizontalMoveXDistanceRequest = 0
        let touch = touches.first!
        if focusedSprite != nil {
            let location = touch.location(in: worldNode)
            let dx:CGFloat = location.x - touchStartPos.x
            let dy:CGFloat = location.y - touchStartPos.y
            let dt:CGFloat = CGFloat(touch.timestamp) - CGFloat(touchStartTime)
            focusedSprite.physicsBody?.velocity.dx = dx/dt
            focusedSprite.physicsBody?.velocity.dy = dy/dt
            focusedSprite.physicsBody?.isDynamic = true
            focusedSprite = nil
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesCancelled(touches, with: event)
    }
    
    // MARK: - World Controls
    func spawnEntity(_ ID: Int, atPoint point: CGPoint?) {
        var loc = CGPoint()
        if point != nil {
            loc = point!
        } else {
            loc = CGPoint(x: CGFloat(CGFloat(arc4random()).truncatingRemainder(dividingBy: (self.size.width - 50))) + 50, y: CGFloat(CGFloat(arc4random()).truncatingRemainder(dividingBy: (self.size.height - 100))) + 100)
        }
        
        if ID == EntityID.BOX {
            
        } else if ID == EntityID.CHARACTER {
            
            if character != nil {
                character.remove()
            }
            character = CharacterSpriteNode(x: loc.x, y: loc.y, theParent: worldNode, theScene: self)
        } else if ID == EntityID.DUMMY {
            if dummy != nil {
                dummy.remove()
            }
            dummy = CharacterSprite(x: loc.x, y: loc.y, theParent: worldNode, theScene: self)
            let pan = SKAction.move(to: CGPoint(x: -dummy.body_hip.position.x + size.width/2, y: -dummy.body_hip.position.y + size.height/2 - 0.1*size.height), duration: 0)
            worldNode.run(pan)
        }
    }
    
    func zoomWorld(_ zoomMultiplier: Double){

    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        let timeSinceLastUpdate: CGFloat = CGFloat(currentTime - lastUpdate)
        
        if timeSinceLastUpdate > 0.01 {
            lastUpdate = currentTime
            
            let pan = SKAction.move(to: CGPoint(x: -dummy.body_hip.position.x + size.width/2, y: -dummy.body_hip.position.y + size.height/2 - 0.1*size.height), duration: 0)
            worldNode.run(pan)

            dummy.moveByVector(horizontalMoveXDistanceRequest)
        }
    }
}
