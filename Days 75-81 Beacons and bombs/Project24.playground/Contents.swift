import UIKit

/* String are not Arrays */

let name = "Taylor"

// loop through each letter
for letter in name {
    print("Give me a \(letter)!")
}

// the above works, but you cannot read individual letters
// strings are not arrays
//let lLetter = name[3] // error: subscript is not available
// solution
let lLetter = name[name.index(name.startIndex, offsetBy: 3)]
// -> "l"
// subscript solution - not good bc it's a loop within a loop
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let lLetter2 = name[3] // we have a subscript aobve

/* Working with strings in swift */
// 1
let password = "123456"
password.hasPrefix("123")
password.hasSuffix("456")

extension String {
    //1
    func dropPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    func removeSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    // 2
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
        // firstLetter is a character and the .uppecased method
        // is a character method that returns a string.
        // some languages have a different character for upper and lower cases
        // german b -> SS
        
    }
}

// 3 - elegant swift
let input = "Swift is like Objective-C but without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}
input.containsAny(of: languages)
// ELEGANTLY
languages.contains(where: input.contains)

/* Atrributed String */
let string = "This is a string about to be attributed"
let string2 = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.blue,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)
let attributedMutableString = NSMutableAttributedString(string: string)
attributedMutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedMutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedMutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedMutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedMutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

