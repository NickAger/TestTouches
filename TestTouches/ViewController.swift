//
//  ViewController.swift
//  TestTouches
//
//  Created by Nick Ager on 13/02/2018.
//  Copyright © 2018 RocketBox Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var stackView: UIStackView!
    var drawingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.addArrangedSubview(drawingView)
        drawingView.layer.borderColor = UIColor.gray.cgColor
        drawingView.layer.borderWidth = 1
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

