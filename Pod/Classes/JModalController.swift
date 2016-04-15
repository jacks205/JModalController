import UIKit
import ObjectiveC

public enum JModalTransitionStyle {
    case Bottom, Top, Left, Right
}

public protocol JModalDelegate {
    func dismissModal(
        data : AnyObject?,
        animationDuration : NSTimeInterval
    ) -> Void
    
    func dismissModal(
        animationDuration : NSTimeInterval
    ) -> Void
    
    func presentModal(
        modalViewController : UIViewController,
        animationDuration : NSTimeInterval,
        transitionStyle : JModalTransitionStyle,
        dismissSwipeGestureRecognizerDirection : UISwipeGestureRecognizerDirection?,
        completion : (() -> Void)?
    ) -> Void
}

private func getTransitionCGRectsForTransitionStyle(presentingViewController : UIViewController, modalViewController : UIViewController, transitionStyle : JModalTransitionStyle) -> (CGRect, CGRect) {
    
    switch transitionStyle {
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

class JRect {
    let rect : CGRect
    init(rect : CGRect) {
        self.rect = rect
    }
}

private var jOverlayAssociationKey: UInt8 = 0
private var jDismissAnimationDurationAssociationKey : UInt8 = 0
private var jModalAssociationKey: UInt8 = 0
private var jModalStartingRectAssociationKey: UInt8 = 0
private var jModalEndingRectAssociationKey: UInt8 = 0

extension UIViewController : JModalDelegate {
    
    private var jOverlay: UIView! {
        get {
            return objc_getAssociatedObject(self, &jOverlayAssociationKey) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &jOverlayAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
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
    
    private var jDismissAnimationDuration: NSTimeInterval! {
        get {
            return objc_getAssociatedObject(self, &jDismissAnimationDurationAssociationKey) as? NSTimeInterval
        }
        set(newValue) {
            objc_setAssociatedObject(self, &jDismissAnimationDurationAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
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
            overlayColorBackgroundColor : UIColor? = UIColor(white: 0, alpha: 0.5),
            dismissAnimationDuration : NSTimeInterval = 0.5
        ) {
        
        self.view.toggleSubviewsUserInteractionEnabled(false)
        jOverlay = UIView(frame: self.view.frame)
        jOverlay.backgroundColor = UIColor.clearColor()
        jOverlay.userInteractionEnabled = true
        jDismissAnimationDuration = dismissAnimationDuration
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissModalByOverlay))
        jOverlay.addGestureRecognizer(tap)
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(jOverlay)
//        self.view.addSubview(jOverlay)
    }
    
    public func dismissModalByOverlay(recognizer : UITapGestureRecognizer) {
        dismissModal(jDismissAnimationDuration)
    }
    
    public func presentModal
        (
            modalViewController : UIViewController,
            animationDuration : NSTimeInterval = 0.5,
            transitionStyle : JModalTransitionStyle = .Bottom,
            dismissSwipeGestureRecognizerDirection : UISwipeGestureRecognizerDirection? = nil,
            completion : (() -> Void)?
        ) {
        jModal = modalViewController
        let (startingRect, endingRect) = getTransitionCGRectsForTransitionStyle(self, modalViewController: modalViewController, transitionStyle: transitionStyle)
        jModalStartingRect = JRect(rect: startingRect)
        jModalEndingRect = JRect(rect: endingRect)
        let overlayBackgroundColor = UIColor(white: 0, alpha: 0.3)
        addOverlay(dismissAnimationDuration: animationDuration, overlayBackgroundColor)
        modalViewController.view.frame = startingRect
        self.view.clipsToBounds = false
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(modalViewController.view)
        let t = CGAffineTransformScale(CGAffineTransformIdentity, 0.93, 0.93)
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.jOverlay.backgroundColor = overlayBackgroundColor
            modalViewController.view.userInteractionEnabled = true
            modalViewController.view.frame = endingRect
            self.view.transform = t
            self.view.layoutIfNeeded()
            }) { (_) in
                modalViewController.didMoveToParentViewController(self)
                completion?()
        }
    }
    
    public func dismissModal
        (
            data: AnyObject? = nil,
            animationDuration : NSTimeInterval = 0.5
        ) {
        dismissModal(animationDuration)
    }
    
    public func dismissModal(animationDuration : NSTimeInterval) {
        let t = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            }, completion: nil)
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.jModal.view.userInteractionEnabled = false
            self.jModal.view.frame = self.jModalStartingRect.rect
            self.view.transform = t
            self.jOverlay.backgroundColor = UIColor.clearColor()
            self.view.layoutIfNeeded()
            }, completion: { (_) in
                self.jOverlay.layoutIfNeeded()
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
