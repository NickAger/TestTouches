//
//  LinearInterpView.swift
//  TestTouches
//
//  Created by Nick Ager on 13/02/2018.
//  Copyright © 2018 RocketBox Ltd. All rights reserved.
//

import UIKit

class LinearInterpView: UIView {
    let path = UIBezierPath()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isMultipleTouchEnabled = false
        backgroundColor = UIColor.white
        path.lineWidth = 2
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
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
        touchesMoved(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}
