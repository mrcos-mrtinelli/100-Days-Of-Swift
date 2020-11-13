import UIKit

var str = "Hello, playground"

// type-safe language
var strng = "this is a string"
var age = 36 //this is an int

// once a variable has been assigned a value, that new values must be of the same type
// i.e., you cannot make strng = 69, only another string and likewise, you cannot
// make age = "another string", because is is and Int type from the instantiation.

// Multi-line string
var multiLinesStr = """
This is line one
and this is line two
last line on a new line
"""

var multiLineStrNoBreaks = """
Hello, I am a \
Multiline string \
but without breaks
"""

// Double and Boolean
// Double position or multivalue
//

var pi = 3.141 // not an integer
var awesome = true // boolean

// String interpolation
var score = 85
var strPolation = "Your score was \(score)" //You can run code in the interpolation

// Constants - values you cannot change
let taylor = "swift" //cannot change

// Type annotation
// explicitly setting the type of a var or let
// the above has been instantiated by inference
// below is setting them explicitly

let str3: String = "This is a set string"
let year: Int = 2020
let pi2: Double = 3.141
let ImAwesome: Bool = true
