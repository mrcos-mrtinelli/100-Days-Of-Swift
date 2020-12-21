//
//  ViewController.swift
//  Project8
//
//  Created by Marcos Martinelli on 12/16/20.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var solutionsLabel: UILabel!
    var scoreLabel: UILabel!
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    
    // game state properties
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var totalClues = 0
    var correctSubmissions = 0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        // score label
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: \(score)"
        view.addSubview(scoreLabel)
        
        // clues label
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        cluesLabel.text = "CLUES"
        view.addSubview(cluesLabel)
        
        // solutions label
        solutionsLabel = UILabel()
        solutionsLabel.translatesAutoresizingMaskIntoConstraints = false
        solutionsLabel.font = UIFont.systemFont(ofSize: 24)
        solutionsLabel.numberOfLines = 0
        solutionsLabel.textAlignment = .right
        solutionsLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        solutionsLabel.text = "SOLUTIONS"
        view.addSubview(solutionsLabel)
        
        // current answer textfield
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        currentAnswer.placeholder = "Tap letter below to guess"
        view.addSubview(currentAnswer)
        
        // buttons
        let submit = UIButton(type: .system)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        view.addSubview(clear)
        
        // view
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(buttonsView)
        
        // NSLayoutConstraint to activate all constraints at once
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            solutionsLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            solutionsLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            solutionsLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            solutionsLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),

            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
            
        ])
        
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                
                let frame = CGRect(x: CGFloat(column * width), y: CGFloat(row * height), width: CGFloat(width), height: CGFloat(height))
                letterButton.frame = frame
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(loadLevel), with: nil)
    }
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    @objc func submitTapped(_ sender: UIButton) {
        guard let submittedAnswer = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: submittedAnswer) {
            activatedButtons.removeAll()
            correctSubmissions += 1
            
            var splitAnswers = solutionsLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = submittedAnswer
            solutionsLabel.text = splitAnswers?.joined(separator: "\n")
            
            score += 1
            
            currentAnswer.text = ""
            
            if correctSubmissions == totalClues {
                let ac = UIAlertController(title: "Well done!", message: "Ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            
            score -= 1
            
            let ac = UIAlertController(title: "Sorry!", message: "That does not match any solutions.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
            present(ac, animated: true)
        }
        
    }
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        
        activatedButtons.removeAll(keepingCapacity: true)
    }
    @objc func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
                
        totalClues = 0
        correctSubmissions = 0
        
        if let fileURL = Bundle.main.url(forResource: "level\(level)", withExtension: ".txt") {
            if let fileContents = try? String(contentsOf: fileURL) {
                var lines = fileContents.components(separatedBy: "\n")
                lines.shuffle()
                
                totalClues = lines.count
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let solution = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = solution.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = solution.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        // configure labels and trim the last \n from string
        DispatchQueue.main.async {
            [weak self] in
            self?.solutionsLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            letterBits.shuffle()
            
            if letterBits.count == self?.letterButtons.count {
                guard let totalLetterButtons = self?.letterButtons.count else { return }
                for i in 0..<totalLetterButtons {
                    self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
                }
            }
        }
    }
    func levelUp(action: UIAlertAction) {
        level = level == 2 ? 1 : level + 1
        solutions.removeAll(keepingCapacity: true)
        
        loadLevel()
        
        for button in letterButtons {
            button.isHidden = false
        }
    }
}

