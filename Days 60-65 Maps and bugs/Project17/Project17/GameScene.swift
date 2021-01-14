//
//  GameScene.swift
//  Project17
//
//  Created by Marcos Martinelli on 1/12/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // SET UP PROPERTIES
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var enemiesCreated = 0
    var gameTimer: Timer?
    var timeInterval = 0.35
    var isGameOver = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // CLASS FUNCTIONS
    override func didMove(to view: SKView) {
        // CONFIGURE BACKGROUND
        backgroundColor = .black
        starfield = SKEmitterNode(fileNamed: "starfield")
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.zPosition = -1
        // avoid starting with blank screen by advancing the emitter animation by 10s
        starfield.advanceSimulationTime(10)
        
        addChild(starfield)
        
        // CONFIGURE PLAYER
        player = SKSpriteNode(imageNamed: "player")
        // draw a physicsBody around (.texture) the player's body @ the same .size
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        // mask that indicates which category triggers a notification when in contact
        player.physicsBody?.contactTestBitMask = 1
        player.position = CGPoint(x: 100, y: 384)
        
        addChild(player)
        
        // CONFIGURE SCORE LABEL
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        
        addChild(scoreLabel)
        score = 0 // didSet sets the text for our label
        
        // CONFIGURE GRAVITY
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        // CHALLENGE: Start game timer after 1 second
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self!.startTimer(withInterval: self!.timeInterval)
        }
        
    }
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        if !isGameOver {
            score += 1
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get the first touch
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        // set the touch to be between a channel
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        // set the player's position to the location of the touch
        player.position = location
    }
    // CHALLENGE: Prevent player from cheating by touching a different area of the game
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // reset player position to it's original position
        player.position = CGPoint(x: 100, y: 384)
    }
    func didBegin(_ contact: SKPhysicsContact) {
        // what to do when the player collides
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        
        addChild(explosion)
        player.removeFromParent()
        isGameOver = true
        
        gameTimer?.invalidate()
    }
    // GAME FUNCTIONS
    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        enemiesCreated += 1
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        // set the physicsBody mask category to 1 so our player crashes with it
        sprite.physicsBody?.categoryBitMask = 1
        // push the sprite so it starts to move left
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        // make it spin at velocity
        sprite.physicsBody?.angularVelocity = 5
        // remove resistance to world so it doesn't slow down (we're in space)
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        addChild(sprite)
        
        if enemiesCreated > 20 {
            enemiesCreated = 0
            
            gameTimer?.invalidate()
            startTimer(withInterval: timeInterval - 0.1)
        }
    }
    @objc func startTimer(withInterval interval: Double = 0.35 ) {
        gameTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(createEnemy), userInfo: [], repeats: true)
    }
}
