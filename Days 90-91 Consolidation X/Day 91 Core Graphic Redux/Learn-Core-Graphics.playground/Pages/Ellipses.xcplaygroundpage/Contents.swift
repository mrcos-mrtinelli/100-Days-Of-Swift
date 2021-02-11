//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
//: # Four circles
//: Now that you've mastered rectangles, ellipses ought to be easy. Like rectangles, ellipses are drawn by activating a color then specifying a rectangle. If the rectangle has the same width and height you'll get a circle, otherwise you'll get an ellipse.
//:
//: - Experiment: The code below draws one red circle in the top-left corner, but your designer wants you to create three more: a yellow circle in the top-right corner, a blue circle in the bottom-left corner, and a green circle in the bottom-right corner.
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    let colors: [UIColor] = [
        UIColor.red,
        UIColor.yellow,
        UIColor.blue,
        UIColor.green
    ]
    let x = [0, 500, 0, 500]
    let y = [0, 0, 500, 500]
    
    for (i, color) in colors.enumerated() {
        color.setFill()
        
        let circle = CGRect(x: x[i], y: y[i], width: 500, height: 500)

        ctx.cgContext.fillEllipse(in: circle)
    }
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
