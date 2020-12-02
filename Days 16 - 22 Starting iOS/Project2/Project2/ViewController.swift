//
//  ViewController.swift
//  Project2
//
//  Created by Marcos Martinelli on 11/30/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var totalQuestionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        totalQuestionsAsked += 1
        
        title = "\(countries[correctAnswer].uppercased()) (Score: \(score))"
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        var alertTitle: String
        var message: String
        var alertAction = "Continue"
        
        if sender.tag == correctAnswer {
            alertTitle = "Correct!"
            score += 1
            message = "Your score is \(score)"
        } else {
            alertTitle = "Incorrect."
            score -= 1
            message = "That is the flag for \(countries[sender.tag].uppercased()) "
        }
        
        if totalQuestionsAsked == 3 {
            alertTitle = "Game Over"
            message = "Your final score is \(score)/\(totalQuestionsAsked)"
            alertAction = "Play again!"
            score = 0
            totalQuestionsAsked = 0
        }
        showStats(title: alertTitle, message: message, alertAction: alertAction)
        
    }
    func showStats(title: String, message: String, alertAction: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: alertAction, style: .default, handler: askQuestion))
        
        present(ac, animated: true)
    }
    
}

