# JModalController

[![CI Status](http://img.shields.io/travis/jacks205/JModalController.svg?style=flat)](https://travis-ci.org/jacks205/JModalController)
[![Version](https://img.shields.io/cocoapods/v/JModalController.svg?style=flat)](http://cocoapods.org/pods/JModalController)
[![License](https://img.shields.io/cocoapods/l/JModalController.svg?style=flat)](http://cocoapods.org/pods/JModalController)
[![Platform](https://img.shields.io/cocoapods/p/JModalController.svg?style=flat)](http://cocoapods.org/pods/JModalController)

An easy and awesome way to make custom modals.

**:warning: For Swift 2.3 usage, use 0.1.* releases **:warning:

**:warning: For Swift 3.0 usage, use 0.2.* or later releases **:warning:

**:warning: This Readme uses the Swift 3.0 release, look to previous Readmes for older API **:warning:

[![JModalController](/images/jmodalcontroller.gif)](/images/jmodalcontroller.gif)

## Run Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

JModalController requires iOS 8 or greater to use.

## Installation

JModalController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JModalController'
```

## Usage

Create a ViewController like you would any other storyboard controller.


[![Create ViewController in storyboard](/images/jmc1.png)](/images/jmc1.png)


Size the controller to whatever your needs are. The width and height both can be shorter than the presenting view controller.


[![Size the modal](/images/jmc3.png)](/images/jmc3.png)


> Note: Make sure to uncheck 'Resize View From NIB' or the modal won't be your custom size. If this isn't unchecked, then you much manually set the frame before presenting the modal.

[![Uncheck Resize View From NIB](/images/jmc2.png)](/images/jmc2.png)

Using a Storyboard, you just need to load in the controller and call `presentModal()`
```swift
#import JModalController

// ...

func showModal() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let simpleVC = storyboard.instantiateViewControllerWithIdentifier("SimpleModalViewController") as? SimpleModalViewController
    
    //Set the delegate in order to dismiss the modal
    simpleVC?.delegate = self
    
    //Set configuration settings to customize how the modal presents
    let config = JModalConfig(animationDuration: 0.2, tapOverlayDismiss: true, transitionDirection: .Bottom, backgroundTransform: true)
    
    //Present the modal!
    //`self` if no navigation or tabBar controllers are present!
    presentModal(self, modalViewController: simpleVC!, config: config) {
        print("Presented Simple Modal")
    }
}
```

> Note: `presentModal` requires a `basePresentingViewController`. This controller should be the base controller you wish to perform the transform on. So if you have your controller embedded in an UINavigationController and/or UITabBarController, use `navigationController`/`tabBarController` instead of `self`

Dismissing the modal is easy, just call `delegate.dismissModal(self, nil)`

```swift
import JModalController

var delegate : JModalDelegate?

// ...

@IBAction func dismiss(sender: AnyObject) {
  //Dismiss Modal, give the data parameter anything you want to send back to the presenting view controller.  
  self.delegate!.dismissModal(self, data: nil)
}
```

### JModalConfig

JModalConfig is a class that allows customization of the modal. Attributes describe length of animation, color of background animation, and much more.

Here are the attributes that can be customized. Attributes may be set through the initializer or manually. To see what these do, checkout the demo project.
```swift
/// Background color of the overlay that covers your current view controller. Default set to UIColor(white: 0, alpha: 0.3)
public var overlayBackgroundColor: UIColor

/// Direction where you want the modal to appear from. Default set to .Bottom
public var transitionDirection: JModalTransitionDirection

/// View animation options for how to have modal and overlay to appear. Default set to .CurveLinear
public var animationOptions: UIViewAnimationOptions

/// Duration on how long views animate on appearing and dismissing. Default set to 0.3
public var animationDuration: NSTimeInterval

/// The 0 - 1 value of how much the background viewcontroller transforms on modal appearance. Default set to 0.93
public var backgroundTransformPercentage: Double

/// Boolean indicating of background viewcontroller should transform on modal appearance. Default set to true
public var backgroundTransform: Bool

/// Boolean indicating if tapping on the background overlay should dismiss modal. Default set to true
public var tapOverlayDismiss: Bool

///Swipe gesture directions you want your modal to support for dismissing. Default set to []
public var swipeDirections: [UISwipeGestureRecognizerDirection]
```

### JModalDelegate

Importing the pod automatically makes `UIViewController`s conform to JModalDelegate. Overriding `dismissModal` will allow getting data back from the modal.

## TODOs
- Tests
- More customizability
- Rx version

## Contribute

Anyone is welcome to help with the improvement of JModalController through finding issues or any pull requests.

## Author

Mark Jackson, jacks205@mail.chapman.edu

## License

JModalController is available under the MIT license. See the LICENSE file for more info.
