//
//  SmoothedBezierInterpolationView1.swift
//  TestTouches
//
//  Attempts to create a bitmap which matches the one created in SmoothedBezierInterpolationView2
//  Created by Nick Ager on 15/02/2018.
//  Copyright © 2018 RocketBox Ltd. All rights reserved.
//

import UIKit

class SmoothedBezierInterpolationView1: UIView {
    var cgPath = CGMutablePath()
    var cgIncrementalImage: CGImage?
    var bitmapInfo: CGBitmapInfo?
    var bitsPerComponent = 8
    var points = [CGPoint](repeating: CGPoint.zero, count:5)
    var pointCounter:Int = 0
    
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
            context.draw(cgImage, in: self.bounds)
        }
        context.addPath(cgPath)
        context.strokePath()
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
        //let touch = touches.first!
        //let point = touch.location(in: self)
        drawBitmap2()
        
        setNeedsDisplay()
        cgPath = CGMutablePath()
        pointCounter = 0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    func drawBitmap2() {
        let context = bitmapContext
        
        if let cgImage = cgIncrementalImage {
            context.draw(cgImage, in: self.bounds)
        } else {
            context.setFillColor(UIColor.white.cgColor)
            context.fill(self.bounds)
        }
        
        context.addPath(cgPath)
        context.strokePath()
        
        cgIncrementalImage = context.makeImage()
    }
    
    lazy var bitmapContext: CGContext = {
        let scale = self.window!.screen.scale
        var size = self.bounds.size
        
        size.width *= scale
        size.height *= scale
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo:  bitmapInfo!.rawValue)!
        
        
        let transform = CGAffineTransform.init(scaleX:scale, y: scale)
        context.concatenate(transform)
        
        context.setLineWidth(2)
        context.setStrokeColor(UIColor.black.cgColor)
        
        return context
    }()
    
    func show(bitmapInfo: CGBitmapInfo) {
        print("alphaInfoMask = \(bitmapInfo.contains(.alphaInfoMask))")
        print("floatComponents = \(bitmapInfo.contains(.floatComponents))")
        print("byteOrderMask = \(bitmapInfo.contains(.byteOrderMask))")
        print("byteOrder16Little = \(bitmapInfo.contains(.byteOrder16Little))")
        print("byteOrder16Big = \(bitmapInfo.contains(.byteOrder16Big))")
        print("floatInfoMask = \(bitmapInfo.contains(.floatInfoMask))\n")
    }
}


