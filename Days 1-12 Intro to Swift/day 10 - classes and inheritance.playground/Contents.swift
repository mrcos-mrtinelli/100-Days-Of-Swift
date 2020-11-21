import UIKit

// classes:
// unlike structs, you MUST always create initializers
class Dog {
    var name: String
    var breed: String
    
    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
}
let felix = Dog(name: "Felix", breed: "ACD")

// INHERITANCE
class ACD: Dog { //Dog = parent/super class
    init(name: String) {
        //call the super class init
        super.init(name: name, breed: "ACD")
    }
}

// overriding methods
class noisyDog {
    func makeNoise() {
        print("Woof!")
    }
}
class yippyBreed: noisyDog {
    override func makeNoise() {
        print("Yipp!")
    }
}
let barkingDog = noisyDog()
barkingDog.makeNoise()
let chihuahua = yippyBreed()
chihuahua.makeNoise()

// final classes - classes that
// cannot be built upon or changed
final class Cat {
    // meow
}

// copying objects
// copy of classes will point
// to the same instance
// unlike structs, where there
// will be two exact instances

class Singer {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
var singer = Singer(name: "Adele")
var singerCopy = singer
singerCopy.name = "Andrea"
print(singer.name) // prints Andrea

// deinitializers - destroys an instance
class Person {
    var name = "Frankenstein"
    
    init() {
        print("\(name) is aaaaliive!")
    }
    func printGreeting() {
        print("Rrraaaarrr!")
    }
    deinit {
        print("\(name) is no more :(")
    }
}
for _ in 1...3 {
    let person = Person()
    person.printGreeting()
}

// mutability - classes don't need a mutating func
// to update the property

class Band {
    var name = "Rolling Stones" // make this a let and you won't be able to change it
    // let name = "Constant Stones" -> cannot be changed
}
let band = Band()

band.name = "The Doors"
print(band.name)



