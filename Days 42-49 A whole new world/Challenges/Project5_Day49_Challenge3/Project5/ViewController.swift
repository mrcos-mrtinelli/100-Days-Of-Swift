//
//  ViewController.swift
//  Project5
//
//  Created by Marcos Martinelli on 12/8/20.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    var savedWords = [String: [String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New word", style: .plain, target: self, action: #selector(startGame))
        
        // LOADING WORD INTO ARRAY FROM FILE
        // 1. find the file
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
        // 2. grab the contents of the file and place it in an
            if let startWords = try? String(contentsOf: startWordsURL) {
        // 3. break up the string into an array of words
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        // if the above all fails
        if allWords.isEmpty {
            allWords = ["empty"]
        }
        
        let ud = UserDefaults.standard
        savedWords = ud.object(forKey: "savedWords") as? [String: [String]] ?? [String: [String]]()
        
        if savedWords.isEmpty {
            startGame()
        } else {
            continueGame()
        }
    }
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    func continueGame() {
        guard let savedTitle = savedWords["title"] else { return }
        guard let savedUsedWords = savedWords["usedWords"] else { return }
        
        title = savedTitle[0]
        usedWords += savedUsedWords
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Word")
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter a word", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
                guard let answer = ac?.textFields?[0].text else { return }
            // BUG ALERT
            // self?.submit(answer)
            self?.submit(answer.lowercased())
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    guard let titleWord = title?.lowercased() else { return }
                    
                    usedWords.insert(answer, at: 0)
                    
                    saveWords(title: titleWord, usedWords: usedWords)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    showErrorMessage(title: "Invalid!", message: "That's not a real word.")
                }
            } else {
                showErrorMessage(title: "Again?", message: "You've already used that word.")
            }
        } else {
            guard let title = title?.lowercased() else { return }
            showErrorMessage(title: "Nope.", message: "You cannot spell \(lowerAnswer) from \(title)")
        }
    }
    func saveWords(title: String, usedWords: [String]) {
        let ud = UserDefaults.standard
        let savingWords = [
            "title": [title],
            "usedWords": usedWords
        ]
        
        ud.setValue(savingWords, forKey: "savedWords")
    }
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    func isReal(word: String) -> Bool {
        guard let currentWord = title?.lowercased() else { return false }
        
        if word.count < 3 || word == currentWord {
            return false
        } else {
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            
            return misspelledRange.location == NSNotFound
        }
    }
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }

}

