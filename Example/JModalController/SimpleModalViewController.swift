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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = choices[(indexPath as NSIndexPath).row]
        return cell
    }

    @IBAction func dismiss(_ sender: AnyObject) {
        self.delegate!.dismissModal(self, data: nil)
    }
}
