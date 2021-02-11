//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
//: # The Poppyseed Bread Company
//: You have a new client! A local artisanal bakery always adds a finishing touch to its loaves by sprinkling poppy seeds on top, and they want you to make them a great poppy logo. Your designer has already sketched something, but it falls to you to figure out how to make it happen in code.
//:
//: - Experiment: Your designer has provided a sketch of what they want: four red circles, with a black circle in the middle. Can you make this happen using ellipses? They've drawn the first one for you, but it isn't quite right.
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
	// "This doesn't seem right…" – Designer
    let x = [100, 400, 100, 400]
    let y = [100, 100, 400, 400]
    
    for i in 0 ..< 4 {
        UIColor.red.setFill()
        
        let circle = CGRect(x: x[i], y: y[i], width: 500, height: 500)

        ctx.cgContext.fillEllipse(in: circle)
    }
    
    UIColor.black.setFill()
    
    let center = CGRect(x: 400, y: 400, width: 200, height: 200)
    
    ctx.cgContext.fillEllipse(in: center)
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
