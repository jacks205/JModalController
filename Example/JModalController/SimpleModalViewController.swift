//
//  SimpleViewController.swift
//  JModalController
//
//  Created by Mark Jackson on 4/15/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import JModalController

class SimpleModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate : JModalDelegate?
    
    let choices = ["Red", "Blue", "Green", "Yellow"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = choices[indexPath.row]
        return cell
    }

    @IBAction func dismiss(sender: AnyObject) {
        self.delegate!.dismissModal(self, data: nil)
    }
}
