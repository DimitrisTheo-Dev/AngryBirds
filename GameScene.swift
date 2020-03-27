//
//  GameScene.swift
//  AngryBirdsClone
//
//  Created by Jim Theodoropoulos on 26/3/20.
//  Copyright © 2020 Jim Theodoropoulos. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
   // var bird2 = SKSpriteNode()
    
    var bird = SKSpriteNode()
    var box1 = SKSpriteNode()
    var box2 = SKSpriteNode()
    var box3 = SKSpriteNode()
    var box4 = SKSpriteNode()
    var box5 = SKSpriteNode()
    
    var gameStarted = false
    var originalPosition : CGPoint?
    var score = 0
    var scoreLabel = SKLabelNode()
   
    
    enum ColliderType : UInt32 {
        case Bird = 1
        case Box = 2
        //Dont let box = 3 cause  1+2 = 3 and we dont want that same as tree var
        /*
        case Ground = 4
        case Tree = 8
        */
    }
    override func didMove(to view: SKView) {
        /*
        let texture = SKTexture(imageNamed: "frame-1") //this is used for textures
        bird2 = SKSpriteNode(texture: texture)
        bird2.position = CGPoint(x: 0, y: 0) // -self.frame.width / 4
        bird2.size = CGSize(width: self.frame.width / 15 , height: self.frame.height / 9)
        bird2.zPosition = 1 // 1 = in front of everything (layers)
        self.addChild(bird2)
       */
        //Bird
        bird = childNode(withName: "bird") as! SKSpriteNode
        let birdTexture = SKTexture(imageNamed: "frame-1")
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 12)
        bird.physicsBody?.affectedByGravity = false //Physical attributes
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.mass = 0.1 // Weight
        originalPosition = bird.position
        
        bird.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.collisionBitMask = ColliderType.Box.rawValue
        
        //Physics Body
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame) //Dont let the bird leave the screen
        self.scene?.scaleMode = .aspectFit
        self.physicsWorld.contactDelegate = self
        //BOX
        let boxtexture = SKTexture(imageNamed: "1")
        let size = CGSize(width: boxtexture.size().width / 6, height: boxtexture.size().height / 6)
        
        box1 = childNode(withName: "box1") as! SKSpriteNode
        box1.physicsBody = SKPhysicsBody(rectangleOf: size)
        box1.physicsBody?.affectedByGravity = true
        box1.physicsBody?.allowsRotation = true
        box1.physicsBody?.mass = 0.4
        box1.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        
        box2 = childNode(withName: "box2") as! SKSpriteNode
        box2.physicsBody = SKPhysicsBody(rectangleOf: size)
        box2.physicsBody?.affectedByGravity = true
        box2.physicsBody?.allowsRotation = true
        box2.physicsBody?.mass = 0.4
        box2.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        
        box3 = childNode(withName: "box3") as! SKSpriteNode
        box3.physicsBody = SKPhysicsBody(rectangleOf: size)
        box3.physicsBody?.affectedByGravity = true
        box3.physicsBody?.allowsRotation = true
        box3.physicsBody?.mass = 0.4
        box3.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        
        box4 = childNode(withName: "box4") as! SKSpriteNode
        box4.physicsBody = SKPhysicsBody(rectangleOf: size)
        box4.physicsBody?.affectedByGravity = true
        box4.physicsBody?.allowsRotation = true
        box4.physicsBody?.mass = 0.4
        box4.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        
        box5 = childNode(withName: "box5") as! SKSpriteNode
        box5.physicsBody = SKPhysicsBody(rectangleOf: size)
        box5.physicsBody?.affectedByGravity = true
        box5.physicsBody?.allowsRotation = true
        box5.physicsBody?.mass = 0.4
        box5.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        
        //Label
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 65
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: 0, y: self.frame.height / 4)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
       
    }
    
 
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 200)) // Flappy Bird
        bird.physicsBody?.affectedByGravity = true
       */
        //Check if bird tapped
        if gameStarted == false {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                if touchNodes.isEmpty == false {
                    for node in touchNodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                bird.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
        
        }
        
       
   
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let touchNodes = nodes(at: touchLocation)
            if touchNodes.isEmpty == false {
                for node in touchNodes {
                    if let sprite = node as? SKSpriteNode {
                        if sprite == bird {
                            bird.position = touchLocation
                        }
                    }
                }
            }
        }
       
    }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStarted == false {
            
            if let touch = touches.first {
                
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                if touchNodes.isEmpty == false {
                    for node in touchNodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                 //FInger drag
                                let dx = -(touchLocation.x - originalPosition!.x)
                                let dy = -(touchLocation.y - originalPosition!.y)
                                let impulse = CGVector(dx: dx, dy: dy)
                                bird.physicsBody?.applyImpulse(impulse)
                                bird.physicsBody?.affectedByGravity = true
                                gameStarted = true
                                
                            }
                        }
                    }
                }
        }
    }
}
        func didBegin(_ contact: SKPhysicsContact) {
            if contact.bodyA.collisionBitMask == ColliderType.Bird.rawValue || contact.bodyB.collisionBitMask == ColliderType.Bird.rawValue {
                score += 1
                scoreLabel.text = String(score)
            }
        }
 
    
    
    override func update(_ currentTime: TimeInterval) {
        //Called before each frame is rendered
        if let birdPhysicsBody = bird.physicsBody {
            if birdPhysicsBody.velocity.dx <= 0.1 && birdPhysicsBody.velocity.dy <= 0.1 && birdPhysicsBody.angularVelocity <= 0.1 && gameStarted == true {
                
                bird.physicsBody?.affectedByGravity = false
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.angularVelocity = 0
                bird.zPosition = 1
                bird.position = originalPosition!
                gameStarted = false
                score = 0
                scoreLabel.text = String(score)
            }
        }
        
    }

 

}
