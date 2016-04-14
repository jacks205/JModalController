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
        print(modalController!.view.frame)
        navigationController!.view.frame = modalController!.view.frame
        presentModal(navigationController!, animationDuration: 0.5, transitionStyle: .Right, dismissSwipeGestureRecognizerDirection: .Down) {
            print("Presented Modal")
        }
    }
    
    override func dismissModal(data: AnyObject?, animationDuration: NSTimeInterval) {
        super.dismissModal(data, animationDuration: animationDuration)
        print(data)
    }

}

