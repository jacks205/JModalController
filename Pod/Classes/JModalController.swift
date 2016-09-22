import UIKit
import ObjectiveC

/// Configuration model for setting modal attributes
open class JModalConfig {
    
    /// Background color of the overlay that covers your current view controller. Default set to UIColor(white: 0, alpha: 0.3)
    open var overlayBackgroundColor: UIColor
    
    /// Direction where you want the modal to appear from. Default set to .Bottom
    open var transitionDirection: JModalTransitionDirection
    
    /// View animation options for how to have modal and overlay to appear. Default set to .CurveLinear
    open var animationOptions: UIViewAnimationOptions
    
    /// Duration on how long views animate on appearing and dismissing. Default set to 0.3
    open var animationDuration: TimeInterval
    
    /// The 0 - 1 value of how much the background viewcontroller transforms on modal appearance. Default set to 0.93
    open var backgroundTransformPercentage: Double
    
    /// Boolean indicating of background viewcontroller should transform on modal appearance. Default set to true
    open var backgroundTransform: Bool
    
    /// Boolean indicating if tapping on the background overlay should dismiss modal. Default set to true
    open var tapOverlayDismiss: Bool
    
    ///Swipe gesture directions you want your modal to support for dismissing. Default set to []
    open var swipeDirections: [UISwipeGestureRecognizerDirection]
    
    /**
     Initializer for setting configuration attributes for presenting the modal.
     
     - parameter overlayBackgroundColor:        Background color of the overlay that covers your current view controller. Default set to UIColor(white: 0, alpha: 0.3)
     - parameter transitionDirection:           Direction where you want the modal to appear from. Default set to .Bottom
     - parameter animationOptions:              View animation options for how to have modal and overlay to appear. Default set to .CurveLinear
     - parameter animationDuration:             Duration on how long views animate on appearing and dismissing. Default set to 0.3
     - parameter backgroundTransformPercentage: The 0 - 1 value of how much the background viewcontroller transforms on modal appearance. Default set to 0.93
     - parameter backgroundTransform:           Boolean indicating of background viewcontroller should transform on modal appearance. Default set to true
     - parameter tapOverlayDismiss:             Boolean indicating if tapping on the background overlay should dismiss modal. Default set to true
     - parameter swipeDirections:               Swipe gesture directions you want your modal to support for dismissing. Default set to []
     
     - returns: JModalConfig object
     */
    public init
    (
        overlayBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.3),
        transitionDirection: JModalTransitionDirection = .bottom,
        animationOptions: UIViewAnimationOptions = .curveLinear,
        animationDuration: TimeInterval = 0.3,
        backgroundTransformPercentage: Double = 0.93,
        backgroundTransform: Bool = true,
        tapOverlayDismiss: Bool = true,
        swipeDirections:[UISwipeGestureRecognizerDirection] = []
    ) {
        self.overlayBackgroundColor = overlayBackgroundColor
        self.transitionDirection = transitionDirection
        self.animationOptions = animationOptions
        self.animationDuration = animationDuration
        self.backgroundTransformPercentage = backgroundTransformPercentage
        self.backgroundTransform = backgroundTransform
        self.tapOverlayDismiss = tapOverlayDismiss
        self.swipeDirections = swipeDirections
    }
    
    
}

/**
 Enum to describe the direction where the modal should appear from.
 
 - Bottom:         Modal animates from bottom and stops at the height and center of the presenting viewcontroller.
 - Top:            Modal animates from top and stops at the origin and center of the presenting viewcontroller.
 - Left:           Modal animates from the left and stops at the origin and center of the presenting viewcontroller.
 - Right:          Modal animates from the right and stops at the origin and center of the presenting viewcontroller.
 - BottomToCenter: Modal animates from the bottom and stops at center of the presenting viewcontroller.
 - TopToCenter:    Modal animates from the top and stops at center of the presenting viewcontroller.
 */
public enum JModalTransitionDirection {
    case bottom, top, left, right, bottomToCenter, topToCenter
}

/**
 *  Delegate for dismissing modal.
 */
public protocol JModalDelegate {
    func dismissModal(
        _ sender : Any,
        data : Any?
    ) -> Void
    
    func presentModal(
        _ basePresentingViewController : UIViewController,
        modalViewController : UIViewController,
        config : JModalConfig,
        completion : (() -> Void)?
    ) -> Void
}

