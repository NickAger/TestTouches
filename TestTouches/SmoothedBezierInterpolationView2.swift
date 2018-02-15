//
//  SmoothedBezierInterpolationView2.swift
//  TestTouches
//
//  Creates an image withint the draw method when createNewIncrementalImage is defined
//  for some reason this creates an upside down image so invert the context before
//  drawing
//  Created by Nick Ager on 15/02/2018.
//  Copyright © 2018 RocketBox Ltd. All rights reserved.
//

import UIKit

class SmoothedBezierInterpolationView2: UIView {
    var cgPath = CGMutablePath()
    var cgIncrementalImage: CGImage?
    var bitmapInfo: CGBitmapInfo?
    var bitsPerComponent = 8
    var points = [CGPoint](repeating: CGPoint.zero, count:5)
    var pointCounter:Int = 0
    var createNewIncrementalImage = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    func commonInit() {
        isMultipleTouchEnabled = false
        backgroundColor = UIColor.white
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(2)
        context.setStrokeColor(UIColor.black.cgColor)
        
        if bitmapInfo == nil {
            bitsPerComponent = context.bitsPerComponent
            bitmapInfo = context.bitmapInfo
        }
        if let cgImage = cgIncrementalImage {
            context.saveGState()
            context.translateBy(x: 0, y: bounds.size.height)
            context.scaleBy(x: 1, y: -1)
            context.draw(cgImage, in: self.bounds)
            context.restoreGState()
        }
        context.addPath(cgPath)
        context.strokePath()
        
        if createNewIncrementalImage {
            createNewIncrementalImage = false

            cgIncrementalImage = context.makeImage()

            cgPath = CGMutablePath()
            pointCounter = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pointCounter = 0
        
        let touch = touches.first!
        let point = touch.location(in: self)
        
        points[0] = point
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let point = touch.location(in: self)
        pointCounter += 1
        points[pointCounter] = point
        if pointCounter == 4 {
            points[3] = CGPoint(x: (points[2].x + points[4].x) / 2.0, y: (points[2].y + points[4].y) / 2.0)
            cgPath.move(to: points[0])
            
            cgPath.addCurve(to: points[3], control1: points[1], control2: points[2])
            self.setNeedsDisplay()
            points[0] = points[3]
            points[1] = points[4]
            pointCounter = 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        createNewIncrementalImage = true
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}
