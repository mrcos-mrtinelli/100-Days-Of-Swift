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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
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
        
        startGame()
        
    }
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
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
                self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    func submit(_ answer: String) {
        
    }

}

