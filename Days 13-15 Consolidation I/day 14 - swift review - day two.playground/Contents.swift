import UIKit

// FUNCTIONS - reusable code that performs specific functionality.
// basic
func helloWorld() {
    print("Hello, world!")
}
helloWorld()
// parameters - "to" = external label and "name" = internal label
func sayHello(to name: String) {
    print("Hello, \(name)!")
}
sayHello(to: "Waldo") // swifty code
// returning values
func isEven(number: Int) -> Bool {
    if number % 2 == 0 {
        return true
    } else {
        return false
    }
}
isEven(number: 2)

// OPTIONALS - there may, or may not be a value.
// no value = nil
// this is important for type-safety.
// unwrapping optioinals allows Swfit to run code if there is a value
// and either run an alternate or no code if there isn't value (nil)

// this function may return a year for the album released, or nil,
// if the album is not found
func yearAlbumReleased(name: String) -> Int? {
    if name == "The Doors" { return 1967 }
    if name == "Waiting for the Sun" { return 1968 }
    return nil
}
var yearReleased: Int
//yearReleased = yearAlbumRelease(name: "Strange Days") - throws error b/c var EXPECTS an Int
// the function can return a nil, whihc is no value
var yearReleased2 = yearAlbumReleased(name: "Strange Days")
// this works but, you will not be able to use it in code that expect non-optional.
// that's where unwrapping comes into play
if let yearReleased2 = yearAlbumReleased(name: "The Doors") {
    // can be used safely
    print(yearReleased2)
} else {
    // alternative route if nil
    print("could not find that album")
}
// for unwarp with ! for variables that WILL receive a value before using it
// this will be most useful when working with UI elements.
// OS will create UI elements at the last possible moment
// thus, the variable may need to be explicitly/implicitly unwrapped
// so long as it gets a valid value BEFORE it is used.

// explicitly
let albumYear = yearAlbumReleased(name: "Waiting for the Sun")
if albumYear == nil {
    print("there was an error")
} else {
    print("album year was \(albumYear!)") // we know there is a value
}

// implicitly
let albumYear2: Int! = yearAlbumReleased(name: "The Doors")

// OPTIONAL CHAINING
// example from Swift docs
class Person {
    var residence: Residence?
}
class Residence {
    var numberOfRooms = 1
}
var john = Person()
// in order to access the numberOfRooms property,
// you need a non-optional value
// roomCount = john.residence!.numberOfRooms -> runtime error!
if let roomCount = john.residence?.numberOfRooms { // never initialized
    print("Room count = \(roomCount)")
} else {
    print("Unable to read number of rooms.")
}
// residence is still nil in the john instance
john.residence = Residence()
// makes this not an optional anymore
if let roomCount = john.residence?.numberOfRooms {
    print("Room count = \(roomCount)")
} else {
    print("Unable to read number of rooms.")
}
// nil coalescing
// "use value A if you can, use value B if A is nil"
let album = yearAlbumReleased(name: "Strange Days") ?? 1111
print(album)

// ENUMERATIONS - define your own values
// useful to avoid typos or different expressions of a value
// weather, example. Is it rain, rainy, rains?
enum WeatherType {
    case sun, cloud, rain, wind, snow
} // no bias with these enum values

func getHaterStatus(weather: WeatherType) -> String? {
    if weather == WeatherType.sun {
        return nil
    } else {
        return "Hate!"
    }
}
let status = getHaterStatus(weather: WeatherType.sun)
// concise enum
enum WeatherType2 {
    case sun
    case cloud
    case rain
    case wind
    case snow
}
func getHaterStatus2(weather: WeatherType2) -> String? {
    // make sure this is exhaustive by either adding all enums,
    // or by having default case
    switch weather {
    case .sun:
        return nil
    case .cloud, .wind:
        return "dislike"
    case .rain:
        return "hate!"
    default:
        return "unsure"
    }
}

// STRUCTS - complex data types
struct Person2 {
    var clothes: String
    var shoes: String
    
    func describe() {
        print("I like wearing \(clothes) with \(shoes)")
    } // func inside a struct is called a method
}
// with memberwise initializer
var taylor = Person2(clothes: "T-shirt", shoes: "sneakers")
// access the properties
taylor.clothes
// copy the instance creates a new instance, unlike classes
var copyTaylor = taylor
copyTaylor.shoes = "flippies"
taylor.shoes
copyTaylor.shoes

// CLASSES - similar to struct, but different in that
// 1. they don't have memberwise initializers, you need to write your own
// 2. inheritance, you can design a class based on another class
// 3. and instance of a class is called an object, copies point to the same object

// 1. write initializer
class PersonClass {
    var clothes: String
    var shoes: String
    
    init(clothes: String, shoes: String) {
        self.clothes = clothes
        self.shoes = shoes
    }
}
// 2. inheritance
class Singer {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func sing() {
        print("do re mi fa so la ti do")
    }
}
var singer1 = Singer(name: "Taylor", age: 25)
singer1.sing()

class CountrySinger: Singer {
    // sub-class extending Singer superclass
    override func sing() {
        print("Trucks, guitars, and coors light")
    }
}
var singer2 = CountrySinger(name: "Tay", age: 25)
singer2.sing()
// calling on superclass
class HeaveMetalSinger: Singer {
    var noiseLevel: Int
    
    init(name: String, age: Int, noiseLevel: Int) {
        // set classes own property first
        self.noiseLevel = noiseLevel
        
        super.init(name: name, age: age)
    }
    
    override func sing() {
        print("RoOOOoOoooAAAaarRRrrrRrrr (at \(noiseLevel) volume)")
    }
}
