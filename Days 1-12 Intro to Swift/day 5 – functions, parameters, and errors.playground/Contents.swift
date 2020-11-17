import UIKit

// Functions
// Writing Functions

func printHelp() {
    let message = """
Welcome to MyApp!

Run this app inside a directory of images and
MyApp will resize them all into thumbnails
"""
    print(message)
}
// call the function

printHelp()

// Accepting Parameters
func square(number: Int) {
    let result = number * number
    print(result)
}
square(number: 8)

// Returning values
func square2(number: Int) -> Int {
    return number * number
}
let result = square2(number: 9)
print(result)

// Parameter Labels
//(external internal)
func sayHello(to name: String) {
    print("Hello \(name)")
}
sayHello(to: "Megan")

// underscore
func greet(_ person: String) {
    print("Hello, \(person)")
}
greet("Lindsey")

// Default Parameter
func whatGreet(_ person: String, nicely: Bool = true) { //default value
    if nicely {
        print("Hello, \(person)")
    } else {
        print("Oh, it's \(person) again...")
    }
}
whatGreet("Taylor")
whatGreet("Taylor", nicely: false)

// Variadic functions - swift converts the multiple parameters
// into an array
func squares(numbers: Int...) {
    for num in numbers {
        print("The square of \(num) is \(num * num)")
    }
}
squares(numbers: 1,2,3,4,5)

// Throwing errors
// use enums to declare the errors

enum PasswordError: Error {
    case obvious
}
func checkPass(_ password: String) throws -> Bool {
    if password == "password" {
        throw PasswordError.obvious
    }
    return true
}
do {
    try checkPass("password")
    print("That password is good!")
} catch {
    print("Sorry, can't use that password")
}
do {
    try checkPass("364e5ythg")
    print("good")
} catch {
    print("bad")
}

// inout parameters - parameters passed into a fucntion
// are, by default, constancts
// if you want to change them, you need the inout keyword
func doubleInPlace(number: inout Int) {
    number *= 2
}
var myNum = 10
print("myNum = \(myNum)")
// need to use & in front of inout parameter
// this is an explicit acknowledgement that the parameter is inout
doubleInPlace(number: &myNum)
print("myNum = \(myNum)")

