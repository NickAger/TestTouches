//
//  BezierInterpolationView.swift
//  TestTouches
//
//  Created by Nick Ager on 13/02/2018.
//  Copyright © 2018 RocketBox Ltd. All rights reserved.
//

import UIKit

class BezierInterpolationView: UIView {
    let path = UIBezierPath()
    var incrementalImage: UIImage?
    var points = [CGPoint](repeating: CGPoint.zero, count:4)
    var pointCounter:Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isMultipleTouchEnabled = false
        backgroundColor = UIColor.white
        path.lineWidth = 2
    }
    
    override func draw(_ rect: CGRect) {
        incrementalImage?.draw(in: rect)
        path.stroke()
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
        if pointCounter == 3 {
            path.move(to: points[0])
            path.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
            self.setNeedsDisplay()
            points[0] = point
            pointCounter = 0
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let point = touch.location(in: self)
        
        drawBitmap()
        self.setNeedsDisplay()
        points[0] = point
        path.removeAllPoints()
        pointCounter = 0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    func drawBitmap() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        UIColor.black.setStroke()
        if incrementalImage == nil {
            let rectPath = UIBezierPath(rect: self.bounds)
            UIColor.white.setFill()
            rectPath.fill()
        }
        incrementalImage?.draw(at: CGPoint.zero)
        path.stroke()
        incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
