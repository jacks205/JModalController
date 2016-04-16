//
//  ModalViewController.swift
//  JModalController
//
//  Created by Mark Jackson on 4/14/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import JModalController

class NavigationModalViewController: UIViewController {
    
    var modalDelegate : JModalDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancel(sender: AnyObject) {
        modalDelegate!.dismissModal(self, data: nil)
    }

}