private func getTransitionCGRectsForTransitionStyle(_ presentingViewController : UIViewController,_ modalViewController : UIViewController,_ transitionDirection : JModalTransitionDirection) -> (CGRect, CGRect) {
    let center = presentingViewController.view.center
    switch transitionDirection {
    case .bottom:
        return  (CGRect(x: center.x - presentingViewController.view.frame.width / 2, y: presentingViewController.view.frame.height + modalViewController.view.frame.height, width: presentingViewController.view.frame.width, height: modalViewController.view.frame.height)
                ,CGRect(x: center.x - presentingViewController.view.frame.width / 2, y: presentingViewController.view.frame.height - modalViewController.view.frame.height, width: presentingViewController.view.frame.width, height: modalViewController.view.frame.height))
    case .top:
        return  (CGRect(x: center.x - presentingViewController.view.frame.width / 2, y: 0 - modalViewController.view.frame.height, width: presentingViewController.view.frame.width, height: modalViewController.view.frame.height)
                ,CGRect(x: center.x - presentingViewController.view.frame.width / 2, y: 0, width: presentingViewController.view.frame.width, height: modalViewController.view.frame.height))
    case .left:
        return  (CGRect(x: 0 - modalViewController.view.frame.width, y: center.y - presentingViewController.view.frame.height / 2, width: modalViewController.view.frame.width, height: presentingViewController.view.frame.height)
                ,CGRect(x: 0, y: center.y - presentingViewController.view.frame.height / 2, width: modalViewController.view.frame.width, height: presentingViewController.view.frame.height))
    case .right:
        return  (CGRect(x: presentingViewController.view.frame.width, y: center.y - presentingViewController.view.frame.height / 2, width: modalViewController.view.frame.width, height: presentingViewController.view.frame.height)
                ,CGRect(x: presentingViewController.view.frame.width - modalViewController.view.frame.width, y: center.y - presentingViewController.view.frame.height / 2, width: modalViewController.view.frame.width, height: presentingViewController.view.frame.height))
    case .topToCenter:
        return  (CGRect(x: center.x - modalViewController.view.frame.width / 2, y: 0 - modalViewController.view.frame.height, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height)
                ,CGRect(x: center.x - modalViewController.view.frame.width / 2, y: center.y - modalViewController.view.frame.height / 2, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height))
    case .bottomToCenter:
        return  (CGRect(x: center.x - modalViewController.view.frame.width / 2, y: presentingViewController.view.frame.maxY + modalViewController.view.frame.height, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height)
                ,CGRect(x: center.x - modalViewController.view.frame.width / 2, y: center.y - modalViewController.view.frame.height / 2, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height))
    }
}

private class JRect {
    let rect : CGRect
    init(rect : CGRect) {
        self.rect = rect
    }
}

private var jConfigAssociationKey: UInt8 = 0
private var jModalAssociationKey: UInt8 = 0
private var jPresentingAssociationKey: UInt8 = 0
private var jOverlayAssociationKey: UInt8 = 0
private var jModalStartingRectAssociationKey: UInt8 = 0
private var jModalEndingRectAssociationKey: UInt8 = 0

extension UIViewController : JModalDelegate {
    
