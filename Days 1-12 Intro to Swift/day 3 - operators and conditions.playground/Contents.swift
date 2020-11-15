import UIKit

// Arithmetic operators
let firstScore = 12
let secondScore = 4

let total = firstScore + secondScore
let difference = firstScore - secondScore
let product = firstScore * secondScore
let divided = firstScore / secondScore
let remainder = 13 % secondScore

// operator overloading
// fancy for context in which you are using the operator
let meaningOfLife = 36
let doubleMeaningOfLife = 36 + meaningOfLife

// joining strings
let fakers = "Faker gonna "
let action = fakers + "fake"

// joining arrays
let firstHalf = ["John", "Paul"]
let secondHalf = ["George", "Ringo"]

let beatles = firstHalf + secondHalf //this is cool!

//remember that Swift is a type-safe language
// you cannot add fakers + meaningOfLife

// compound assignment operators
var score = 95
score -= 5

var quote = "We are what we repeatedly do. "
quote += "Excellence, then is not an act, but a habit"
// Will Durant


// Comparison operators
let score1 = 6
let score2 = 4

score1 == score2
score1 != score2
score1 < score2
score1 >= score2

"Taylor" <= "Swift"

// conditions
let firstCard = 11
let secondCard = 10

if firstCard + secondCard == 2 {
    print("Lucky Aces!")
} else if firstCard + secondCard == 21 {
    print("Blackjack!")
} else {
    print("No jack!")
}

// combining conditions
let age1 = 12
let age2 = 21

if age1 > 18 && age2 > 18 {
    print("Both over 18")
}

if age1 > 18 || age2 > 18 {
    print("One of them is over 18")
}

// Ternary operator

age1 > age2 ? print("Older!"): print("Younger")

// Switch Statement
let weather = "rain"

switch weather {
case "rain":
    print("Bring an umbrella")
    fallthrough // continues to the next case
case "snow":
    print("Wear some snow boots!")
default: // requried!
    print("no weather conditions")
}
// range operators
// 1..<5 == 1,2,3,4
// 1...5 == 1,2,3,4,5

let score3 = 85

switch score3 {
case 1..<50:
    print("Try again")
case 50..<85:
    print("Good job")
default:
    print("You did great")
}

