import UIKit

// Arrays - collections of stored in a sigle variable or constant
let kurt: String = "Kurt Cobain"
let chris: String = "Christ Novoselic"
let dave: String = "Dave Grohl"

let nirvana = [kurt, chris, dave]

// arrays are the most commonly used and are flexible
// you can store multiple types, in any order, and store duplicates

// Sets - used only of unique values - good for fast searching
// - like arrays but do not store values in order
// - cannot contain duplicates
// - cannot access the by index
// - doesn't store duplicates

let colors = Set(["red","green","blue"])
//duplicates are ignores
let colors2 = Set(["red","green","blue", "red", "green"])

// are the fastest when you need to search for something
// best for lists of unique values

// Tuples - used for fixed collection of related values
// - fixed size - cannot add or remove items
// - fixed type - cannot change the type of item after created
// items are accessed by index or name of property
var name = (first: "Jim", last: "Morrison")
// access by index
name.0
// access by property
name.first
// change value - not type
name.first = "James"
print(name)

// use for specific values in specific order for example
var address = (house: "1", street: "Apple Park Way", city: "Cupertino", state: "CA", zip: "95014")

// Dictionaries - store and retrieve data by key
// - store key: value relations

let surfboardLength = [
    "Glazer": "5'4",
    "Gamma": "5'8"
]
surfboardLength["Glazer"]

// Dictionary default value - accessing a property that doesn't exit returns a nil
// you can provide a default value if nil is not an option
let favIceCream = [
    "Paul": "Chocoloate",
    "Sophie": "Vanilla"
]
favIceCream["Paul"] // -> "Chocolate"
favIceCream["Jenny"] // -> nil
favIceCream["Jenny", default: "🤷🏻‍♂️"]

// Empty collections
var teams = [String: String]() // String() initializes an dictionary array
// add values to it later
teams["Karol"] = "Girls Team"
print(teams)

// initialize an empty arry
var results = [Int]()
results.append(100)
print(results)

//sets are different
var  words = Set<String>()
var numbers = Set<Int>()

//also works for arrays and dictionaries
var scores = Dictionary<String, Int>()
var results2 = Array<Int>()

// enumerations / enums - used to define groups of related values in a way that makes
// them easier to use
let response1 = "failure"
let response2 = "failed"
let response3 = "fail"

enum Response {
    case success
    case failure
}

let response4 = Response.success

// enum associated values

enum Activity {
    case bored
    case running(destination: String)
    case talking(topic: String)
    case singing(volume: Int)
}

let running = Activity.running(destination: "Home")
print(running)

// enum raw values

enum Planet: Int {
    case mercury = 1
    case venus
    case earth
    case mars
}

let earth = Planet(rawValue: 2)


let test = [
    (question: "question1",answer: "answer1"),
    (question: "question2",answer: "answer2"),
    (question: "question3",answer: "answer3")
]

print(test[0].answer)

