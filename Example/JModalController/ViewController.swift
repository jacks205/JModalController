//
//  ViewController.swift
//  JModalController
//
//  Created by Mark Jackson on 04/13/2016.
//  Copyright (c) 2016 Mark Jackson. All rights reserved.
//

import UIKit
import JModalController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    @IBAction func showNavigationModal(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "NavigationModal", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        let modalController = navigationController!.viewControllers.first as? ModalViewController
        modalController!.modalDelegate = self
        navigationController!.view.frame = modalController!.view.frame
        let config = JModalConfig()
        config.animationOptions = .CurveEaseInOut
        presentModal(navigationController!, config: config, completion: {
            print("Presented Modal")
        })
    }
    
    override func dismissModal(data: AnyObject?) {
        super.dismissModal()
        print(data)
    }

}

