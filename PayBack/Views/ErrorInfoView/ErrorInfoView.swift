//
//  ErrorInfoView.swift
//  PayBack
//
//  Created by Dinakaran M on 05/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
class ErrorInfoView: UIView {
    @IBOutlet weak fileprivate var infoView: UIView!
    @IBOutlet weak fileprivate var infoIcon: UIImageView!
    @IBOutlet weak fileprivate var infoMessagelabel: UILabel!
    var view: UIView!
    weak var selfView: UIView?
    let windowBounds = UIScreen.main.bounds
    var errorViewHeight: CGFloat = 80
    var visibleDuration: CGFloat = 3
    var animationDuretion: CGFloat = 1
    var defaultBottomSpace: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.xibSetUp()
    }
    func xibSetUp() {
        self.infoView.backgroundColor = ColorConstant.errorInfoViewBGColor
    }
    deinit {
        print("Deinit called - ErrorInfoView ")  
    }  
}
extension ErrorInfoView {
    @discardableResult
    func set(infoViewBGColor color: UIColor) -> Self {
        self.infoView.backgroundColor = color
        return self
    }
    @discardableResult
    func set(errorMessage message: String) -> Self {
        self.infoMessagelabel.text = message
        return self
    }
    @discardableResult
    func set(infoIcon icon: UIImage) -> Self {
        self.infoIcon.image = icon
        return self
    }
    @discardableResult
    func set(FontandSize font: UIFont) -> Self {
        self.infoMessagelabel.font = font
        return self
    }
    @discardableResult
    func set(viewHeight height: CGFloat) -> Self {
        self.errorViewHeight = height
        if UIDevice.current.iPhoneX {
            self.errorViewHeight += 30
        }
        return self
    }
    @discardableResult
    func set(visibleDuration duration: CGFloat) -> Self {
        self.visibleDuration = duration
        return self
    }
    @discardableResult
    func set(animationDuration duration: CGFloat) -> Self {
        self.animationDuretion = duration
        return self
    }
    @discardableResult
    func set(showErrorView isDisplay: Bool) -> Self {
        if isDisplay, !isErrorViewDisplaying {
            self.displayView()
        }
        return self
    }
    func set(errorViewBottomSpace space: CGFloat) -> Self {
            self.defaultBottomSpace = space
        
        return self
    }
    @discardableResult
    func set(selfView view: UIView) -> Self {
        self.selfView = view
        return self
    }
    func displayView() {
        if let selfView = self.selfView {
            self.frame = CGRect(x: 0, y: selfView.frame.height, width: selfView.frame.width, height: self.errorViewHeight)
        } else {
            self.frame = CGRect(x: 0, y: self.windowBounds.height, width: self.windowBounds.width, height: self.errorViewHeight)
        }
        
        UIView.animate(withDuration: TimeInterval(self.animationDuretion), animations: {
            if let selfView = self.selfView {
                self.frame.origin.y = selfView.frame.height - self.errorViewHeight - self.defaultBottomSpace
                selfView.addSubview(self)
                isErrorViewDisplaying = true
            } else {
                self.frame.origin.y = self.windowBounds.height - self.errorViewHeight
                if let window = UIApplication.shared.keyWindow {
                    window.addSubview(self)
                }
            }
        }, completion: { (_) in
            self.perform(#selector(self.removeErrorViewInfo), with: nil, afterDelay: TimeInterval(self.visibleDuration))
        })
    }
    @objc func removeErrorViewInfo() {
        UIView.animate(withDuration: TimeInterval(self.animationDuretion), animations: {
            if let selfView = self.selfView {
                self.frame.origin.y = selfView.frame.height
            } else {
                self.frame.origin.y = self.windowBounds.height
            }
            
        }, completion: {[weak self] (_) in
            self?.removeFromSuperview()
            isErrorViewDisplaying = false
        })
    }
}
