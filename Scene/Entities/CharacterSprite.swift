//
//  CharacterSprite.swift
//  Harxer
//
//  Created by Harrison Balogh on 7/25/16.
//  Copyright © 2016 Harxer. All rights reserved.
//

import SpriteKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class CharacterSprite {
    
    // Using to test not having the hip attached to a physics body but pinned so it can be moved.
    
    // An "_f" appended to a variable name indicates it is the front object (foreground), while
    // an "_b" appended to a variable name indicates it is the back object (background).
    
    //Animations
    let footWalkTracker_f = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 1, height: 1))
    let footWalkTracker_b = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 1, height: 1))
    var walkStepTimer: Timer!
    var stepFrameRecorder = 0
    
    //Body Node Variables
    let body_hip: SKNode!
    let body_head: SKSpriteNode!
    let body_leg_up_front: SKSpriteNode!
    let body_leg_up_back: SKSpriteNode!
    let body_leg_down_front: SKSpriteNode!
    let body_leg_down_back: SKSpriteNode!
    let body_chest: SKSpriteNode!
    let body_neck: SKNode!
    let body_arm_up_front: SKSpriteNode!
    let body_arm_up_back: SKSpriteNode!
    let body_arm_down_back: SKSpriteNode!
    let body_arm_down_front: SKSpriteNode!
    let body_hand_front: SKNode!
    let body_hand_back: SKNode!
    let body_foot_front: SKNode!
    let body_foot_back: SKNode!
    let body_parts: [SKNode]!
    
    //Physics
    let physics_body = SKPhysicsBody(rectangleOf: CGSize(width: 17.5, height: 82))
    let armInteraction = SKShapeNode(rect: CGRect(origin: CGPoint(x: 5, y: 0 - 12), size: CGSize(width: 35, height: 70)))
    let armInteraction_physics = SKPhysicsBody(rectangleOf: CGSize(width: 35, height: 70), center: CGPoint(x: 22.5, y: 23))
    let legInteraction: SKSpriteNode!
    let legInteraction_physics: SKPhysicsBody!
    var armInterceptors = [SKNode]()
    var legInterceptors = [SKNode]()
    var reachUpdateTimer: Timer!
    var stepUpdateTimer: Timer!
    
    //Body Properties
    struct Facing {
        var right = true
        var left = false
        mutating func rotate(){
            right = !right
            left = !left
        }
    }
    struct Reaching {
        var foregroundArm = false
        var backgroundArm = false
    }
    struct Stepping {
        var foregroundLeg = false
        var backgroundLeg = false
    }
    let neckLength: CGFloat!
    let armLength_up: CGFloat!
    let armLength_down: CGFloat!
    let armLength_upSq: CGFloat!
    let armLength_downSq: CGFloat!
    let armLength: CGFloat!
    let armReach_max: CGFloat!
    let armReach_min: CGFloat!
    let armReach_maxSq: CGFloat!
    let armReach_minSq: CGFloat!
    let legLength: CGFloat!
    let legLength_up: CGFloat!
    let legLength_down: CGFloat!
    let legLength_upSq: CGFloat!
    let legLength_downSq: CGFloat!
    let legReach_max: CGFloat!
    let legReach_min: CGFloat!
    let legReach_maxSq: CGFloat!
    let legReach_minSq: CGFloat!
    var isFacing = Facing()
    var isReaching = Reaching()
    var isStepping = Stepping()
    var moving = false
    var starting_movement = false
    var startPos: CGPoint! // temp
    
    //Constants
    let characterWalkVelocity: CGFloat = 50
    let parent: SKNode! //moving to superclass
    let scene: TestScene!
    //{See SKContact documentation on bit masks}
    let INTERACTOR_OBJECT : UInt32 = 0x01;
    let CHARACTER_OBJECT : UInt32 = 0x02;
    let WORLD_OBJECT : UInt32 = 0x04;
    
    init(x xPos: CGFloat, y yPos: CGFloat, theParent: SKNode, theScene: TestScene){
        startPos = CGPoint(x: xPos, y: yPos) //temp
        // Mark: Initialize all body nodes
        //      HIP
        body_hip = SKNode()
        body_hip.name = "body_hip"
        body_hip.zPosition = 0
        body_hip.position = CGPoint(x: xPos, y: yPos)
        physics_body.categoryBitMask = CHARACTER_OBJECT
        physics_body.collisionBitMask = WORLD_OBJECT
        physics_body.contactTestBitMask = 0
        body_hip.physicsBody = physics_body
        theParent.addChild(body_hip)
        //      CHEST
        body_chest = SKSpriteNode(imageNamed: "Character_Chest@2x.png")
        body_chest.name = "body_chest"
        body_chest.anchorPoint = CGPoint(x: 0.66, y: 0.039)
        body_chest.position = CGPoint(x: -0.261, y: 0.55)
        body_chest.zPosition = 0
        body_hip.addChild(body_chest)
        //      LEG QUAD FOREGROUND
        body_leg_up_front = SKSpriteNode(imageNamed: "Character_Leg_Up_Front@2x.png")
        body_leg_up_front.name = "body_leg_up_front"
        body_leg_up_front.anchorPoint = CGPoint(x: 0.5, y: 0.844)
        body_leg_up_front.position = CGPoint(x: -0.002, y: -0.267)
        body_leg_up_front.zPosition = 1
        body_hip.addChild(body_leg_up_front)
        //      LEG QUAD BACKGROUND
        body_leg_up_back = SKSpriteNode(imageNamed: "Character_Leg_Up_Back@2x.png")
        body_leg_up_back.name = "body_leg_up_back"
        body_leg_up_back.anchorPoint = CGPoint(x: 0.5, y: 0.844)
        body_leg_up_back.position = CGPoint(x: -0.002, y: -0.267)
        body_leg_up_back.zPosition = -1
        body_hip.addChild(body_leg_up_back)
        //      LEG CALF FOREGROUND
        body_leg_down_front = SKSpriteNode(imageNamed: "Character_Leg_Down_Front@2x.png")
        body_leg_down_front.name = "body_leg_down_front"
        body_leg_down_front.anchorPoint = CGPoint(x: 0.5, y: 0.975)
        body_leg_down_front.position = CGPoint(x: 1.926, y: -19.031)
        body_leg_down_front.zPosition = 1
        body_leg_up_front.addChild(body_leg_down_front)
        //      LEG CALF BACKGROUND
        body_leg_down_back = SKSpriteNode(imageNamed: "Character_Leg_Down_Back@2x.png")
        body_leg_down_back.name = "body_leg_down_back"
        body_leg_down_back.anchorPoint = CGPoint(x: 0.5, y: 0.975)
        body_leg_down_back.position = CGPoint(x: 1.926, y: -19.031)
        body_leg_down_back.zPosition = -1
        body_leg_up_back.addChild(body_leg_down_back)
        //      FOOT FOREGROUND (POINT)
        body_foot_front = SKNode()
        body_foot_front.name = "body_foot_front"
        body_foot_front.position = CGPoint(x: 0.21, y: -20.936)
        body_foot_front.zPosition = 1
        body_leg_down_front.addChild(body_foot_front)
        //      FOOT BACKGROUND (POINT)
        body_foot_back = SKNode()
        body_foot_back.name = "body_foot_back"
        body_foot_back.position = CGPoint(x: 0.21, y: -20.936)
        body_foot_back.zPosition = -1
        body_leg_down_back.addChild(body_foot_back)
        //      NECK (POINT)
        body_neck = SKNode()
        body_neck.name = "body_neck"
        body_neck.position = CGPoint(x: -1.486, y: 27.102)
        body_neck.zPosition = 0
        body_chest.addChild(body_neck)
        //      HEAD
        body_head = SKSpriteNode(imageNamed: "Character_Head@2x.png")
        body_head.name = "body_head"
        body_head.anchorPoint = CGPoint(x: 0.34, y: 0.021)
        body_head.position = CGPoint(x: 0.64, y: 2.05)
        body_head.zPosition = 0
        body_neck.addChild(body_head)
        //      ARM BICEP FOREGROUND
        body_arm_up_front = SKSpriteNode(imageNamed: "Character_Upperarm@2x.png")
        body_arm_up_front.name = "body_arm_up_front"
        body_arm_up_front.anchorPoint = CGPoint(x: 0.5, y: 0.85)
        body_arm_up_front.position = CGPoint(x: -1.854, y: 23.602)
        body_arm_up_front.zPosition = 1
        body_chest.addChild(body_arm_up_front)
        //      ARM BICEP BACKGROUND
        body_arm_up_back = SKSpriteNode(imageNamed: "Character_Upperarm_Back@2x.png")
        body_arm_up_back.name = "body_arm_up_back"
        body_arm_up_back.anchorPoint = CGPoint(x: 0.5, y: 0.85)
        body_arm_up_back.position = CGPoint(x: -1.854, y: 23.602)
        body_arm_up_back.zPosition = -1
        body_chest.addChild(body_arm_up_back)
        //      ARM FOREARM FOREGROUND
        body_arm_down_front = SKSpriteNode(imageNamed: "Character_Forearm@2x.png")
        body_arm_down_front.name = "body_arm_down_front"
        body_arm_down_front.anchorPoint = CGPoint(x: 0.535, y: 0.908)
        body_arm_down_front.position = CGPoint(x: 0.038, y: -13.755)
        body_arm_down_front.zPosition = 1
        body_arm_down_front.zRotation = 15 * CGFloat(M_PI) / 180
        body_arm_up_front.addChild(body_arm_down_front)
        //      ARM FOREARM BACKGROUND
        body_arm_down_back = SKSpriteNode(imageNamed: "Character_Forearm_Back@2x.png")
        body_arm_down_back.name = "body_arm_down_back"
        body_arm_down_back.anchorPoint = CGPoint(x: 0.535, y: 0.908)
        body_arm_down_back.position = CGPoint(x: 0.038, y: -13.755)
        body_arm_down_back.zPosition = -1
        body_arm_down_back.zRotation = 15 * CGFloat(M_PI) / 180
        body_arm_up_back.addChild(body_arm_down_back)
        //      HAND FOREGROUND (POINT)
        body_hand_front = SKNode()
        body_hand_front.name = "body_hand_front"
        body_hand_front.position = CGPoint(x: 0.454, y: -15.889)
        body_arm_down_front.addChild(body_hand_front)
        //      HAND BACKGROUND (POINT)
        body_hand_back = SKNode()
        body_hand_back.name = "body_hand_back"
        body_hand_back.position = CGPoint(x: 0.454, y: -15.889)
        body_arm_down_back.addChild(body_hand_back)
        //      Array of all body part nodes
        body_parts = [body_hip, body_leg_up_front, body_leg_up_back, body_chest, body_neck, body_arm_up_front, body_arm_up_back, body_head, body_leg_down_front, body_leg_down_back, body_arm_down_front, body_arm_down_back, body_hand_front, body_hand_back, body_foot_front, body_foot_back]
        // Mark: END BODY NODE INITIALIZATION
        
        
        parent = theParent
        scene = theScene
        //
        neckLength = CGPoint(x: 0, y: 0).distance(body_head.position)
        armLength_up = hypot(body_arm_down_front.position.x, body_arm_down_front.position.y)
        armLength_upSq = pow(armLength_up, 2)
        armLength_down = hypot(body_hand_front.position.x, body_hand_front.position.y)
        armLength_downSq = pow(armLength_down, 2)
        armLength = armLength_up + armLength_down
        armReach_max = armLength - 0.40 // 0.40 is subtracted from the arm's maximum reach so it doesn't visually hyperextend
        armReach_maxSq = pow(armReach_max, 2)
        armReach_min = 5
        armReach_minSq = 25
        armInteraction.name = "armInterceptor"
        armInteraction.alpha = theScene.mode_debug ? 1 : 0
        armInteraction_physics.affectedByGravity = false
        armInteraction_physics.isDynamic = true
        armInteraction_physics.allowsRotation = true
        armInteraction_physics.pinned = false
        armInteraction_physics.contactTestBitMask = WORLD_OBJECT
        armInteraction_physics.categoryBitMask = 0
        armInteraction_physics.collisionBitMask = 0
        armInteraction_physics.mass = 0
        armInteraction.physicsBody = armInteraction_physics
        body_chest.addChild(armInteraction)
        let j = SKPhysicsJointFixed.joint(withBodyA: armInteraction_physics, bodyB: physics_body, anchor:CGPoint(x: 0, y: 0))
        theScene.physicsWorld.add(j)
        
        legLength_up = hypot(body_leg_down_front.position.x, body_leg_down_front.position.y)
        legLength_upSq = pow(legLength_up, 2)
        legLength_down = hypot(body_foot_front.position.x, body_foot_front.position.y)
        legLength_downSq = pow(legLength_down, 2)
        legLength = legLength_up + legLength_down
        legReach_max = legLength
        legReach_maxSq = pow(legReach_max, 2)
        legReach_min = 10
        legReach_minSq = pow(legReach_min, 2)
        legInteraction = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 2*legLength, height: 2*legLength))
        legInteraction.alpha = 0
        legInteraction.anchorPoint.y = 1
        legInteraction.name = "legInterceptor"
        legInteraction_physics = SKPhysicsBody(rectangleOf: CGSize(width: 2*legLength, height: 2*legLength), center: CGPoint(x: 0, y: -legLength/2))
        legInteraction_physics.affectedByGravity = false
        legInteraction_physics.isDynamic = true
        legInteraction_physics.allowsRotation = true
        legInteraction_physics.pinned = false
        legInteraction_physics.contactTestBitMask = WORLD_OBJECT
        legInteraction_physics.categoryBitMask = 0
        legInteraction_physics.collisionBitMask = 0
        legInteraction_physics.mass = 0
        legInteraction.physicsBody = legInteraction_physics
