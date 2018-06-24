//
//  AdTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 6/5/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdTVCell: UITableViewCell, GADBannerViewDelegate {
    let adID = "ca-app-pub-3940256099942544/2934735716"
    private var cellType: ShopOnlineCellType!
    private var viewController: UIViewController!
    private var adView: GADBannerView!
    private var moduleType: ProductType!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(viewController: UIViewController, moduleType: ProductType, cellType: ShopOnlineCellType, adUnitId: String) {
        self.cellType = cellType
        self.viewController = viewController
        self.moduleType = moduleType
        
        adView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adView.adUnitID = adUnitId
        adView.rootViewController = viewController
        adView.delegate = self
        // Remove previous GADBannerView from the content view before adding a new one.
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        self.contentView.addSubview(adView)
        // Center GADBannerView in the table cell's content view.
        adView.center = self.contentView.center
        
        let adRequest = GADRequest()
        adRequest.testDevices = [ kGADSimulatorID ]
        adView.load(adRequest)
    }
    // MARK: - GADBannerView delegate methods
    
    func adViewDidReceiveAd(_ adView: GADBannerView) {
        // Mark banner ad as succesfully loaded.
        //loadStateForAds[adView] = true
        // Load the next ad in the adsToLoad list.
       // preloadNextAd()
        if moduleType == .earnProduct, let viewController = viewController as? EarnOnlinePartnersVC {
            viewController.loadStateForCell[cellType] = true
        } else if moduleType == .burnProduct, let viewController = viewController as? RewardsCatalogueVC {
            viewController.loadStateForCell[cellType] = true
        }
    }
    
    func adView(_ adView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("Failed to receive ad: \(error.localizedDescription)")
        // Load the next ad in the adsToLoad list.
       // preloadNextAd()
    }

}
