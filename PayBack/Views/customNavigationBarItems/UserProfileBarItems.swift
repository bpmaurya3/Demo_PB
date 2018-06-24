//
//  userProfilename.swift
//  customNavigationController
//
//  Created by Dinakaran M on 04/09/17.
//  Copyright © 2017 Dinakaran M. All rights reserved.
//

import UIKit

class UserProfileBarItems: UIView {
    var userProfileTapClosure: () -> Void = {  }
    @IBOutlet weak fileprivate var clickaction: UIButton!
    @IBOutlet weak fileprivate var userName: UILabel!
    @IBOutlet weak fileprivate var userPoints: UILabel!
    
    @IBAction func tapAction() {
        userProfileTapClosure()
    }
    
}

extension UserProfileBarItems {
    @discardableResult
    func update(username name: String) -> Self {
        self.userName.text = name
        self.userName.textColor = ColorConstant.textColorBlack
        self.userName.font = FontBook.Regular.of(size: 10.5)
        return self
    }
    
    @discardableResult
    func update(userPoints points: String) -> Self {
        self.userPoints.text = points
        self.userPoints.textColor = ColorConstant.textColorPink
        self.userPoints.font = FontBook.Bold.of(size: 10.5)
        return self
    }
}
