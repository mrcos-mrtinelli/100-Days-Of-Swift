import UIKit

// using closure as parameters when they accept parameters
func travel2(action: (String) -> Void) {
    print("first line")
    action("Fiji")
    print("end")
}
travel2 { (place: String) in
    print("from the trailing closure \(place)")
}

// using closure as parameters when they return values
func travel3(action: (String) -> String) {
    print("travel3()")
    let desc = action("What in the world?")
    print(desc)
    print("end")
}
travel3 { (place: String) -> String in
    return "this is a returned value of a closure -> \(place)"
}

// Short hand parameter names
travel3 { "shorthand works bc swift already knows this can only accept a String and returns a String. This is the shorthand label \($0)" }

// Closures with multiple parameters
func travel4(action: (String, Int) -> String) {
    print("Travel 4 - multiple parameters: String, Int")
    let desc = action("Parameter 1 and", 2)
    print("desc in travel4 = \(desc)")
    print("end")
}
travel4 { "String param: \($0) and Int param: \($1)"}

// returning closures from functions
func travelReturnsClosure() -> (String) -> Void {
    return {
        print("I'm going to \($0)")
    }
}
let returnedClosure = travelReturnsClosure()
returnedClosure("California")

// call func AND the closure
let callClosureWithinFun: Void = travelReturnsClosure()("Hawaii") // added Void type to silence the warning.
