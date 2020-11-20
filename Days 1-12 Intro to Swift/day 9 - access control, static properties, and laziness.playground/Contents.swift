import UIKit

// initializer - default initializer is called a Memeberwise Initializer
// default:
struct User {
    var username: String
}
var myUser = User(username: "swiftpupil")

// custom initializer
struct User2 {
    var username: String
    
    init() {
        username = "anonymous"
        print("Creating a new user!")
    }
}
// since the init() above does not take a parameter
var myUser2 = User2()
myUser2.username = "swiftpupil"

// lazy properties - listed properties
// if initializer has a parameter with the same name as the property
// use the self keyword
struct Person {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
var person = Person(name: "swiftpupil")

// lazy properties - properties that are created ONLY when they are needed
struct FamilyTree {
    init() {
        print("Family Tree created!")
    }
}
struct Person2 {
    var name: String
    lazy var familyTree = FamilyTree()
    
    init(name: String) {
        self.name = name
    }
}
var jane = Person2(name: "Jane")
// no family tree yet
// access the lazy property to create it
jane.familyTree

// static properties - properties that belong to the Class Struct and not the instance
struct Student {
    static var classSize = 0
    var name: String
    
    init(name: String) {
        self.name = name
        // add one to the class size everytime a student is created
        Student.classSize += 1
    }
}

var jonny = Student(name: "Jonny")
print("Student in the class: \(Student.classSize)")
var janice = Student(name: "Janice")
print("Student in the class: \(Student.classSize)")

// access control - restrict which code can use properties and methods
struct PrivatePerson {
    private var id: String
    
    init(id: String) {
        self.id = id
    }
    
    func identify() -> String {
        return id
    }
}
var jimbo = PrivatePerson(id: "65432")
// jimbo.id will not work
print(jimbo.identify())

