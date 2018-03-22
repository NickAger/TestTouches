//
//  TableViewController.swift
//  TestTouches
//
//  Created by Nick Ager on 15/02/2018.
//  Copyright © 2018 RocketBox Ltd. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! ViewController
        switch segue.identifier! {
        case "View0":
            viewController.drawingView = SmoothedBezierInterpolationView0()
        case "View1":
            viewController.drawingView = SmoothedBezierInterpolationView1()
        case "View2":
            viewController.drawingView = SmoothedBezierInterpolationView2()
        case "View3":
            viewController.drawingView = SmoothedBezierInterpolationView3()
        case "View4":
            viewController.drawingView = SmoothedBezierInterpolationView4()
        case "View5":
            viewController.drawingView = SmoothedBezierInterpolationView5()
        default:
            break
        }
    }
}
