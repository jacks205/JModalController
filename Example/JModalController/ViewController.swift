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

    @IBOutlet weak var returnedValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    @IBAction func showSimpleModal(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let simpleVC = storyboard.instantiateViewController(withIdentifier: "SimpleModalViewController") as? SimpleModalViewController
        simpleVC?.delegate = self
        let config = JModalConfig(transitionDirection: .bottom, animationDuration: 0.2, backgroundTransform: true, tapOverlayDismiss: true)
        presentModal(tabBarController!, modalViewController: simpleVC!, config: config) {
            print("Presented Simple Modal")
        }
    }
    
    @IBAction func pushedBackBackground(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pushedBackVC = storyboard.instantiateViewController(withIdentifier: "PushedBackgroundViewController") as? PushedBackgroundViewController
        pushedBackVC?.delegate = self
        let config = JModalConfig(transitionDirection: .left, animationDuration: 0.3, backgroundTransformPercentage: 0.93, backgroundTransform: true)
        presentModal(tabBarController!, modalViewController: pushedBackVC!, config: config) {
            print("Presented Pushed Back Modal")
        }
    }
    
    
    @IBAction func showReturnValueModal(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let returnVC = storyboard.instantiateViewController(withIdentifier: "ReturnModalValueViewController") as? ReturnModalValueViewController
        returnVC?.delegate = self
        let config = JModalConfig(transitionDirection: .top, animationDuration: 0.15, backgroundTransform: false, tapOverlayDismiss: false)
        presentModal(tabBarController!, modalViewController: returnVC!, config: config) {
            print("Presented Return Modal")
        }
    }
    
    
    @IBAction func showNavigationModal(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "NavigationModal", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        let modalController = navigationController!.viewControllers.first as? NavigationModalViewController
        modalController!.modalDelegate = self
        navigationController!.view.frame = modalController!.view.frame
        let config = JModalConfig()
        config.swipeDirections = [.down]
        config.animationOptions = UIViewAnimationOptions()
        presentModal(tabBarController!, modalViewController: navigationController!, config: config, completion: {
            print("Presented Navigation Modal")
        })
    }
    
    override func dismissModal(_ sender: Any, data: Any?) {
        super.dismissModal(sender, data: data)
        if sender is ReturnModalValueViewController, let value = data as? String {
            returnedValueLabel.text = value
        }
    }

}

