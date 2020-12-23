//
//  ViewController.swift
//  Project7-9
//
//  Created by Marcos Martinelli on 12/22/20.
//

import UIKit

class ViewController: UIViewController {

    var guessesLabel: UILabel!
    var clueLabel: UILabel!
    var wordLabel: UILabel!
    
    var qwertyKeyboard: UIView!
    var qwertyKeyRows = [UIView]()
    var qwertyKeys = [UIButton]()
    
    var wordsAndClues = [String]()
    var totalGuessesAllowed = 7
    var word = ""
    var clue = ""
    var guessedLetters = [Character]()
    
    var formattedWord: String {
        var displayWord = ""
        for letter in word {
            if guessedLetters.contains(letter) {
                displayWord += String(letter)
            } else {
                displayWord += "?"
            }
        }
        return displayWord
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        // score label
        guessesLabel = UILabel()
        guessesLabel.translatesAutoresizingMaskIntoConstraints = false
        guessesLabel.textAlignment = .right
        guessesLabel.text = "Remaining Guesses: 7"
        view.addSubview(guessesLabel)
        
        // word label
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 32)
        wordLabel.text = "WORD LABEL"
        view.addSubview(wordLabel)
        
        // clue label
        clueLabel = UILabel()
        clueLabel.translatesAutoresizingMaskIntoConstraints = false
        clueLabel.textAlignment = .center
        clueLabel.font = UIFont.systemFont(ofSize: 24)
        clueLabel.text = "CLUE LABEL"
        view.addSubview(clueLabel)
        
        // qwerty keyboard view
        qwertyKeyboard = UIView()
        qwertyKeyboard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(qwertyKeyboard)
        
        // qwerty key rows
        let keyRow1 = UIView()
        keyRow1.translatesAutoresizingMaskIntoConstraints = false
        qwertyKeyboard.addSubview(keyRow1)
        
        let keyRow2 = UIView()
        keyRow2.translatesAutoresizingMaskIntoConstraints = false
        qwertyKeyboard.addSubview(keyRow2)
        
        let keyRow3 = UIView()
        keyRow3.translatesAutoresizingMaskIntoConstraints = false
        qwertyKeyboard.addSubview(keyRow3)
        
        qwertyKeyRows += [keyRow1, keyRow2, keyRow3]
        
        NSLayoutConstraint.activate([
            // score label
            guessesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            guessesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            // word label
            wordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // clue label
            clueLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20),
            clueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // qwerty Keyboard
            qwertyKeyboard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            qwertyKeyboard.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            qwertyKeyboard.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            qwertyKeyboard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // qwerty Rows
            keyRow1.bottomAnchor.constraint(equalTo: keyRow2.topAnchor),
            keyRow1.centerXAnchor.constraint(equalTo: qwertyKeyboard.centerXAnchor),
            keyRow1.widthAnchor.constraint(equalTo: qwertyKeyboard.widthAnchor),
            keyRow1.heightAnchor.constraint(equalToConstant: 45),
            
            keyRow2.bottomAnchor.constraint(equalTo: keyRow3.topAnchor),
            keyRow2.centerXAnchor.constraint(equalTo: qwertyKeyboard.centerXAnchor),
            keyRow2.widthAnchor.constraint(equalTo: qwertyKeyboard.widthAnchor, multiplier: 0.9),
            keyRow2.heightAnchor.constraint(equalToConstant: 45),
            
            keyRow3.bottomAnchor.constraint(equalTo: qwertyKeyboard.bottomAnchor),
            keyRow3.centerXAnchor.constraint(equalTo: qwertyKeyboard.centerXAnchor),
            keyRow3.widthAnchor.constraint(equalTo: qwertyKeyboard.widthAnchor, multiplier: 0.7),
            keyRow3.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        let width = 35
        let height = 35

        for row in 0..<3 {
            let totalColumns = [10, 9, 7]
            let currentRow = totalColumns[row]

            for col in 0..<currentRow {
                let key = UIButton(type: .system)
                let currentRow = qwertyKeyRows[row]
                
                key.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                key.setTitle("Q", for: .normal)
                key.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)

                let frame = CGRect(x: CGFloat(col * width), y: CGFloat(0), width: CGFloat(width), height: CGFloat(height))
                key.frame = frame
                currentRow.addSubview(key)
                qwertyKeys.append(key)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // load keyboard
        guard let keysFileURL = Bundle.main.url(forResource: "qwertyKeys", withExtension: "txt") else { return }
        let contentsOfKeysFile = try? String(contentsOf: keysFileURL)
        
        if let keys = contentsOfKeysFile?.components(separatedBy: ",") {
            for (index,key) in keys.enumerated() {
                qwertyKeys[index].setTitle("\(key.uppercased())", for: .normal)
            }
        }
        loadWordsAndClues()
        newRound()
    }
    
    func loadWordsAndClues() {
        // load words and clues
        guard let wordsAndCluesFileURL = Bundle.main.url(forResource: "wordsAndClues", withExtension: "txt") else { return }
        let contentsOfWordsAndCluesFile = try? String(contentsOf: wordsAndCluesFileURL)
        
        if let lines = contentsOfWordsAndCluesFile?.components(separatedBy: "\n") {
            wordsAndClues += lines
        }
    }
    
    func newRound() {
        if !wordsAndClues.isEmpty {
            wordsAndClues.shuffle()
            let newWordAndClue = wordsAndClues.removeFirst().components(separatedBy: ": ")
            
            word = newWordAndClue[0]
            clue = newWordAndClue[1]
            
            updateUI()
        } else {
            // reload
            print("done")
            loadWordsAndClues()
            newRound()
        }
    }
    
    func updateUI() {
        wordLabel.text = formattedWord
        clueLabel.text = clue
        guessesLabel.text = "Remaining Guesses: \(totalGuessesAllowed)"
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let letterPressed = sender.title(for: .normal) else { return }
        let letter = Character(letterPressed)
        
        if word.contains(letter) {
            guessedLetters.append(letter)
            
            if formattedWord == word {
                guessedLetters.removeAll(keepingCapacity: true)
                newRound()
            }
        } else if totalGuessesAllowed > 0 {
            totalGuessesAllowed -= 1
        } else {
            guessedLetters.removeAll(keepingCapacity: true)
            totalGuessesAllowed = 7
            newRound()
        }
        updateUI()
    }
}

