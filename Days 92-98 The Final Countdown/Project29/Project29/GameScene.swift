//
//  GameScene.swift
//  Project29
//
//  Created by Marcos Martinelli on 2/13/21.
//
enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}
import SpriteKit

class GameScene: SKScene {
    var buildings = [BuildingNode]()
    weak var viewController: GameViewController?
    
    var playerOne: SKSpriteNode!
    var playerTwo: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var currentPlayer = 1
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        createBuildings()
        createPlayers()
    }
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + 2
            
            let building = BuildingNode(color: UIColor.red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    func launch(angle: Int, velocity: Int) {
        let speed = Double(velocity) / 10
        let radians = deg2rad(degrees: angle)
        
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(banana)
        
        if currentPlayer == 1 {
            banana.position = CGPoint(
                x: playerOne.position.x - 30,
                y: playerOne.position.y + 40
            )
            banana.physicsBody?.angularVelocity = -20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let pause = SKAction.wait(forDuration: 0.15)
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            
            playerOne.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            banana.position = CGPoint(
                x: playerTwo.position.x + 30,
                y: playerTwo.position.y + 40
            )
            banana.physicsBody?.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let pause = SKAction.wait(forDuration: 0.15)
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            
            playerTwo.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
    }
    func createPlayers() {
        // playerOne
        playerOne = SKSpriteNode(imageNamed: "player")
        playerOne.name = "player1"
        playerOne.physicsBody = SKPhysicsBody(circleOfRadius: playerOne.size.width / 2)
        playerOne.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        playerOne.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        playerOne.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        playerOne.physicsBody?.isDynamic = false
        
        let playerOneBuilding = buildings[1]
        playerOne.position = CGPoint(
            x: playerOneBuilding.position.x,
            y: playerOneBuilding.position.y + ((playerOneBuilding.size.height + playerOne.size.height) / 2)
        )
        
        addChild(playerOne)
        
        // playerTwo
        playerTwo = SKSpriteNode(imageNamed: "player")
        playerTwo.name = "player2"
        playerTwo.physicsBody = SKPhysicsBody(circleOfRadius: playerTwo.size.width / 2)
        playerTwo.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        playerTwo.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        playerTwo.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        playerTwo.physicsBody?.isDynamic = false
        
        let playerTwoBuilding = buildings[buildings.count - 2]
        playerTwo.position = CGPoint(
            x: playerTwoBuilding.position.x,
            y: playerTwoBuilding.position.y + ((playerTwoBuilding.size.height + playerTwo.size.height) / 2)
        )
        
        addChild(playerTwo)
    }
    func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * .pi / 180
    }
}