    fileprivate var jConfig: JModalConfig! {
        get {
            return objc_getAssociatedObject(self, &jConfigAssociationKey) as? JModalConfig
        }
        set(newValue) {
            objc_setAssociatedObject(self, &jConfigAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    fileprivate var jModal: UIViewController! {
        get {
            return objc_getAssociatedObject(self, &jModalAssociationKey) as? UIViewController
        }
        set(newValue) {
            objc_setAssociatedObject(self, &jModalAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    fileprivate var jPresenting: UIViewController! {
        get {
            return objc_getAssociatedObject(self, &jPresentingAssociationKey) as? UIViewController
        }
        set(newValue) {
            objc_setAssociatedObject(self, &jPresentingAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    fileprivate var jOverlay: UIView! {
        get {
            return objc_getAssociatedObject(self, &jOverlayAssociationKey) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &jOverlayAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    fileprivate var jModalStartingRect: JRect! {
        get {
            return objc_getAssociatedObject(self, &jModalStartingRectAssociationKey) as? JRect
        }
        set(newValue) {
            objc_setAssociatedObject(self, &jModalStartingRectAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    fileprivate var jModalEndingRect: JRect! {
        get {
            return objc_getAssociatedObject(self, &jModalEndingRectAssociationKey) as? JRect
        }
        set(newValue) {
            objc_setAssociatedObject(self, &jModalEndingRectAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    fileprivate func addOverlay
        (
            _ overlayColorBackgroundColor : UIColor? = UIColor(white: 0, alpha: 0.3),
            dismissAnimationDuration : TimeInterval = 0.3,
            tapToDismiss: Bool = true
        ) {
        
        self.jPresenting.view.toggleSubviewsUserInteractionEnabled(false)
        jOverlay = UIView(frame: self.jPresenting.view.frame)
        jOverlay.backgroundColor = UIColor.clear
        jOverlay.isUserInteractionEnabled = true
        if tapToDismiss {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissModalByOverlay))
            jOverlay.addGestureRecognizer(tap)
        }
        let window = UIApplication.shared.keyWindow
        window?.addSubview(jOverlay)
    }
    
    @objc fileprivate func dismissModalByOverlay(_ recognizer : UIGestureRecognizer) {
        dismissModal(self, data: nil)
    }
    
    /**
     Present modal controller with configuration settings.
     
     - parameter modalViewController: Controller to present.
     - parameter config:              Configuration that describes how the modal shall present and dismiss.
     - parameter completion:          Completion handler. Is called after modal animates into the view.
     */
    public func presentModal
        (
            _ basePresentingViewController : UIViewController,
            modalViewController : UIViewController,
            config: JModalConfig,
            completion : (() -> Void)?
        ) {
        jConfig = config
        jModal = modalViewController
        jPresenting = basePresentingViewController
        let (startingRect, endingRect) = getTransitionCGRectsForTransitionStyle(basePresentingViewController, modalViewController, config.transitionDirection)
        jModalStartingRect = JRect(rect: startingRect)
        jModalEndingRect = JRect(rect: endingRect)
        addOverlay(config.overlayBackgroundColor, dismissAnimationDuration: config.animationDuration, tapToDismiss: config.tapOverlayDismiss)
        modalViewController.view.frame = startingRect
        
        config.swipeDirections = config.swipeDirections.map { direction in
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissModalByOverlay))
            swipe.direction = direction
            modalViewController.view.addGestureRecognizer(swipe)
            return direction
        }
        
        basePresentingViewController.view.clipsToBounds = false
        let window = UIApplication.shared.keyWindow
        window?.addSubview(modalViewController.view)
        var transform : CGAffineTransform?
        if config.backgroundTransform {
            let transformPercentage = CGFloat(config.backgroundTransformPercentage)
            transform = CGAffineTransform.identity.scaledBy(x: transformPercentage, y: transformPercentage)
        }
        modalViewController.view.isUserInteractionEnabled = true
        modalViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: config.animationDuration, delay: 0, options: config.animationOptions, animations: {
            self.jOverlay.backgroundColor = config.overlayBackgroundColor
            window?.addSubview(modalViewController.view)
            modalViewController.view.frame = endingRect
            if let t = transform {
                basePresentingViewController.view.transform = t
            }
            basePresentingViewController.view.layoutIfNeeded()
            }) { (_) in
                modalViewController.didMove(toParentViewController: self)
                completion?()
        }
    }
    
    /**
     Delegate method for dismissing modal
     
     - parameter sender: Controller that wants to be dismissed
     - parameter data:   Data to be passed back to the presenting controller
     */
    open func dismissModal
        (
            _ sender: Any,
            data: Any?
        ) {
        dismissModal(jConfig.animationDuration)
    }
    
    fileprivate func dismissModal(_ animationDuration : TimeInterval) {
        UIView.animate(withDuration: animationDuration, delay: 0, options: jConfig.animationOptions, animations: {
            self.jModal.view.isUserInteractionEnabled = false
            self.jModal.view.frame = self.jModalStartingRect.rect
            //TODO: Remove forced layout
            self.jModal.view.layoutSubviews()
            if self.jConfig.backgroundTransform {
                self.jPresenting.view.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            }
            self.jPresenting.view.layoutIfNeeded()
            self.jOverlay.backgroundColor = UIColor.clear
            }, completion: { (_) in
                self.jOverlay.removeFromSuperview()
                self.jOverlay = nil
                self.jModal.view.removeFromSuperview()
                self.jModal = nil
                self.jPresenting.view.toggleSubviewsUserInteractionEnabled(true)
        })
    }

}

internal extension UIView {
    func toggleSubviewsUserInteractionEnabled(_ enabled : Bool) {
        for subView in self.subviews {
            subView.isUserInteractionEnabled = enabled
        }
    }
}
