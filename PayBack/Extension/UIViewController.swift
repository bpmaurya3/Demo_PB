//
//  UIViewController.swift
//  PayBack
//
//  Created by Dinakaran M on 31/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

extension UIViewController {
    static func storyboardInstance(storyBoardName: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String.className(self))
    }
    
    var activityIndicatorTag: Int { return 999999 }
    func setNavigationBarItem() {
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    public var orientation: UIInterfaceOrientation? {
        let orientation = UIDevice.current.orientation
        var converted: UIInterfaceOrientation!
        // UIApplication.sharedApplication().statusBarOrientation is trash cause it lags (being set to the value predating the transition reported by viewWillTransitionToSize)
        switch orientation {
        case .portrait: // Device oriented vertically, home button on the bottom
            converted = .portrait
        case .portraitUpsideDown: // Device oriented vertically, home button on the top
            converted = .portraitUpsideDown
        case .landscapeLeft: // Device oriented horizontally, home button on the right
            converted = .landscapeLeft
        case .landscapeRight: // Device oriented horizontally, home button on the left
            converted = .landscapeRight
        default:
            // let the caller do the dirty dancing with the status bar orientation or whatever
            return nil
        }
        return converted
    }
    
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? ""
    }
    
    func getPreviousViewController(of name: String) -> UIViewController? {
        guard let rootVC = APP_DEL?.window?.rootViewController as? SlideMenuController, let rootNVC = rootVC.mainViewController  else {
            return nil
        }
        for viewController in rootNVC.viewControllers {
            print(viewController.className)
        }
        var previous: UIViewController?
        for viewController in rootNVC.viewControllers where viewController.className == name {
            previous = viewController
            break
        }
        return previous
    }
    
    func showErrorView(errorMsg: String = "Invalid Error") {
        var defaultBottomSpace: CGFloat = 0
        if #available(iOS 11, *), self.navigationController?.viewControllers == nil {
            defaultBottomSpace = 20
        } else {
            defaultBottomSpace = 0
        }
        DispatchQueue.main.async {
            let errorView = UINib(nibName: "ErrorInfoView", bundle: nil).instantiate(withOwner: self, options: nil).first as? ErrorInfoView
            errorView?
                .set(viewHeight: 50)
                .set(errorViewBottomSpace: defaultBottomSpace)
                .set(selfView: self.view ?? UIView())
                .set(errorMessage: errorMsg)
                .set(animationDuration: 0.2)
                .set(showErrorView: true)
        }
    }
    func showErrorViewInParent(errorMsg: String = "Invalid Error") {
        var defaultBottomSpace: CGFloat = 0
        if #available(iOS 11, *), self.navigationController?.viewControllers == nil {
            defaultBottomSpace = 20
        } else {
            defaultBottomSpace = 0
        }
        DispatchQueue.main.async {
            let errorView = UINib(nibName: "ErrorInfoView", bundle: nil).instantiate(withOwner: self, options: nil).first as? ErrorInfoView
            errorView?
                .set(viewHeight: 50)
                .set(errorViewBottomSpace: defaultBottomSpace)
                .set(selfView: self.parent?.view ?? UIView())
                .set(errorMessage: errorMsg)
                .set(animationDuration: 0.2)
                .set(showErrorView: true)
        }
    }
    func showErrorViewInWindow(errorMsg: String = "Invalid Error") {
        var defaultBottomSpace: CGFloat = 0
        if #available(iOS 11, *), self.navigationController?.viewControllers == nil {
            defaultBottomSpace = 20
        } else {
            defaultBottomSpace = 0
        }
        DispatchQueue.main.async {
            let errorView = UINib(nibName: "ErrorInfoView", bundle: nil).instantiate(withOwner: self, options: nil).first as? ErrorInfoView
            errorView?
                .set(viewHeight: 50)
                .set(errorViewBottomSpace: defaultBottomSpace)
                .set(errorMessage: errorMsg)
                .set(animationDuration: 0.2)
                .set(showErrorView: true)
        }
    }
    
    func startActivityIndicator(
        style: UIActivityIndicatorViewStyle = .whiteLarge,
        location: CGPoint? = nil) {
         //stopActivityIndicator()
            DispatchQueue.main.async {
                 let loc = location ?? self.view.center
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: style)
                activityIndicator.tag = self.activityIndicatorTag
                activityIndicator.center = loc
                activityIndicator.hidesWhenStopped = true
                activityIndicator.color = .black
               // self.view.isUserInteractionEnabled = false
                activityIndicator.startAnimating()
                self.view.addSubview(activityIndicator)
                self.view.bringSubview(toFront: activityIndicator)
            }
    }
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            if let activityIndicator = self.view.subviews.first(where: { $0.tag == self.activityIndicatorTag }) as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                activityIndicator.removeFromSuperview()
            }
        }
    }
}
