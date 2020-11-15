import UIKit

import UIKit

// For loops

let count = 1...10 // ... = range operator -> count 1 to 10 inclusive

for number in count {
    print("Number \(number)")
}

//arrays
let albums = ["Bleach", "Nevermind", "In Utero"]

for album in albums {
    print("\(album) is on Apple Music")
}

//use _ instead of a constant to avoid needless values

for _ in 1...5 {
    print("just looping")
}

//while loop

var number1 = 1
while number1 <= 5 {
    print(number1)
    number1 += 1 // remember to modify the counter var to avoid infinite loops
}
print("Done counting")

// repeated loops - always executes at least once
var number2 = 1
repeat {
    print(number2)
    number2 += 1
} while number2 <= 5
print("done with repeat")

// exiting loops
var countDown = 10

while countDown >= 0 {
    print(countDown)
    
    if countDown == 4 {
        print("Break")
        break
    }
    countDown -= 1
}
// exiting multiple loops, aka nested loop
// nested loops
outerLoopz: for i in 1...10 { // outerLoopz is a LABEL, can be anything.
    for j in 1...10 {
        let product = i * j
        print("\(i) * \(j) = \(product)")
        
        if (product == 50) {
            print("break outerloop")
            break outerLoopz // this statement ensures you exit the outer loop, not just the inner
        }
    }
}
// skipping items - continue keyword
for i in 1...10 {
    if i % 2 == 1 {
        continue // this value is unwanted, we continue on with the loop
    }
    print("\(i)")
    
}
// infinite loops - make sure you have a condition on which to end the loop!
var counter = 0

while true {
    print(" ")
    if counter == 3 {
        break
    }
    counter += 1
}

