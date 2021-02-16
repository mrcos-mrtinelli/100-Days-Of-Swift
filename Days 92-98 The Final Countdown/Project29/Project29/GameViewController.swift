//
//  GameViewController.swift
//  Project29
//
//  Created by Marcos Martinelli on 2/13/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    weak var currentGame: GameScene?
    
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    
    @IBOutlet var player1ScoreLabel: UILabel!
    @IBOutlet var player2ScoreLabel: UILabel!
    @IBOutlet var playAgainButton: UIButton!
    
    var isGameOver = false
    var timer: Timer?
    
    var player1Score = 0 {
        didSet {
            player1ScoreLabel.text = "P1: \(player1Score)"
        }
    }
    var player2Score = 0 {
        didSet {
            player2ScoreLabel.text = "P2: \(player2Score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self

            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
            player1Score = 0
            player2Score = 0
            angleChanged(self)
            velocityChanged(self)
        }
    }
    func updateScore(forPlayerNumber player: Int) {
        if player == 1 {
            player1Score += 1
        } else {
            player2Score += 1
        }
        
        if player1Score == 3 {
            playerNumber.text = "WINNER: PLAYER 1"
            gameOver()
        } else if player2Score == 3 {
            playerNumber.text = "WINNER: PLAYER 2"
            gameOver()
        }
    }
    func playerNumber(isBlinking: Bool) {
        var showHide = true

        if !isBlinking {
            timer?.invalidate()
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.playerNumber.isHidden = showHide
            showHide = !showHide
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    @IBAction func launch(_ sender: Any) {
        gameControls(isHidden: true)
        
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }
        
        gameControls(isHidden: false)
        
    }
    func gameControls(isHidden: Bool) {
        angleSlider.isHidden = isHidden
        angleLabel.isHidden = isHidden
        velocityLabel.isHidden = isHidden
        velocitySlider.isHidden = isHidden
        launchButton.isHidden = isHidden
    }
    func gameOver() {
        isGameOver = true
        gameControls(isHidden: true)
        playerNumber(isBlinking: true)
        playAgainButton.isHidden = false
    }
    @IBAction func playAgainTapped(_ sender: Any) {
        player1Score = 0
        player2Score = 0
        
        gameControls(isHidden: false)
        playerNumber(isBlinking: false)
        playAgainButton.isHidden = true
        
        isGameOver = false
        currentGame?.newGame(delay: 0)
    }
}
