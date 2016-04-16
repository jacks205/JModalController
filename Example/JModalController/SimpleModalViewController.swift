//
//  SimpleViewController.swift
//  JModalController
//
//  Created by Mark Jackson on 4/15/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import JModalController

class SimpleModalViewController: UIViewController {
    
    var delegate : JModalDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func dismiss(sender: AnyObject) {
        self.delegate!.dismissModal(self, data: nil)
    }
}
