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
    
    @IBAction func showSimpleModal(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let simpleVC = storyboard.instantiateViewControllerWithIdentifier("SimpleModalViewController") as? SimpleModalViewController
        simpleVC?.delegate = self
        let config = JModalConfig(animationDuration: 0.2, tapOverlayDismiss: true, transitionDirection: .Bottom, backgroundTransform: true)
        presentModal(tabBarController!, modalViewController: simpleVC!, config: config) {
            print("Presented Simple Modal")
        }
    }
    
    @IBAction func pushedBackBackground(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pushedBackVC = storyboard.instantiateViewControllerWithIdentifier("PushedBackgroundViewController") as? PushedBackgroundViewController
        pushedBackVC?.delegate = self
        let config = JModalConfig(animationDuration: 0.3, transitionDirection: .Left, backgroundTransform: true, backgroundTransformPercentage: 0.93)
        presentModal(tabBarController!, modalViewController: pushedBackVC!, config: config) {
            print("Presented Pushed Back Modal")
        }
    }
    
    
    @IBAction func showReturnValueModal(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let returnVC = storyboard.instantiateViewControllerWithIdentifier("ReturnModalValueViewController") as? ReturnModalValueViewController
        returnVC?.delegate = self
        let config = JModalConfig(animationDuration: 0.15, tapOverlayDismiss: false, transitionDirection: .Top, backgroundTransform: false)
        presentModal(tabBarController!, modalViewController: returnVC!, config: config) {
            print("Presented Return Modal")
        }
    }
    
    
    @IBAction func showNavigationModal(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "NavigationModal", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        let modalController = navigationController!.viewControllers.first as? NavigationModalViewController
        modalController!.modalDelegate = self
        navigationController!.view.frame = modalController!.view.frame
        let config = JModalConfig()
        config.swipeDirections = [.Down]
        config.animationOptions = .CurveEaseInOut
        presentModal(tabBarController!, modalViewController: navigationController!, config: config, completion: {
            print("Presented Navigation Modal")
        })
    }
    
    override func dismissModal(sender: AnyObject, data: AnyObject?) {
        super.dismissModal(sender, data: data)
        if sender is ReturnModalValueViewController, let value = data as? String {
            returnedValueLabel.text = value
        }
    }

}

