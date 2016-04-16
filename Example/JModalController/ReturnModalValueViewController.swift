//
//  ReturnValueViewController.swift
//  JModalController
//
//  Created by Mark Jackson on 4/15/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import JModalController

class ReturnModalValueViewController: UIViewController, UITextFieldDelegate {

    var delegate : JModalDelegate?
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        doneClick(self)
        return true
    }
    
    @IBAction func doneClick(sender: AnyObject) {
        delegate?.dismissModal(self, data: textField.text)
    }

}
