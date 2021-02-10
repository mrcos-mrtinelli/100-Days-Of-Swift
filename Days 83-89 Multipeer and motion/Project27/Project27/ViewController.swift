//
//  ViewController.swift
//  Project27
//
//  Created by Marcos Martinelli on 2/7/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        drawEmoji()
        drawSquare()
    }
    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 6 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawEmoji()
        default:
            break
        }
    }
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { (context) in
            let rect = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)
            
            context.cgContext.addRect(rect)
            context.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = image
    }
    func drawCircle(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { (context) in
            let rect = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)
            
            context.cgContext.addEllipse(in: rect)
            context.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = image
    }
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { (context) in
            context.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        context.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        imageView.image = image
    }
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { (context) in
            context.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                context.cgContext.rotate(by: CGFloat(amount))
                context.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            context.cgContext.setStrokeColor(UIColor.blue.cgColor)
            context.cgContext.strokePath()
        }
        imageView.image = image
    }
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { (context) in
            context.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                context.cgContext.rotate(by: .pi / 2)
                
                if first {
                    context.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    context.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                length *= 0.99
            }
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.strokePath()
            
        }
        imageView.image = image
    }
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

  
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]

            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)

            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)

            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }

        imageView.image = img
    }
    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { (context) in
            let rect = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            // head
            context.cgContext.setFillColor(UIColor.yellow.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)
            context.cgContext.addEllipse(in: rect)
            context.cgContext.drawPath(using: .fillStroke)
            
            // eyes
            let leftEye = CGRect(x: 165, y: 171, width: 50, height: 50)
            let rightEye = CGRect(x: 330, y: 171, width: 50, height: 50)
            
            context.cgContext.setFillColor(UIColor.black.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.addEllipse(in: leftEye)
            context.cgContext.addEllipse(in: rightEye)
            context.cgContext.drawPath(using: .fillStroke)
            
            // smile
            let arcStartAngle = Measurement(value: 45, unit: UnitAngle.degrees).converted(to: .radians).value
            let arcEndAngle = Measurement(value: 135, unit: UnitAngle.degrees).converted(to: .radians).value
            
            context.cgContext.addArc(
                center: CGPoint(x: 256, y: 220),
                radius: CGFloat(220),
                startAngle: CGFloat(arcStartAngle),
                endAngle: CGFloat(arcEndAngle),
                clockwise: false
            )
            context.cgContext.drawPath(using: .stroke)
        }
        imageView.image = image
    }
    func drawSquare() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { (context) in
            // square one
            UIColor.darkGray.setStroke()
            context.stroke(CGRect(x: 156, y: 156, width: 200, height: 200))
            UIColor.systemBlue.withAlphaComponent(CGFloat(0.5)).setFill()
            context.fill(CGRect(x: 186, y: 186, width: 140, height: 140))
            
            
            // square two
            UIColor.red.setStroke()
            context.stroke(CGRect(x: 56, y: 56, width: 400, height: 400))
            UIColor.green.withAlphaComponent(CGFloat(0.5)).setFill()
            context.fill(CGRect(x: 86, y: 86, width: 340, height: 340), blendMode: .overlay)
        }
        
        imageView.image = img
    }
}

