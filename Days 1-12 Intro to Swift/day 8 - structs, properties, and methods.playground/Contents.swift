import UIKit

// structures, or structs, allow you to design your own types
struct Sport {
    var name: String // struct's property
}

// initialize the struct
var waveRiding = Sport(name: "Surfing")
print(waveRiding.name)

// the struct has a variable property so we can change the name
waveRiding.name = "Big Wave Surfing"

// computed properties
struct SportWithCompProp {
    var name: String
    var isOlympicSport: Bool
    // computed property
    var olympicStatus: String {
        if isOlympicSport {
            return "\(name) is an Olympic sport!"
        } else {
            return "\(name) is not an Olympic sport!"
        }
    }
}

let surfing = SportWithCompProp(name: "Surfing", isOlympicSport: true)
print(surfing.olympicStatus)

// property observer
// runs code before or after any property changes
// didSet -> runs code when the property changes
//   - can access the old value in the constant oldValue available with didSet
// willSet -> runs code before the property changes
//   - can access the new value in the constant newValue available with didSet
// additional notes from Apple's Develop in Swift Fundamentals
struct Progress {
    var task: String
    var amount: Int {
        willSet {
            print("Changing \(task) amount to \(newValue)")
        }
        didSet {
            print("Changed \(task) amount to \(amount) from \(oldValue)")
        }
    }
}
var progress = Progress(task: "Loading Data", amount: 10)
print("Current progress \(progress.amount)")
progress.amount = 30

// functions inside structs are called methods
struct City {
    var population: Int
    
    func collectTaxes() -> Int {
        return population * 1000
    }
}
let myCity = City(population: 3000)
myCity.collectTaxes()

// structs are by default "constants" as safe approach from swift.
// so, when you want to change a property inside a method, you need
// a mutating method
struct Person {
    var name: String
    
    mutating func makeAnonymous() {
        name = "Anonymous"
    }
}
// the instance has to be a var, otherwise you will
// not be able to make changes
var person = Person(name: "Felix")
person.makeAnonymous()

// strings are structs, with methods
let str = "We are what we repeatedly do. Excellence, then, is not an act, but a habit."

print(str.count)
print(str.hasPrefix("We"))
print(str.uppercased())
print(str.sorted())

// array are also structs

var toys = ["Surfboard"]
print(toys.count)
print(toys.append("Guitar"))
print(toys.firstIndex(of: "Surfboard")!) // force unwrap to avoid warning
print(toys.sorted())
print(toys.remove(at: 1))