//        body_hip.addChild(legInteraction)
        
        // Leg movement in walk animation uses reachTo() method with these two footWalkTracker points following
        // the path of a human foot when walking
        footWalkTracker_f.name = "footWalkTracker"
        footWalkTracker_b.name = "footWalkTracker"
        footWalkTracker_f.alpha = 0
        footWalkTracker_b.alpha = 0
        footWalkTracker_f.zPosition = 3
        footWalkTracker_b.zPosition = 3
        footWalkTracker_f.position = CGPoint(x: 0, y: -legLength)
        footWalkTracker_b.position = CGPoint(x: 0, y: -legLength)
        body_hip.addChild(footWalkTracker_f)
        body_hip.addChild(footWalkTracker_b)
        // Arm swing for walk animation uses reachTo() method with these two handSwingTracker points following
        // the path of a human hand when walking
//        handSwingTracker_f.name = "handSwingTracker_f"
//        handSwingTracker_b.name = "handSwingTracker_b"
//        body_chest.addChild(handSwingTracker_f)
//        body_chest.addChild(handSwingTracker_b)
    } // end init()
    
    func remove(){
        // May need more cleared here... Look at memory growth when creating and destroying many characters
        body_hip.removeFromParent()
        armInteraction.removeFromParent()
        armInterceptors.removeAll()
    }
    
    /// Based on the scene's debug mode, make the arm interaction collider visible or not.
    func updateDebugMode(){
        armInteraction.alpha = self.scene.mode_debug ? 1 : 0
    }
    
    //MARK: - Animation
    /// 
    func animate_run() {
        if !moving {
            moving = true
            starting_movement = true
            // Begin timer to keep having feet/legs move to tracker
            walkStepTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(CharacterSprite.stepToWalkTracker), userInfo: nil, repeats: true)
            
            // Run SKAction START animations on body: _chest, _hip, _head
            body_chest.run(CharacterAnimations.chestStartRun)
            body_hip.run(CharacterAnimations.hipStartRun)
            body_head.run(CharacterAnimations.headStartRun)
            
            // Check if arm_front or _back need to swing with animation or reach
            if !isReaching.foregroundArm {
                body_arm_up_front.run(CharacterAnimations.frontUpperarmStartRunSwing)
            }
            if !isReaching.backgroundArm {
                body_arm_up_back.run(CharacterAnimations.backUpperarmStartRunSwing)
                body_arm_down_back.run(CharacterAnimations.backForearmStartRunSwing)
            }
            
            // Run START foot animation background
            footWalkTracker_b.run(CharacterAnimations.backFootStartRun, completion: {
                // When start animation completes, character no longer is starting to move
                self.starting_movement = false
                // Check if character is still moving to proceed
                if self.moving {
                    // Loop _chest, _head, _hip animations
                    self.body_chest.run(SKAction.repeatForever(CharacterAnimations.chestRun))
                    self.body_head.run(SKAction.repeatForever(CharacterAnimations.headRun))
                    self.body_hip.run(SKAction.repeatForever(CharacterAnimations.hipRun))
                    
                    self.footWalkTracker_b.run(SKAction.repeatForever(CharacterAnimations.backFootRun))
                    if !self.isReaching.foregroundArm {
                        self.body_arm_up_front.run(SKAction.repeatForever(CharacterAnimations.frontUpperarmRunSwing))
                        self.body_arm_down_front.run(SKAction.repeatForever(CharacterAnimations.frontForearmRunSwing))
                    }
                }
            })
            // Run START foot animation foreground
            footWalkTracker_f.run(CharacterAnimations.frontFootStartRun, completion: {
                self.starting_movement = false
                if self.moving {
                    self.footWalkTracker_f.run(SKAction.repeatForever(CharacterAnimations.frontFootRun))
                    if !self.isReaching.backgroundArm {
                        self.body_arm_up_back.run(SKAction.repeatForever(CharacterAnimations.backUpperarmRunSwing))
                        self.body_arm_down_back.run(SKAction.repeatForever(CharacterAnimations.backForearmRunSwing))
                    }
                }
            })
        }
    }
    
    func animate_uphillWalk() {
        
    }
    // Dummy
    func animate_walk() {
        if !moving {
            moving = true
            starting_movement = true
            walkStepTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(CharacterSpriteNode.stepToWalkTracker), userInfo: nil, repeats: true)
            
            body_hip.run(CharacterAnimations.hipStartWalk)
            body_head.run(CharacterAnimations.headStartWalk)
            body_chest.run(CharacterAnimations.chestStartWalk)
            
            if !isReaching.foregroundArm {
                body_arm_up_front.run(CharacterAnimations.frontHandStartWalkSwing)
            }
            if !isReaching.backgroundArm {
                body_arm_up_back.run(CharacterAnimations.backHandStartWalkSwing)
            }
            // After the start walk animation finishes, starts the normal walk animation
            footWalkTracker_b.run(CharacterAnimations.backFootStartWalk, completion: {
                self.starting_movement = false
                if self.moving {
                    self.body_hip.run(SKAction.repeatForever(CharacterAnimations.hipWalk))
                    self.body_head.run(SKAction.repeatForever(CharacterAnimations.headWalk))
                    self.body_chest.run(SKAction.repeatForever(CharacterAnimations.chestWalk))
                    
                    self.footWalkTracker_b.run(SKAction.repeatForever(CharacterAnimations.backFootWalk))
                    
                    if !self.isReaching.foregroundArm {
                        self.body_arm_up_back.run(SKAction.repeatForever(CharacterAnimations.backHandWalkSwing))
                    }
                }
            })
            footWalkTracker_f.run(CharacterAnimations.frontFootStartWalk, completion: {
                self.starting_movement = false
                if self.moving {
                    self.footWalkTracker_f.run(SKAction.repeatForever(CharacterAnimations.frontFootWalk))
                    
                    if !self.isReaching.backgroundArm {
                        self.body_arm_up_front.run(SKAction.repeatForever(CharacterAnimations.frontHandWalkSwing))
                    }
                }
            })
        }
    }
    func animate_stopWalk(){
        if moving {
            moving = false
            footWalkTracker_f.removeAllActions()
            footWalkTracker_b.removeAllActions()
            body_arm_up_back.removeAllActions()
            body_arm_down_back.removeAllActions()
            body_arm_up_front.removeAllActions()
            body_arm_down_front.removeAllActions()
            body_chest.removeAllActions()
            body_head.removeAllActions()
            body_hip.removeAllActions()
            
            
//            body_hip.run(SKAction.move(to: startPos , duration: 0.25))
            body_head.run(SKAction.rotate(toAngle: 0, duration: 0.25))
            body_chest.run(SKAction.rotate(toAngle: 0, duration: 0.25))
            
            walkStepTimer.invalidate()
            restLeg(frontLeg: true, backLeg: true)
            if !isReaching.foregroundArm {
                restArm(foregroundArm: true, backgroundArm: false)
            }
            if !isReaching.backgroundArm {
                restArm(foregroundArm: false, backgroundArm: true)
            }
        }
    }
    @objc func stepToWalkTracker(){
        stepTo(footWalkTracker_f, withFrontLeg: true, withBackLeg: false)
        stepTo(footWalkTracker_b, withFrontLeg: false, withBackLeg: true)
    }
    
    func startRotatingAnimation(){
        isFacing.rotate()
    }
    
    //MARK: - Kinematics
    func moveByVector(_ dx: CGFloat){
        if dx > 0 { //right
            if isFacing.left {
                startRotatingAnimation()
            } else {
                body_hip.xScale = 1
                if dx > 1 {
                    animate_run()
                    //body_hip.runAction(SKAction.moveBy(CGVector(dx: 2, dy: 0), duration: 0.1))
                } else {
                    animate_walk()
                    //body_hip.runAction(SKAction.moveBy(CGVector(dx: 1.5, dy: 0), duration: 0.1))
                }
                body_hip.physicsBody?.applyImpulse(CGVector(dx: dx, dy: 0)) // should be dx: dx
            }
        } else if dx < 0 { //left
            if isFacing.right {
                startRotatingAnimation()
            } else {
                body_hip.xScale = -1
                if dx > 1 {
                    animate_run()
                } else {
                    animate_walk()
                }
                body_hip.physicsBody?.applyImpulse(CGVector(dx: dx, dy: 0))
            }
        } else if dx == 0 {
            animate_stopWalk()
        }
    }
    
    func addContactNode(_ node: SKNode) {
//        if !legInterceptors.contains(node) {
//            legInterceptors.append(node)
//        }
//        if !isStepping.foregroundLeg {
//            checkStep()
//        }
        
        if !armInterceptors.contains(node) {
            armInterceptors.append(node)
        }
        if !isReaching.foregroundArm {
            checkReach()
        }
        
    }
    func removeContactNode(_ node: SKNode) {
//        if let i = legInterceptors.index(of: node) {
//            legInterceptors.remove(at: i)
//        }
//        if isStepping.foregroundLeg {
//            checkStep()
//        }
        
        if let i = armInterceptors.index(of: node) {
            armInterceptors.remove(at: i)
        }
        if isReaching.foregroundArm {
            checkReach()
        }
        
    }
    
    @objc func checkReach() {
        if armInterceptors.count != 0 {
            var closestNode = armInterceptors[0]
            if armInterceptors.count > 1 {
                for n in 1..<armInterceptors.count {
                    if armInteraction.position.distance(armInterceptors[n].position) < armInteraction.position.distance(closestNode.position) {
                        closestNode = armInterceptors[n]
                    }
                }
            }
            reachTo(closestNode.position, withFrontArm: true, withBackArm: false)
            lookTo(closestNode.position)
            if !isReaching.foregroundArm { //if character wasn't reaching_f before this point, keep repeating the action
                reachUpdateTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(CharacterSpriteNode.checkReach), userInfo: nil, repeats: true)
                isReaching.foregroundArm = true
            }
        } else {
            isReaching.foregroundArm = false
            reachUpdateTimer.invalidate()
            restNeck()
            restArm(foregroundArm: true, backgroundArm: false)
        }
    }
    
    @objc func checkStep() {
        if legInterceptors.count != 0 {
            var closestNode = legInterceptors[0]
            if legInterceptors.count > 1 {
                for n in 1..<legInterceptors.count {
                    if legInteraction.position.distance(legInterceptors[n].position) < legInteraction.position.distance(closestNode.position) {
                        closestNode = legInterceptors[n]
                    }
                }
            }
            stepTo(closestNode, withFrontLeg: true, withBackLeg: false)
            if !isStepping.foregroundLeg { //if character wasn't stepping before this point, keep repeating the action
                stepUpdateTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(CharacterSprite.checkStep), userInfo: nil, repeats: true)
                isStepping.foregroundLeg = true
            }
        } else {
            isStepping.foregroundLeg = false
            stepUpdateTimer.invalidate()
            restLeg(frontLeg: true, backLeg: false)
        }
    }
    
    func printStepPoint(_ point: CGPoint) {
        stepFrameRecorder += 1
        print("    -+- \(stepFrameRecorder) -+- Anim Leg Point: (\(point.x), \(point.y))")
    }
    
    //    func checkLegReach(stepPoint: SKNode) {
    //        if legInteraction.intersectsNode(footWalkTracker) {
    //            stepTo(footWalkTracker, withFrontLeg: true, withBackLeg: false)
    //            stepTo(footWalkTracker_b, withFrontLeg: false, withBackLeg: true)
    //        } else {
    //            restLeg(frontLeg: true, backLeg: false)
    //        }
    //    }
    
    /// Runs the rest animation on the neck
    func restNeck(){
        body_neck.run(SKAction.rotate(toAngle: 0, duration: 0.75))
    }
    
    /// Runs the rest animation on the selected arm(s).
    func restArm(foregroundArm: Bool, backgroundArm: Bool){
        if foregroundArm && !isReaching.foregroundArm {
            body_arm_up_front.run(SKAction.rotate(toAngle: 0, duration: 0.25))
            body_arm_down_front.run(SKAction.rotate(toAngle: 15 * CGFloat(M_PI) / 180, duration: 0.75))
        }
        if backgroundArm && !isReaching.backgroundArm {
            body_arm_up_back.run(SKAction.rotate(toAngle: 0, duration: 0.4))
            body_arm_down_back.run(SKAction.rotate(toAngle: 15 * CGFloat(M_PI) / 180, duration: 0.7))
        }
    }
    
    
    /// Runs the rest animation on the selected leg(s).
    func restLeg(frontLeg: Bool, backLeg: Bool){
        if frontLeg {
            body_leg_up_front.run(SKAction.rotate(toAngle: 0, duration: 0.25))
            body_leg_down_front.run(SKAction.rotate(toAngle: 0, duration: 0.25))
            footWalkTracker_f.run(SKAction.move(to: CGPoint(x: 0, y: -40), duration: 0.25))
        }
        if backLeg {
            body_leg_up_back.run(SKAction.rotate(toAngle: 0, duration: 0.25))
            body_leg_down_back.run(SKAction.rotate(toAngle: 0, duration: 0.25))
            footWalkTracker_b.run(SKAction.move(to: CGPoint(x: 0, y: -40), duration: 0.25))
        }
    }
    
    /// Attempt to have character reach arm(s) out to a point
    func reachTo(_ p: CGPoint, withFrontArm: Bool, withBackArm: Bool){
        let sX = body_hip.position.x + body_chest.position.x + body_arm_up_front.position.x //shoulderX
        let sY = body_hip.position.y + body_chest.position.y + body_arm_up_front.position.y //shoulderY
        
        var reachDistanceSq: CGFloat = pow(p.x - sX, 2) + pow(p.y - sY, 2)
        if reachDistanceSq > armReach_maxSq {
            reachDistanceSq = armReach_maxSq
        } else if reachDistanceSq < armReach_minSq {
            reachDistanceSq = armReach_minSq
        }
        // (note atan2 is a costly function)
        let radsBtwnReachAndHorizon = body_hip.xScale * atan2(body_hip.xScale * (sY - p.y), body_hip.xScale * (p.x - sX))// L/R facing dependence by checking xScale sign
        let radsBtwnReachAndUpArm = acos((armLength_downSq - armLength_upSq - reachDistanceSq) / (-2 * armLength_up * sqrt(reachDistanceSq))) //law of cosines
        let radsBtwnUpArmAndLowArm = acos(max(min((reachDistanceSq - armLength_upSq - armLength_downSq) / -(2 * armLength_up * armLength_down), 1), -1)) //law of cosines
        let radsBtwnVertAndUpArm = CGFloat(M_PI)/2 - radsBtwnReachAndHorizon - radsBtwnReachAndUpArm
        
        let zUpAction = SKAction.rotate(toAngle: radsBtwnVertAndUpArm, duration: 0.15)
        let zDoAction = SKAction.rotate(toAngle: CGFloat(M_PI) - radsBtwnUpArmAndLowArm, duration: 0.1)
        
        if withFrontArm {
            body_arm_up_front.run(zUpAction)
            body_arm_down_front.run(zDoAction)
        }
        if withBackArm {
            body_arm_up_back.run(zUpAction)
            body_arm_down_back.run(zDoAction)
        }
    }
    
    /// Attempt to have character look at a point (rotate neck)
    func lookTo(_ p: CGPoint){
        let nX = body_hip.position.x + body_chest.position.x + body_neck.position.x //neckX
        let nY = body_hip.position.y + body_chest.position.y + body_neck.position.y //neckY
        
        let radsBtwnNeckAndVert = CGFloat(M_PI) / 2 - acos(neckLength / CGPoint(x: nX, y: nY).distance(CGPoint(x: p.x, y: p.y))) + body_hip.xScale*atan2(body_hip.xScale*(p.y-nY), body_hip.xScale*(p.x-nX))
        let degsBtwnNeckAndVert = radsBtwnNeckAndVert * 180 / CGFloat(M_PI)
        
        // Maximum neck bend is 30° both forwards and backwards tilt
        if (degsBtwnNeckAndVert < 30) && (degsBtwnNeckAndVert > -30) {
            body_neck.run(SKAction.rotate(     toAngle: radsBtwnNeckAndVert, duration: 0.2))
        } else if (degsBtwnNeckAndVert > 30){
            body_neck.run(SKAction.rotate( toAngle: 30 * CGFloat(M_PI) / 180, duration: 0.2))
        } else {
            body_neck.run(SKAction.rotate(toAngle: -30 * CGFloat(M_PI) / 180, duration: 0.2))
        }
    }
    /// Attempt to have character reach leg(s) out to a node's location
    func stepTo(_ node: SKNode, withFrontLeg: Bool, withBackLeg: Bool){
        let hX = body_hip.position.x + body_leg_up_front.position.x //hipX
        let hY = body_hip.position.y + body_leg_up_front.position.y //hipY
        let fX = (node.name != "footWalkTracker") ? node.position.x : body_hip.position.x + node.position.x //footX, since footTrackers are children of body_hip
        let fY = (node.name != "footWalkTracker") ? node.position.y : body_hip.position.y + node.position.y //footY, since footTrackers are children of body_hip
        
        var stepDistanceSq: CGFloat = pow(fX - hX, 2) + pow(fY - hY, 2)
        if stepDistanceSq > legReach_maxSq {
            stepDistanceSq = legReach_maxSq
        } else if stepDistanceSq < legReach_minSq {
            stepDistanceSq = legReach_minSq
        }
        //law of cosines (note atan2 is a costly function)
        let radsBtwnVertAndStep = body_hip.xScale * atan2(fX - hX, hY - fY) // L/R facing dependence by checking xScale sign
        let radsBtwnUpLegAndStep = acos((legLength_downSq - legLength_upSq - stepDistanceSq) / (-2 * legLength_up * sqrt(stepDistanceSq)))
        let radsBtwnVertAndUpLeg = radsBtwnVertAndStep + radsBtwnUpLegAndStep
        let radsBtwnUpLegAndLowLeg = acos((stepDistanceSq - legLength_upSq - legLength_downSq) / (-2 * legLength_down * legLength_up))
        
        let zUpAction = SKAction.rotate(toAngle: radsBtwnVertAndUpLeg, duration: 0.02)
        let zDoAction = SKAction.rotate(toAngle: -CGFloat(M_PI) + radsBtwnUpLegAndLowLeg, duration: 0.02)
        
        if withBackLeg {
            body_leg_up_back.run(zUpAction)
            body_leg_down_back.run(zDoAction)
        }
        if withFrontLeg {
            body_leg_up_front.run(zUpAction)
            body_leg_down_front.run(zDoAction)
        }
    }
}
