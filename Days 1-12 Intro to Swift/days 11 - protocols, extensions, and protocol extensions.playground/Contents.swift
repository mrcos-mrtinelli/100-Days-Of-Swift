import UIKit

// protocol - describes what properties and methods something must have
// protocols are only descriptions, not something you can initialize
protocol Identifiable {
    var id: String { get set }
}

// create a struct that conforms to the Identifiable protocol
struct User: Identifiable {
    var id: String
}
// create a function that only prints objects that conform to Identifiable
func displayID(thing: Identifiable) {
    print("My id is \(thing.id)")
}

// protocol inheritance
// unlike classes, a thing can inherit multiple protocols
protocol Payable{
    func calculateWages() -> Int
}
protocol NeedsTraining{
    func study()
}
protocol HasVacation {
    func takeVacation(days: Int)
}

protocol Employee: Payable, NeedsTraining, HasVacation { } // no need to add anything on top

// extensions - add methods to existing types
// you cannot add stored properties, only computed properties
extension Int {
    func squared() -> Int {
        return self * self
    }
    var isEven: Bool {
        return self % 2 == 0
    }
}
let number = 13
print(number.squared())
print(number.isEven)

// protocol extensions - extends protocol rather than a type like extensions above
// protocol describe what methods something should have, but does not provide the code
// protocol extension provide the code for the method
let numbers = [1,2,3,4,5,6,7,8.9,0]
let colors = Set(["red", "yellow", "blue"])
// both of arrays and sets coforms to the Collections protocol,
// so we can add an extension to it as such
extension Collection {
    func summarize() {
        print("There are \(count) in the Collection")
        
        for el in self {
            print(el)
        }
    }
}
numbers.summarize()
colors.summarize()

// protocol-oriented programming - with protocols and protocol extensions,
// you can create types that conform in a certain way based on your protocol/extension
protocol Identity {
    var id: String { get set }
    func identify()
}
extension Identity {
    func identify() {
        print("My ID is \(id)")
    }
}
struct TwitterUser: Identity {
    var id: String
}
let swiftpupil = TwitterUser(id: "swiftpupil")
swiftpupil.identify()
