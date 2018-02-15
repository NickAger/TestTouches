//
//  SmoothedBezierInterpolationView4.swift
//  TestTouches
//
//  Similar to `SmoothedBezierInterpolationView3` but create a
//  custom `ScribbleShapeLayer` to improve the quality of the
//  bezier curve rendering.
//
//  Created by Nick Ager on 15/02/2018.
//  Copyright © 2018 RocketBox Ltd. All rights reserved.
//

import UIKit

class SmoothedBezierInterpolationView4: UIView {
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
            shapeLayer.frame = layer.frame
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
            shapeLayer.cgPath.move(to: points[0])
            shapeLayer.cgPath.addCurve(to: points[3], control1: points[1], control2: points[2])
            shapeLayer.setNeedsDisplay()
            
            points[0] = points[3]
            points[1] = points[4]
            pointCounter = 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let touch = touches.first!
        //let point = touch.location(in: self)
        drawBitmap()
        self.setNeedsDisplay()
        shapeLayer.removeAllPoints()
        pointCounter = 0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
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

// rather than deriving a new CALayer, I could have used
// a CALayer class directly and set its delegate method then
// implemented `draw(in ctx: CGContext)` in the delegate
class ScribbleShapeLayer : CALayer {
    var cgPath = CGMutablePath()
    
    func removeAllPoints() {
        cgPath = CGMutablePath()
    }
    
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        ctx.setLineWidth(2)
        ctx.setStrokeColor(UIColor.black.cgColor)

        ctx.addPath(cgPath)
        ctx.strokePath()
        ctx.restoreGState()
    }
}
