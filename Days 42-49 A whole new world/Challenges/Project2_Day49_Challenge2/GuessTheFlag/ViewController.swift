//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Marcos Martinelli on 11/27/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var highScore: Int?
    var totalQuestionsAsked = 0
    var correctAnswer = 0 // holds the correct answer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScore))
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        loadHighScore()
        askQuestion()
    }
    func loadHighScore() {
        let ud = UserDefaults.standard
        highScore = ud.integer(forKey: "highScore")
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)

        title =  "Which is the \(countries[correctAnswer].uppercased()) flag? (Score: \(score))"
        totalQuestionsAsked += 1
    }
    func showStats(title: String, message: String, score: Int) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present(ac, animated: true)
    }
    
    @objc func showScore() {
        let ac = UIAlertController(title: "Current Score", message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var statsTitle: String
        var message: String
        
        if sender.tag == correctAnswer {
            statsTitle = "Correct"
            score += 1
            message = "Your score is \(score)"
        } else {
            statsTitle = "Wrong"
            score -= 1
            message = "That is the flag for \(countries[sender.tag].uppercased())"
        }
        
        if totalQuestionsAsked < 10 {
            showStats(title: statsTitle, message: message, score: score)
        } else {
            let finalScore = score
            guard let newHighScore = highScore else { return }
            
            if finalScore > newHighScore {
                statsTitle = "Congratulations!"
                message = "You have a new high score of \(finalScore)"
            } else {
                statsTitle = "Game Over"
                message = "You scored \(finalScore) out of \(totalQuestionsAsked)."
            }
            
            totalQuestionsAsked = 0
            score = 0
            
            showStats(title: statsTitle, message: message, score: finalScore)
        }
    }
}

