//
//  ExSlideViewController.swift
//  PayBack
//
//  Created by Dinakaran M on 31/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ExSlideViewController: SlideMenuController {
    
    override func isTagetViewController() -> Bool {
        if let vc = UIApplication.topViewController() {
            if  vc is ExtendedHomeVC ||
                vc is EarnLandingVC ||
                vc is BurnLandingVC ||
                vc is ExploreLandingVC ||
                vc is EarnBaseOnlinePartnersVC ||
                vc is InStorePartnersVC ||
                vc is RedirectionVC ||
                vc is PartnerDetailsVC ||
                vc is ProductListVC ||
                vc is EarnOnlinePartnersVC ||
                vc is OtherOnlinePartnersVC {
                return true
            }
        }
        return false
    }
    
    override func track(_ trackAction: TrackAction) {
        switch trackAction {
        case .leftTapOpen:
            print("TrackAction: left tap open.")
        case .leftTapClose:
            print("TrackAction: left tap close.")
        case .leftFlickOpen:
            print("TrackAction: left flick open.")
        case .leftFlickClose:
            print("TrackAction: left flick close.")
        case .rightTapOpen:
            print("TrackAction: right tap open.")
        case .rightTapClose:
            print("TrackAction: right tap close.")
        case .rightFlickOpen:
            print("TrackAction: right flick open.")
        case .rightFlickClose:
            print("TrackAction: right flick close.")
        }
    }
}
