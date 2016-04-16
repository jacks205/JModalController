import UIKit
import ObjectiveC

public class JModalConfig {
    public var overlayBackgroundColor: UIColor
    public var transitionDirection: JModalTransitionDirection
    public var animationOptions: UIViewAnimationOptions
    public var animationDuration: NSTimeInterval
    public var swipeDownDismiss: Bool
    public var backgroundTransformPercentage: Double
    public var backgroundTransform: Bool
    public var tapOverlayDismiss: Bool
    public var swipeDirections: [UISwipeGestureRecognizerDirection]
    
    public init
    (
        overlayBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.3),
        transitionDirection: JModalTransitionDirection = .Bottom,
        animationOptions: UIViewAnimationOptions = .CurveLinear,
        animationDuration: NSTimeInterval = 0.3,
        swipeDownDismiss: Bool = true,
        backgroundTransformPercentage: Double = 0.93,
        backgroundTransform: Bool = true,
        tapOverlayDismiss: Bool = true,
        swipeDirections:[UISwipeGestureRecognizerDirection] = []
    ) {
        self.overlayBackgroundColor = overlayBackgroundColor
        self.transitionDirection = transitionDirection
        self.animationOptions = animationOptions
        self.animationDuration = animationDuration
        self.swipeDownDismiss = swipeDownDismiss
        self.backgroundTransformPercentage = backgroundTransformPercentage
        self.backgroundTransform = backgroundTransform
        self.tapOverlayDismiss = tapOverlayDismiss
        self.swipeDirections = swipeDirections
    }
    
    
}

public enum JModalTransitionDirection {
    case Bottom, Top, Left, Right, BottomToCenter, TopToCenter
}

public protocol JModalDelegate {
    func dismissModal(
        sender : AnyObject,
        data : AnyObject?
    ) -> Void
    
    func presentModal(
        modalViewController: UIViewController,
        config : JModalConfig,
        completion : (() -> Void)?
    ) -> Void
}

