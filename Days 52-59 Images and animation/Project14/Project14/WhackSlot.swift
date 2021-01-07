//
//  WhackSlot.swift
//  Project14
//
//  Created by Marcos Martinelli on 1/5/21.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)

        addChild(cropNode)
    }
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.38))
        isVisible = true
        isHit = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    func hide() {
        if !isVisible { return }
        
        if let mud = SKEmitterNode(fileNamed: "Mud") {
            mud.zPosition = 1
            mud.position = CGPoint(x: charNode.position.x, y: charNode.position.y) 
            addChild(mud)
        }
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.38))
        isVisible = false
    }
    func hit() {
        isHit = true
        
        if let smokeEmitter = SKEmitterNode(fileNamed: "Smoke") {
            smokeEmitter.zPosition = 1
            smokeEmitter.position = CGPoint(x: charNode.position.x, y: charNode.position.y + 30)
            addChild(smokeEmitter)
        }
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.50)
        let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
        let sequence = SKAction.sequence([delay, hide, notVisible])
        
        charNode.run(sequence)
    }
}
