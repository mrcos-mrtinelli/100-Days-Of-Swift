import UIKit

// Optionals represent data that may or may not be there.

// handling missing data
var age: Int? = nil // with an optional, this var holds no value at all
// nil = empty memory
age = 35 // then you can change it

// unwrapping optionals
var name: String? = nil
// if you try to read name.count, you will get an error
// this is where unwrapping comes in
if let unwrapped = name {
    print("\(unwrapped.count) number of letters.")
} else {
    print("Misisng name.")
}
// unwrapping with guard
// if it finds nil, it expects you to exit the function
// unlike if let, guard let unwrapped variable are available
// through out the function
func greet(_ name: String?) {
    // deal with the optional before anything needs to happen
    guard let unwrapped = name else {
        print("You didn't provide a name!")
        return
    }
    print("Hello \(unwrapped)!")
}

// force unwrapping
let str = "5"
// we know that the above can be converted into an int
// use ! to force unwrap
// however, if you don't know what str is, you'll need to use
// either if let or gurad let
let num = Int(str)!

// implicitly unwrapped optionals
// optionals that do not need to be unwrapped to use
let number: Int! = nil
// number is available to use without if let or guard let
// ** these exit because sometimes you need to initialize
// the variable before you can add a value to it.
// this saves you from writing if-lets and guard-lets

// nil coalescing
// produces a non-optional value by providing a default
// i.e., if the optional returns an nil, you get the default value instead
func username(for id: String) -> String? {
    if id == "1" {
        return "apple"
    } else {
        return nil
    }
}
let newUser = username(for: "9838447") ?? "Anonymous" // ?? nil coalescing

// optional chaining
// if any in the chain reutrn nil, the chain is borken and returns a nil
let names = ["Jim Morrison", "Ray Manzarek", "Robby Krieger", "John Densmore"]
// ? is optional chaining, if first returns nil, swift will not uppercase is and
// theDoors will be set to nil.
let theDoors = names.first?.uppercased()

// optional try
enum PasswordError: Error {
    case obvious
}
func checkPass(_ password: String) throws -> Bool {
    if password == "password" {
        throw PasswordError.obvious
    }
    return true
}
// instead of using do-try block
if let result = try? checkPass("password") {
    print("Result was \(result)")
} else {
    print("Get bent!")
}
// you can use try! when you know that your code will not throw an error
// if it does, however, your code will crash
try! checkPass("dsw3456yhi8765try")
print("Welcome!")

// failable initializer
struct Person {
    var id: String
    
    init?(id: String) {
        if id.count == 9 {
            self.id = id
        } else {
            return nil
        }
    }
}


// typecasting - as?
// used when you don't know the type that will be returned
class Animal { }
class Fish: Animal { }
class Dog: Animal {
    func makeNoise() {
        print("WOOF!!")
    }
}
let pets = [Fish(), Dog(), Fish(), Dog()] // when iterating through, only Dog has makeNoise

for pet in pets {
    if let dog = pet as? Dog {
        dog.makeNoise()
    }
}

