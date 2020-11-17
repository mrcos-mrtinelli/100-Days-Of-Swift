import UIKit

// Closures part 1
// functions into variables / closure
let driving = {
    print("I'm driving in my car")
}
driving()

// accepting parameters

let goingTo = { (place: String) in
    print("I'm going to \(place)")
}
// difference b/w functions and closures is that you don't use labels for parameters
goingTo("the beach.")

// closures returning values
let driving3 = { (place: String) -> String in
    return "another \(place) example of returning rather than printing"
}
let message = driving3("CLOSURE!")
print(message)

// passing closures as parameters
func travel(action: () -> Void) {
    action()
}

travel(action: driving) //-> "I'm driving in my car"

// Trailing Closure Syntax
travel() {
    print("this is the ation")
}
// or, you can remove the ()
travel {
    print("this is the ation")
}
