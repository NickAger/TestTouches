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
            viewController.view = SmoothedBezierInterpolationView0(frame: viewController.view.frame)
        case "View1":
            viewController.view = SmoothedBezierInterpolationView1(frame: viewController.view.frame)
        case "View2":
            viewController.view = SmoothedBezierInterpolationView2(frame: viewController.view.frame)
        case "View3":
            viewController.view = SmoothedBezierInterpolationView3(frame: viewController.view.frame)
        case "View4":
            viewController.view = SmoothedBezierInterpolationView4(frame: viewController.view.frame)
        case "View5":
            viewController.view = SmoothedBezierInterpolationView5(frame: viewController.view.frame)
        default:
            break
        }
    }
}
