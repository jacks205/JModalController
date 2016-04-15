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
    
    public init
    (
        overlayBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.3),
        transitionDirection: JModalTransitionDirection = .Bottom,
        animationOptions: UIViewAnimationOptions = .CurveLinear,
        animationDuration: NSTimeInterval = 0.3,
        swipeDownDismiss: Bool = true,
        backgroundTransformPercentage: Double = 0.93,
        backgroundTransform: Bool = true
    ) {
        self.overlayBackgroundColor = overlayBackgroundColor
        self.transitionDirection = transitionDirection
        self.animationOptions = animationOptions
        self.animationDuration = animationDuration
        self.swipeDownDismiss = swipeDownDismiss
        self.backgroundTransformPercentage = backgroundTransformPercentage
        self.backgroundTransform = backgroundTransform
    }
    
    
}

public enum JModalTransitionDirection {
    case Bottom, Top, Left, Right
}

public protocol JModalDelegate {
    func dismissModal(
        data : AnyObject?
    ) -> Void
    
    func presentModal(
        modalViewController: UIViewController,
        config : JModalConfig,
        completion : (() -> Void)?
    ) -> Void
}

private func getTransitionCGRectsForTransitionStyle(presentingViewController : UIViewController, modalViewController : UIViewController, transitionDirection : JModalTransitionDirection) -> (CGRect, CGRect) {
    switch transitionDirection {
    case .Bottom:
        return  (CGRect(x: 0, y: presentingViewController.view.frame.height, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height)
                ,CGRect(x: 0, y: presentingViewController.view.frame.height - modalViewController.view.frame.height, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height))
    case .Top:
        return  (CGRect(x: 0, y: 0 - modalViewController.view.frame.height, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height)
                ,CGRect(x: 0, y: 0, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height))
    case .Left:
        return  (CGRect(x: 0 - modalViewController.view.frame.width, y: 0, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height)
                ,CGRect(x: 0, y: 0, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height))
    case .Right:
        return  (CGRect(x: presentingViewController.view.frame.width, y: 0, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height)
                ,CGRect(x: 0, y: 0, width: modalViewController.view.frame.width, height: modalViewController.view.frame.height))
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
            dismissAnimationDuration : NSTimeInterval = 0.3
        ) {
        
        self.view.toggleSubviewsUserInteractionEnabled(false)
        jOverlay = UIView(frame: self.view.frame)
        jOverlay.backgroundColor = UIColor.clearColor()
        jOverlay.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissModalByOverlay))
        jOverlay.addGestureRecognizer(tap)
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(jOverlay)
    }
    
    @objc private func dismissModalByOverlay(recognizer : UITapGestureRecognizer) {
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
        let (startingRect, endingRect) = getTransitionCGRectsForTransitionStyle(self, modalViewController: modalViewController, transitionDirection: config.transitionDirection)
        jModalStartingRect = JRect(rect: startingRect)
        jModalEndingRect = JRect(rect: endingRect)
        addOverlay(dismissAnimationDuration: config.animationDuration, config.overlayBackgroundColor)
        modalViewController.view.frame = startingRect
        
        self.view.clipsToBounds = false
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(modalViewController.view)
        var transform : CGAffineTransform?
        if config.backgroundTransform {
            let transformPercentage = CGFloat(config.backgroundTransformPercentage)
            transform = CGAffineTransformScale(CGAffineTransformIdentity, transformPercentage, transformPercentage)
        }
        modalViewController.view.userInteractionEnabled = true
        UIView.animateWithDuration(config.animationDuration, delay: 0, options: config.animationOptions, animations: {
            self.jOverlay.backgroundColor = config.overlayBackgroundColor
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
            data: AnyObject? = nil
        ) {
        dismissModal(jConfig.animationDuration)
    }
    
    private func dismissModal(animationDuration : NSTimeInterval) {
        UIView.animateWithDuration(animationDuration, delay: 0, options: jConfig.animationOptions, animations: {
            self.jModal.view.userInteractionEnabled = false
            self.jModal.view.frame = self.jModalStartingRect.rect
            if self.jConfig.backgroundTransform {
                self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
            }
            self.jOverlay.backgroundColor = UIColor.clearColor()
            self.view.layoutIfNeeded()
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