private func getTransitionCGRectsForTransitionStyle(presentingViewController : UIViewController,_ modalViewController : UIViewController,_ transitionDirection : JModalTransitionDirection) -> (CGRect, CGRect) {
    let center = presentingViewController.view.center
    switch transitionDirection {
    case .Bottom:
        return  (CGRect(x: center.x - modalViewController.view.frame.width / 2, y: presentingViewController.view.frame.height + modalViewController.view.frame.height, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height)
                ,CGRect(x: center.x - modalViewController.view.frame.width / 2, y: presentingViewController.view.frame.height - modalViewController.view.frame.height, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height))
    case .Top:
        return  (CGRect(x: center.x - modalViewController.view.frame.width / 2, y: 0 - modalViewController.view.frame.height, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height)
                ,CGRect(x: center.x - modalViewController.view.frame.width / 2, y: 0, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height))
    case .Left:
        return  (CGRect(x: 0 - modalViewController.view.frame.width, y: center.y - modalViewController.view.frame.height / 2, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height)
                ,CGRect(x: 0, y: center.y - modalViewController.view.frame.height / 2, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height))
    case .Right:
        return  (CGRect(x: presentingViewController.view.frame.width, y: center.y - modalViewController.view.frame.height / 2, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height)
                ,CGRect(x: presentingViewController.view.frame.width - modalViewController.view.frame.width, y: center.y - modalViewController.view.frame.height / 2, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height))
    case .TopToCenter:
        return  (CGRect(x: center.x - modalViewController.view.frame.width / 2, y: 0 - modalViewController.view.frame.height, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height)
                ,CGRect(x: center.x - modalViewController.view.frame.width / 2, y: center.y - modalViewController.view.frame.height / 2, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height))
    case .BottomToCenter:
        return  (CGRect(x: center.x - modalViewController.view.frame.width / 2, y: presentingViewController.view.frame.height + modalViewController.view.frame.height, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height)
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
private var jOverlayAssociationKey: UInt8 = 0
private var jModalStartingRectAssociationKey: UInt8 = 0
private var jModalEndingRectAssociationKey: UInt8 = 0

extension UIViewController : JModalDelegate {
    
    private var jConfig: JModalConfig! {
        get {
            return objc_getAssociatedObject(self, &jConfigAssociationKey) as? JModalConfig
        }
        set(newValue) {
            objc_setAssociatedObject(self, &jConfigAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var jModal: UIViewController! {
        get {
            return objc_getAssociatedObject(self, &jModalAssociationKey) as? UIViewController
        }
        set(newValue) {
            objc_setAssociatedObject(self, &jModalAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var jOverlay: UIView! {
        get {
            return objc_getAssociatedObject(self, &jOverlayAssociationKey) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &jOverlayAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var jModalStartingRect: JRect! {
        get {
            return objc_getAssociatedObject(self, &jModalStartingRectAssociationKey) as? JRect
        }
        set(newValue) {
            objc_setAssociatedObject(self, &jModalStartingRectAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var jModalEndingRect: JRect! {
        get {
            return objc_getAssociatedObject(self, &jModalEndingRectAssociationKey) as? JRect
        }
        set(newValue) {
            objc_setAssociatedObject(self, &jModalEndingRectAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private func addOverlay
        (
            overlayColorBackgroundColor : UIColor? = UIColor(white: 0, alpha: 0.3),
            dismissAnimationDuration : NSTimeInterval = 0.3,
            tapToDismiss: Bool = true
        ) {
        
        self.view.toggleSubviewsUserInteractionEnabled(false)
        jOverlay = UIView(frame: self.view.frame)
        jOverlay.backgroundColor = UIColor.clearColor()
        jOverlay.userInteractionEnabled = true
        if tapToDismiss {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissModalByOverlay))
            jOverlay.addGestureRecognizer(tap)
        }
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(jOverlay)
    }
    
    @objc private func dismissModalByOverlay(recognizer : UIGestureRecognizer) {
        dismissModal(jConfig.animationDuration)
    }
    
    public func presentModal
        (
            modalViewController : UIViewController,
            config: JModalConfig,
            completion : (() -> Void)?
        ) {
        jConfig = config
        jModal = modalViewController
        let (startingRect, endingRect) = getTransitionCGRectsForTransitionStyle(self, modalViewController, config.transitionDirection)
        jModalStartingRect = JRect(rect: startingRect)
        jModalEndingRect = JRect(rect: endingRect)
        addOverlay(dismissAnimationDuration: config.animationDuration, tapToDismiss: config.tapOverlayDismiss, config.overlayBackgroundColor)
        modalViewController.view.frame = startingRect
        
        config.swipeDirections.map { direction in
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissModalByOverlay))
            swipe.direction = direction
            modalViewController.view.addGestureRecognizer(swipe)
        }
        
        self.view.clipsToBounds = false
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(modalViewController.view)
        var transform : CGAffineTransform?
        if config.backgroundTransform {
            let transformPercentage = CGFloat(config.backgroundTransformPercentage)
            transform = CGAffineTransformScale(CGAffineTransformIdentity, transformPercentage, transformPercentage)
        }
        modalViewController.view.userInteractionEnabled = true
        modalViewController.view.layoutIfNeeded()
        UIView.animateWithDuration(config.animationDuration, delay: 0, options: config.animationOptions, animations: {
            self.jOverlay.backgroundColor = config.overlayBackgroundColor
            window?.addSubview(modalViewController.view)
            modalViewController.view.frame = endingRect
            if let t = transform {
                self.view.transform = t
            }
            self.view.layoutIfNeeded()
            }) { (_) in
                modalViewController.didMoveToParentViewController(self)
                completion?()
        }
    }
    
    public func dismissModal
        (
            sender: AnyObject,
            data: AnyObject?
        ) {
        dismissModal(jConfig.animationDuration)
    }
    
    private func dismissModal(animationDuration : NSTimeInterval) {
        UIView.animateWithDuration(animationDuration, delay: 0, options: jConfig.animationOptions, animations: {
            self.jModal.view.userInteractionEnabled = false
            self.jModal.view.frame = self.jModalStartingRect.rect
            //TODO: Remove forced layout
            self.jModal.view.layoutSubviews()
            if self.jConfig.backgroundTransform {
                self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
            }
            self.view.layoutIfNeeded()
            self.jOverlay.backgroundColor = UIColor.clearColor()
            }, completion: { (_) in
                self.jOverlay.removeFromSuperview()
                self.jOverlay = nil
                self.jModal.view.removeFromSuperview()
                self.jModal = nil
                self.view.toggleSubviewsUserInteractionEnabled(true)
        })
    }

}

internal extension UIView {
    func toggleSubviewsUserInteractionEnabled(enabled : Bool) {
        for subView in self.subviews {
            subView.userInteractionEnabled = enabled
        }
    }
}
