import UIKit

// PROPERTIES
// values variable and constants that belog to a class/struct (collectively "types")
struct Person {
    var clothes: String
    var shoes: String
    
    func describe() {
        print("clothes = \(clothes) and shoes = \(shoes)")
    }
}

// property observers
// code that runs when you are about to, or have changed a property
struct Person2 {
    var clothes: String {
        willSet {
            print("current clothes = \(clothes) new value = \(newValue)")
        }
        didSet {
            print("oldValue = \(oldValue) and new value = \(clothes)")
        }
    }
}
var john = Person2(clothes: "jeans")
john.clothes = "slacks"

// computed property
struct Person3 {
    var age: Int
    
    var ageInDogYears: Int {
        // if only reading data, you can remove get {}
        // and go straight into the return statement
        get {
            return age * 7
        }
    }
}

// STATIC PROPERTIES - shared properties that belog to a type,
// rather than an instance of a type
struct Student {
    static var classSize = 0
    
    var name: String
    
    init(name: String) {
        self.name = name
        
        Student.classSize += 1 // notice that it belongs to the struct STudent
    }
}
var ed = Student(name: "Ed")
ed.name
Student.classSize

// access control
class PrivatePerson {
    private var ssn: Int
    var name: String
    
    init(ssn: Int, name: String) {
        self.ssn = ssn
        self.name = name
    }
}

// polymorphism and typecasting
class Album {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func getAlbumType() -> String {
        return "\(name) is an Album"
    }
}
class StudioAlbum: Album {
    var studio: String
    
    init(name: String, studio: String) {
        self.studio = studio
        super.init(name: name)
    }
    override func getAlbumType() -> String {
        return "\(name) is a Studio Album"
    }
}
class LiveAlbum: Album {
    var location: String
    
    init(name: String, location: String) {
        self.location = location
        super.init(name: name)
    }
    override func getAlbumType() -> String {
        return "\(name) is Live Album"
    }
}
var studioAlbum = StudioAlbum(name: "Nevermind", studio: "Sony")
var liveAlbum = LiveAlbum(name: "From the Muddy Bank of Wishkah", location: "Washington")
// the follwing is allowed because they each inherit from Album
var allAlbums: [Album] = [studioAlbum, liveAlbum]
for album in allAlbums {
    print(album.getAlbumType())
}

// typecasting (as? or as!)
// making sure that swift runs the right property for each album subclass
for album in allAlbums {
    if let studio = album as? StudioAlbum {
        print(studio.studio)
    } else if let live = album as? LiveAlbum {
        print(live.location)
    }
}

// CLOSURES
// self-contained blocks of functionality that can be passed
let names = ["JIM","JOHN","RAY", "ROBBIE"]
let lowerCased = names.map { $0.lowercased() }
