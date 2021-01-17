//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Marcos Martinelli on 1/16/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var timeLabel: SKLabelNode!
    
    var timeLeft = 0 {
        didSet {
            timeLabel.text = "\(timeLeft)s remaining"
        }
    }
    var targetsHit = 0 {
        didSet {
            scoreLabel.text = "Targets hit: \(targetsHit)"
        }
    }
    
    var rows = [CGFloat]()
    var targetTimer: Timer?
    var gameTimer: Timer?
    
    //MARK: - CLASS FUNCTIONS
    override func didMove(to view: SKView) {
        
        let rowInts = [600, 410, 215]
        
        rows = rowInts.map({ row in
            return CGFloat(row)
        })
        
        // SET BACKGROUND
        let background = SKSpriteNode(imageNamed: "background")
        background.size.width = 1638
        background.size.height = 1229
        background.position = CGPoint(x: 512, y: 150)
        background.zPosition = -1
        addChild(background)
        
        let backgroundShelves = SKSpriteNode(imageNamed: "backgroundShelves")
        backgroundShelves.size.width = 1124
        backgroundShelves.size.height = self.size.height
        backgroundShelves.position = CGPoint(x: 512, y: 384)
        backgroundShelves.zPosition = 1
        addChild(backgroundShelves)
        
        // SET LABELS
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 36
        scoreLabel.position = CGPoint(x: 200, y: 700)
        addChild(scoreLabel)
        
        timeLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLabel.fontSize = 36
        timeLabel.position = CGPoint(x: 210, y: 660)
        addChild(timeLabel)
        
        // START GAME
        startGame()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        run(SKAction.playSoundFileNamed("shoot.caf", waitForCompletion: false))
        
        for node in tappedNodes {
            
            if node.name == "target" {
                run(SKAction.playSoundFileNamed("hit.caf", waitForCompletion: false))
                node.xScale = -0.85
                node.yScale = -0.85
                node.removeFromParent()
                targetsHit += 1
            }
            
        }
        
        
    }
    
    //MARK: - GAME FUNCTIONS
    @objc func createTarget() {
        
        guard let randomRow = rows.randomElement() else { return }
        let target = SKSpriteNode(imageNamed: "target")
        var moveTo = CGFloat(1300)
        
        target.name = "target"
        target.size = CGSize(width: 100, height: 100)
        target.zPosition = 0
        
        if randomRow == CGFloat(410) {
            target.position = CGPoint(x: 1300, y: randomRow)
            moveTo = CGFloat(-1300)
        } else {
            target.position = CGPoint(x: -100, y: randomRow)
        }
        
        target.run(SKAction.moveBy(x: moveTo, y: 0, duration: 6))
        addChild(target)
    }
    @objc func updateTimer() {
        timeLeft -= 1
        
        if timeLeft == 0 {
            gameTimer?.invalidate()
            targetTimer?.invalidate()
        }
    }
    func startGame() {
        
        timeLeft = 30
        targetsHit = 0
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: [], repeats: true)
        
        targetTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createTarget), userInfo: [], repeats: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            self.targetTimer?.invalidate()
        }
    }
}
