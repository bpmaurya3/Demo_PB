//
//  CustomNavigationBarItems.swift
//  customNavigationController
//
//  Created by Dinakaran M on 04/09/17.
//  Copyright © 2017 Dinakaran M. All rights reserved.
//

import UIKit

class CustomNavigationBarItems: UIView {
    var userProfileTapClosure: () -> Void = {  }
    var searchTapClosure: () -> Void = {  }
    var cartTapClosure: () -> Void = {  }

    @IBOutlet weak fileprivate var divider: UIView!
    @IBOutlet weak fileprivate var profileIcon: UIButton!
    
    @IBOutlet weak private var stackviewTrailling: NSLayoutConstraint!
    @IBOutlet weak private var dividertrailing: NSLayoutConstraint!
    @IBOutlet weak fileprivate var centerXConstraints: NSLayoutConstraint!
    @IBOutlet weak fileprivate var notification: UILabel!
    
    @IBOutlet weak fileprivate var buttonAction: UIButton!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    @IBAction func clickAction(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            userProfileTapClosure()
        case 101:
            searchTapClosure()
        case 102:
            cartTapClosure()
        default:
            break
        }
    }
}

extension CustomNavigationBarItems {
    @discardableResult
    func display(isDeviderDisplay shouldDisplay: Bool) -> Self {
        self.divider.isHidden = shouldDisplay
        if shouldDisplay {
            self.dividertrailing.constant = 0
            self.stackviewTrailling.constant = 0
        } else {
            self.dividertrailing.constant = 10
            self.stackviewTrailling.constant = 10
        }
        return self
    }
    
    @discardableResult
    func display(isNotificationDisplay shouldDisplay: Bool) -> Self {
        self.notification.isHidden = shouldDisplay
        
        return self
    }
    
    @discardableResult
    func set(notificationText text: String) -> Self {
        self.notification.text = text
        self.notification.font = FontBook.Bold.of(size: 8)
        self.notification.textColor = ColorConstant.textColorWhite
        return self
    }
    
    @discardableResult
    func set(profileIconImage image: UIImage) -> Self {
        self.profileIcon.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        
        return self
    }
    
    @discardableResult
    func set(centerXConstraints constant: CGFloat) -> Self {
        self.centerXConstraints.constant = constant
        
        return self
    }
    
    @discardableResult
    func set(buttonTag tag: Int) -> Self {
        self.buttonAction.tag = tag
        
        return self
    }
    @discardableResult
    func update(profileIconText text: String) -> Self {
        self.profileIcon.setImage(nil, for: .normal)
        self.profileIcon.setTitle(text, for: .normal)
        self.profileIcon.backgroundColor = ColorConstant.navigationViewColor
        self.profileIcon.layer.cornerRadius = self.profileIcon.frame.width / 2
        self.profileIcon.setTitleColor(.white, for: .normal)
        
        return self
    }
}
