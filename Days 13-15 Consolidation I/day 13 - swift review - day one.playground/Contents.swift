import UIKit

// VARIABLES AND CONSTANTS
var name = "Nikki"
let constantName = "Markos"

name = "Nicole"
// constantName = "Marcos" // Not allowed!


// - constants are helpful to avoid human error.
// - constants also affect how apps are built by applying
//   optimizations to them making your code faster

// TYPES OF DATA
// name, above, is a String (by type inference)
var nombre: String // explicit type annotation
nombre = "Mandy"

var age: Int
age = 25

// explicit type provides type safety
// age = "Mandy" // produces an error
// nombre = 25 // produces an error

//OPERATORS
// basic operators
var a = 10
a = a + 1
a = a - 1
a = a * a
// compound operators
var b = 10
b += 10
b -= 10
// when using + with strings, you get one concatenated string
var name1 = "Romeo"
var name2 = "Juliet"
var classicLiteratureTitle = name1 + " and " + name2
// modulus - returns the remainder of a division
var oneRemaining = 3 % 2 // = 1
// comparison operators
3 > 2
1 < 2
5 >= 5
10 == 10
// in case of strings, the case matters
"Jim Morrison" == "JIM Morrison" // false
// the not operator !, flips the value
var thisIsTrue = true
var thisIsNotTrue = !thisIsTrue
print(thisIsNotTrue)

// STRING INTERPOLATION
// fancy for combining variable/constants in a string
var operaSinger = "Luciano Pavarotti"
"A famous opera singer is \(operaSinger)"
// string interpolation can handle various differet
// - data types
// - calculations
// - return values from functions

// ARRAYS
// inferenced arrays:
var evenNumbers = [2, 4, 6]
var songs = ["The End", "Light My Fire", "Moonlight Drive"]
// explicitly set arrays
var playlist: [String] // this only sets the playlist var to expect an array of strings
var playlist1 = [String]() // creates an empty array of strings
var playlist2: [String] = [] // create an empty array of strings
// playlist[0] = "Stariway to Heaven" // produces an error
// combining arrays
var rockSongs = ["Heartbreaker", "Rock n Roll", "Blackdog"]
var oldies = ["(Sittin' on) The Dock of The Bay", "Moondance", "So Happy Together"]
var allSongs = rockSongs + oldies
allSongs += ["Three Little Birds"]

// DICTIONARIES - key/value collection
var socialMedia = [
    "facebook": "www.facebook.com",
    "twitter": "www.twitter.com"
]
socialMedia["twitter"] // prints www.twitter.com

// CONDITIONAL STATEMENTS - code excutes only when a condition is fulfilled
var sport: String
var athlete = "Kelly Slater"

if athlete == "Kelly Slater" {
    sport = "Surfing"
} else if athlete == "Nadal" {
    sport = "Tennis"
}
// evaluating multiple conditions
// && = and
// || = or
// Short Circuit evaluation performance booster
// - Swift won't bother evaluating the right-side
//   of the && if the left-side is FALSE
var OneHundredDaysOfSwift = true
var skipOneDayOfSwift = false

if skipOneDayOfSwift && OneHundredDaysOfSwift {
    // this code will never excute
    print("you are a slacker!")
} else {
    print("You're on your way to a new career!")
}
// ! (not) operator
if !skipOneDayOfSwift && OneHundredDaysOfSwift {
    print("Way to go! Keep on coding!")
} else {
    // this code will never excute
    print("You're a SLACKER!")
}

// LOOPS
// coding construct that repeat a block of code
// as long as a condition is met
// using the range operator, you can repeat a block
for i in 1...10 {
    print("\(i) x 10 = \(i * 10)")
}
// use the _ if you don't need the current number/index
for _ in 1...5 {
    print("This will print five times")
}
// looping over arrays
var varietals = ["Cabernet", "Syrah", "Pinot", "Turiga Nacional"]
for varietal in varietals {
    print("\(varietal) is a red wine.")
}
// using index
for i in 0 ..< varietals.count {
    print("\(varietals[i]) is a red wine.")
}
// loops in loops
var people = ["players", "haters", "hear-breakers", "fakers"]
var actions = ["play", "hate", "break", "fake"]
for i in 0 ..< people.count {
    var str = "\(people[i]) gonna"
    
    for _ in 1...5 {
        str += " \(actions[i])"
    }
    print(str)
}
// loops that repeat until told to stop
var counter = 0

while true {
    print("counter is now \(counter)")
    counter += 1
    if counter == 3 {
        break
    }
}
// continue keyword
var faveSongs = ["People are Strange", "Three Little Birds", "Shake it Off", "Spank Thru"]
for song in faveSongs {
    if song == "Shake it Off" {
        continue // skip print when this song matches
    }
    print("My favorite song is \(song)")
}

// SWITCH CASE
// swift looks for the first matching case,
// executes the code and exits the switch
let weather = "sunny"

switch weather {
case "cloudy":
    print("make sure you wear a coat")
case "windy":
    print("wear a coat, but don't wear a hat, cause you'll lose it.")
case "sunny":
    print("tank tops and shorts!")
default:
    print("there is now weather information.")
} // default is an exhaustive case. If none of the cases match
//   then the default will run
// using a range
let score = 85
switch score {
case 0...50:
    print("Your grade is an F")
case 51...69:
    print("Your grade is a D")
case 70...80:
    print("Your grade is a C")
case 81...90:
    print("Your grade is a B")
case 91...100:
    print("Your grade is an A")
default:
    print("There was no matching score.")
}
