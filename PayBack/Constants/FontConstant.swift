//
//  FontConstant.swift
//  PayBack
//
//  Created by Dinakaran M on 06/12/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
import UIKit

enum FontBook: String {
    case Thin = "Roboto-Thin"
    case Light = "Roboto-Light"
    case Regular = "Roboto-Regular"
    case Medium = "Roboto-Medium"
    case Bold = "Roboto-Bold"
    case Black = "Roboto-Black"
    case Italic = "Roboto-Italic"
    case Roboto = "Roboto"
    case Arial = "Arial"
    
    func ofNavigationBarTitleSize() -> UIFont {
         return UIFont(name: self.rawValue, size: 17) ?? UIFont()
    }
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size) ?? UIFont()
    }
    
    func ofSubTitleSize() -> UIFont {
        return UIFont(name: self.rawValue, size: 14) ?? UIFont()
    }
    
    func ofTitleSize() -> UIFont {
        return UIFont(name: self.rawValue, size: 17) ?? UIFont()
    }
    
    func ofHeaderSize() -> UIFont {
        return UIFont(name: self.rawValue, size: 17) ?? UIFont()
    }
    
    func ofSubHeaderSize() -> UIFont {
        return UIFont(name: self.rawValue, size: 16) ?? UIFont()
    }
    func ofDescreptionSize() -> UIFont {
        return UIFont(name: self.rawValue, size: 14) ?? UIFont()
    }
    
    func ofButtonTitleSize() -> UIFont {
        return UIFont(name: self.rawValue, size: (DeviceType.IS_IPAD) ? 15 : 12) ?? UIFont()
    }
    func ofSegmentTapTitleSize() -> UIFont {
        return UIFont(name: self.rawValue, size: 17) ?? UIFont()
    }
    func ofTVCellTitleSize() -> UIFont {
        return UIFont(name: self.rawValue, size: (DeviceType.IS_IPAD) ? 16 : 13) ?? UIFont()
    }
    func ofTVCellSubTitleSize() -> UIFont {
        return UIFont(name: self.rawValue, size: (DeviceType.IS_IPAD) ? 15 : 12) ?? UIFont()
    }
    func ofPopUpHeaderTitleSize() -> UIFont {
        return UIFont(name: self.rawValue, size: 18) ?? UIFont()
    }
    func ofPopUpSubTitleSize() -> UIFont {
        return UIFont(name: self.rawValue, size: 15) ?? UIFont()
    }
    func ofNotificationLabelSize() -> UIFont {
        return UIFont(name: self.rawValue, size: 9) ?? UIFont()
    }
    
    func ofProfileTextField() -> UIFont {
        return UIFont(name: self.rawValue, size: 12) ?? UIFont()
    }
}
