//
//  CachedLinearInterpolationView.swift
//  TestTouches
//
//  Created by Nick Ager on 13/02/2018.
//  Copyright © 2018 RocketBox Ltd. All rights reserved.
//

import UIKit

class CachedLinearInterpolationView: UIView {
    let path = UIBezierPath()
    var incrementalImage: UIImage?
    
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
        let touch = touches.first!
        let point = touch.location(in: self)
        path.move(to: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let point = touch.location(in: self)
        
        path.addLine(to: point)
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let point = touch.location(in: self)
        
        path.addLine(to: point)
        drawBitmap()
        self.setNeedsDisplay()
        path.removeAllPoints()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }

    func drawBitmap() {
//       let alternative = UIGraphicsImageRenderer(size: self.bounds.size)
//        alternative.image { (<#UIGraphicsImageRendererContext#>) in
//            <#code#>
//        }
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
