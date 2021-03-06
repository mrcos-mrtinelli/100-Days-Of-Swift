//
//  GameScene.swift
//  Project26
//
//  Created by Marcos Martinelli on 2/4/21.
//
import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
}
enum ElementType: String {
    case block = "block"
    case vortex = "vortex"
    case star = "star"
    case finish = "finish"
}
enum GameOverType {
    case finish, enemy
}
class GameScene: SKScene {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var scoreLabel: SKLabelNode!
    var gameOverOverlay: SKSpriteNode!
    var gameOverLabel: SKLabelNode!
    var nextLevelLabel: SKLabelNode!
    var playAgainLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var isGameOver = false
    
    var motionManager: CMMotionManager?
    
    override func didMove(to view: SKView) {
        let bg = SKSpriteNode(imageNamed: "background")
        
        bg.position = CGPoint(x: 512, y: 384)
        bg.zPosition = -1
        bg.blendMode = .replace
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 36)
        scoreLabel.zPosition = 2
        scoreLabel.text = "Score: 0"
        
        addChild(scoreLabel)
        addChild(bg)
        
        loadLevel()
        createPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    //MARK: - Game Scene Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location

        for node in nodes(at: location) {
            if node.name == "playAgain" {
                playAgain()
            } else if node.name == "nextLevel" {
                print("next level")
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y, dy: accelerometerData.acceleration.x)
        }
        #endif
    }
    
    //MARK: - Game Functions
    func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level1", withExtension: "txt") else {
            fatalError("Could not find resource")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not read file")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (col, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * col) + 32, y: (64 * row) - 32)
                
                switch letter {
                case "x":
                    create(.block, at: position)
                case "v":
                    create(.vortex, at: position)
                case "s":
                    create(.star, at: position)
                case "f":
                    create(.finish, at: position)
                case " ":
                    // do nothing
                    break
                default:
                    fatalError("Unknown letter: \(letter)")
                }
            }
        }
    }
    func create(_ element: ElementType, at position: CGPoint) {
        let elementName = element.rawValue
        let node = SKSpriteNode(imageNamed: elementName)
        
        node.position = position
        
        if element == .block {
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        } else {
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
        }
        
        switch element {
        case .block:
            node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        case .vortex:
            node.name = elementName
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
            node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        case .star:
            node.name = elementName
            node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        case .finish:
            node.name = elementName
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        }
        
        node.physicsBody?.isDynamic = false
        
        addChild(node)
    }
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5

        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    func playerCollided( with node: SKNode) {
        if node.name == "vortex" {
            score -= 1

            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence)
            gameOver(by: .enemy)
            
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            // next level code for challenge
            gameOver(by: .finish)
        }
    }
    func gameOver(by gameOver: GameOverType) {
        var message: String!
        
        player.physicsBody?.isDynamic = false
        isGameOver = true
        
        if gameOver == .finish {
            message = "Nice Job!"
            
            nextLevelLabel = SKLabelNode(fontNamed: "Chalkduster")
            nextLevelLabel.name = "nextLevel"
            nextLevelLabel.fontSize = 48
            nextLevelLabel.text = "Play Next Level!"
            nextLevelLabel.position = CGPoint(x: 512, y: 310)
            nextLevelLabel.zPosition = 2
            addChild(nextLevelLabel)
            
        } else if gameOver == .enemy {
            message = "Awww Shucks!"
        }
        
        gameOverOverlay = SKSpriteNode(color: UIColor.black, size: CGSize(width: 1024, height: 768))
        gameOverOverlay.position = CGPoint(x: 512, y: 384)
        gameOverOverlay.zPosition = 1
        gameOverOverlay.alpha = 0.4
        addChild(gameOverOverlay)
        
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.fontSize = 72
        gameOverLabel.fontColor = UIColor.yellow
        gameOverLabel.text = message
        gameOverLabel.position = CGPoint(x: 512, y: 454)
        gameOverLabel.zPosition = 2
        addChild(gameOverLabel)
        
        playAgainLabel = SKLabelNode(fontNamed: "Chalkduster")
        playAgainLabel.name = "playAgain"
        playAgainLabel.fontSize = 36
        playAgainLabel.text = "Play Again"
        playAgainLabel.position = CGPoint(x: 512, y: 400)
        playAgainLabel.zPosition = 2
        addChild(playAgainLabel)
 
    }
    func dismissGameOver() {
        gameOverOverlay.removeFromParent()
        gameOverLabel.removeFromParent()
        playAgainLabel.removeFromParent()
        
        if nextLevelLabel != nil {
            nextLevelLabel.removeFromParent()
        }
        
        player.removeFromParent()
    }
    func playAgain() {
        dismissGameOver()
        createPlayer()
        isGameOver = false
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }   
    }
}
