//
//  SmoothedBezierInterpolationView5.swift
//  TestTouches
//
//  Like SmoothedBezierInterpolationView4 but uses coalesced touches
//  and ensures that any remaining points which haven't been drawn
//  are added
//
//  Created by Nick Ager on 15/02/2018.
//  Copyright © 2018 RocketBox Ltd. All rights reserved.
//

import UIKit

class SmoothedBezierInterpolationView5: UIView {
    var incrementalImage: UIImage?
    var points = [CGPoint](repeating: CGPoint.zero, count:5)
    var pointCounter:Int = 0
    var shapeLayer = ScribbleShapeLayer()
    
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
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        if layer === self.layer {
            shapeLayer.frame = layer.bounds
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pointCounter = 0
        
        let touch = touches.first!
        let coalescedTouches = event?.coalescedTouches(for: touch) ?? []
        if coalescedTouches.count > 0 {
            let firstCoalescedTouch = coalescedTouches.first!
            points[0] = firstCoalescedTouch.location(in: self)
            addTouchesToPath(Array(coalescedTouches.dropFirst()))
        } else {
            points[0] = touch.location(in: self)
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let coalescedTouches = event?.coalescedTouches(for: touch) ?? []
        addTouchesToPath(coalescedTouches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let coalescedTouches = event?.coalescedTouches(for: touch) ?? []
        addTouchesToPath(coalescedTouches)

        // add remaining points that haven't been drawn
        if shapeLayer.cgPath.isEmpty {
            var rect = CGRect(origin: points[0], size: CGSize.zero)
            rect = rect.insetBy(dx: -1, dy: -1)
            shapeLayer.cgPath.addEllipse(in: rect)
            shapeLayer.cgPath.move(to: points[0])
        }
        for counter in 0...pointCounter {
            shapeLayer.cgPath.addLine(to: points[counter])
        }
        drawBitmap()

        shapeLayer.removeAllPoints()
        pointCounter = 0
        
        shapeLayer.setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    func addTouchesToPath(_ touches: [UITouch]) {
        for touch in touches {
            let point = touch.location(in: self)
            pointCounter += 1
            points[pointCounter] = point
            if pointCounter == 4 {
                points[3] = CGPoint(x: (points[2].x + points[4].x) / 2.0, y: (points[2].y + points[4].y) / 2.0)
                shapeLayer.cgPath.move(to: points[0])
                shapeLayer.cgPath.addCurve(to: points[3], control1: points[1], control2: points[2])
                shapeLayer.setNeedsDisplay()
                
                points[0] = points[3]
                points[1] = points[4]
                pointCounter = 1
            }
        }
    }
    
    func drawBitmap() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        if incrementalImage == nil {
            let rectPath = UIBezierPath(rect: self.bounds)
            UIColor.white.setFill()
            rectPath.fill()
        }
        incrementalImage?.draw(at: CGPoint.zero)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(2)
        context.setStrokeColor(UIColor.black.cgColor)
        context.addPath(shapeLayer.cgPath)
        context.strokePath()
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        layer.contents = newImage?.cgImage
        incrementalImage = newImage
    }
}

