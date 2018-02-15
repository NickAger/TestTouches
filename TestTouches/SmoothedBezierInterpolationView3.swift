//
//  SmoothedBezierInterpolationView3.swift
//  TestTouches
//
//  Based on shape layer
//  Seems that the shape layer takes some shortcuts - http://ioscake.com/how-to-draw-a-smooth-circle-with-cashapelayer-and-uibezierpath.html
//  Created by Nick Ager on 15/02/2018.
//  Copyright © 2018 RocketBox Ltd. All rights reserved.
//

import UIKit

class SmoothedBezierInterpolationView3: UIView {
    let path = UIBezierPath()
    var points = [CGPoint](repeating: CGPoint.zero, count:5)
    var pointCounter:Int = 0
    
    var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }
    
    override class var layerClass: AnyClass { return CAShapeLayer.self }
    
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
        path.lineWidth = 2
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2
//        shapeLayer.miterLimit = 2
//        shapeLayer.lineCap = kCALineCapButt
//        shapeLayer.lineJoin = kCALineJoinMiter
        backgroundColor = UIColor.white
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
            path.move(to: points[0])
            
            path.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
            shapeLayer.path = path.cgPath
            points[0] = points[3]
            points[1] = points[4]
            pointCounter = 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let touch = touches.first!
        //let point = touch.location(in: self)
        let image = drawBitmap()
        layer.contents = image.cgImage
        path.removeAllPoints()
        pointCounter = 0
        shapeLayer.path = path.cgPath
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    func drawBitmap() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        UIColor.black.setStroke()
        
        if layer.contents == nil {
            let rectPath = UIBezierPath(rect: self.bounds)
            UIColor.white.setFill()
            rectPath.fill()
            print("oldImage not defined")
        } else {
            let cgImage = layer.contents as! CGImage
            let context = UIGraphicsGetCurrentContext()!
            context.saveGState()
            context.translateBy(x: 0, y: bounds.size.height)
            context.scaleBy(x: 1, y: -1)
            context.draw(cgImage, in: self.bounds)
            context.restoreGState()
        }

        path.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
