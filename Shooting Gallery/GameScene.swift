//
//  GameScene.swift
//  Shooting Gallery
//
//  Created by Kyle on 8/7/20.
//  Copyright © 2020 Kyle. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var timeLabel: SKLabelNode!
    
    var possibleEnemies = EnemyType.allCases 
    var gameTimer: Timer?
    var isGameOver = false
    
    var timeRemaining = 60 {
        didSet {
            timeLabel.text = "Time Remaining \(timeRemaining)"
        }
    }

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        backgroundColor = .black

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        score = 0
        
        timeLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLabel.position = CGPoint(x: 16, y: 32)
        timeLabel.horizontalAlignmentMode = .left
        addChild(timeLabel)

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        gameTimer = Timer.scheduledTimer(timeInterval: 0.50, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }

    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite:SKSpriteNode!
        switch enemy {
            case .small:
                  sprite = SKSpriteNode(imageNamed: "targetSmall")
                  sprite.name = "small"
                  sprite.size = CGSize(width: 50, height: 50)
            case .medium:
                  sprite = SKSpriteNode(imageNamed: "targetMedium")
                  sprite.size = CGSize(width: 100, height: 100)
                  sprite.name = "medium"
            case .large:
                  sprite = SKSpriteNode(imageNamed: "targetLarge")
                  sprite.size = CGSize(width: 150, height: 150)
                  sprite.name = "large"
        }
        
        let x: Int!
        let xVectorInt:Int!
        
        if Int.random(in:0...100) % 2 == 0 {
            x = -200
            xVectorInt = 200
        }
        else {
            x = 1200
            xVectorInt = -200
        }
        sprite.position = CGPoint(x: x, y: Int.random(in: 100...700))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.velocity = CGVector(dx: xVectorInt, dy: Int.random(in: -50...50))
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 || node.position.x > 1400 {
                node.removeFromParent()
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            switch node.name {
                case "small":
                    score += EnemyType.small.rawValue
                case "medium":
                    score += EnemyType.medium.rawValue
                case "large":
                    score += EnemyType.large.rawValue
                default:
                    break
            }
            
            node.removeFromParent()
        }

    }

}
