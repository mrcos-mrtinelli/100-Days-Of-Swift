//
//  Game.swift
//  Project7-9
//
//  Created by Marcos Martinelli on 12/22/20.
//

import Foundation

struct Game {
    var word: String
    var clue: String
    var guessedLetters: [Character]
    
    var totalGuessesAllowed: Int
    var playerWon: Bool
    
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
    
    mutating func playerGuess(letter: Character) {
        guessedLetters.append(letter)
        
        if !word.contains(letter) {
            totalGuessesAllowed -= 1
        }
    }
}
