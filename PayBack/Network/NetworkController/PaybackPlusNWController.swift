//
//  PaybackPlusNWController.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/23/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class PaybackPlusNWController {
    let bannerFetcher = BannerFetcher()
    var bannerSuccessHandler: ((HeroBannerCellModel, Bool) -> Void) = { _, _ in }
    var bannerErrorHandler: ((String) -> Void) = { _ in }
    
    fileprivate let exclusiveFetcher = PaybackPlusExclusiveFetcher()
    var exclusiveSuccessHandler: (([ExclusiveBenefitsCVCellModel]) -> Void) = { _ in }
    var exclusiveErrorHandler: ((String) -> Void) = { _ in }
    
    fileprivate let partnersFetcher = CouponsRechargeFetcher()
    var partnersSuccessHandler: (([CouponsRechargeCellModel]) -> Void) = { _ in }
    var partnersErrorHandler: ((String) -> Void) = { _ in }
    
    func fetchBannerImage() {
        bannerFetcher
            .onBannerSuccess { [weak self] (banner, expired) in
                self?.bannerSuccessHandler(banner, expired)
            }
            .onError(error: bannerErrorHandler)
            .fetchBannerForPaybackPlus()
    }
    
    func fetchPayBackPlusPartners() {
        partnersFetcher
            .onSuccess(success: { [weak self](partners) in
                var cellModelArray = [CouponsRechargeCellModel]()
                guard let partnersData = partners.verticalTileGridElements else {
                    self?.partnersSuccessHandler(cellModelArray)
                    return
                }
                for coupon in partnersData {
                    cellModelArray.append(CouponsRechargeCellModel(forRecharge: coupon))
                }
                self?.partnersSuccessHandler(cellModelArray)
            })
            .onError(error: partnersErrorHandler)
            .fetchPaybackPlusPartners()
        //self.partnersSuccessHandler(mockPaybackPlus())
    }
    
    func fetchPaybackPlusExclusive() {
        exclusiveFetcher
            .onSuccess {[weak self] (exclusives) in
                var cellModelArray = [ExclusiveBenefitsCVCellModel]()
                guard let exclusiveData = exclusives.iconDescGridView else {
                    self?.exclusiveSuccessHandler(cellModelArray)
                    return
                }
                for exclusive in exclusiveData {
                    cellModelArray.append(ExclusiveBenefitsCVCellModel(withExclusiveData: exclusive))
                }
                self?.exclusiveSuccessHandler(cellModelArray)

        }
        .onError(error: exclusiveErrorHandler)
        .fetchPaybackPlusExclusive()
    }
}

extension PaybackPlusNWController {
    @discardableResult
    func onBannerImageSuccess(success: @escaping ((HeroBannerCellModel, Bool) -> Void)) -> Self {
        
        self.bannerSuccessHandler = success
        
        return self
    }
    
    @discardableResult
    func onBannerImageError(error: @escaping ((String) -> Void)) -> Self {
        
        self.bannerErrorHandler = error
        
        return self
    }
    
    @discardableResult
    func onExclusiveSuccess(success: @escaping (([ExclusiveBenefitsCVCellModel]) -> Void)) -> Self {
        
        self.exclusiveSuccessHandler = success
        
        return self
    }
    
    @discardableResult
    func onExclusiveError(error: @escaping ((String) -> Void)) -> Self {
        
        self.exclusiveErrorHandler = error
        
        return self
    }
    
    @discardableResult
    func onpartnersSuccess(success: @escaping (([CouponsRechargeCellModel]) -> Void)) -> Self {
        
        self.partnersSuccessHandler = success
        
        return self
    }
    
    @discardableResult
    func onpartnersError(error: @escaping ((String) -> Void)) -> Self {
        
        self.partnersErrorHandler = error
        
        return self
    }
}

extension PaybackPlusNWController {
    func mockPaybackPlus() -> [CouponsRechargeCellModel] {
        let data1 = CouponsRechargeCellModel(forOnlineOffers: #imageLiteral(resourceName: "Sample_4"), title: "Snapdeal", subTitle: "Furnish your bachelor's pad up to 60% off Furnish your bachelor's pad up to 60% off", partnerOffer: "Earn upto 3 points per Rs. 100 spent Earn upto 3 points per Rs. 100 spent")
        let data2 = CouponsRechargeCellModel(forOnlineOffers: #imageLiteral(resourceName: "Sample_4"), title: "Snapdeal", subTitle: "Furnish your bachelor's pad up to 60% off Furnish your bachelor's pad up to 60% off", partnerOffer: "Earn upto 3 points per Rs. 100 spent Earn upto 3 points per Rs. 100 spent")
        let data3 = CouponsRechargeCellModel(forOnlineOffers: #imageLiteral(resourceName: "Sample_4"), title: "Snapdeal", subTitle: "Furnish your bachelor's pad up to 60% off Furnish your bachelor's pad up to 60% off", partnerOffer: "Earn upto 3 points per Rs. 100 spent Earn upto 3 points per Rs. 100 spent")
        let data4 = CouponsRechargeCellModel(forOnlineOffers: #imageLiteral(resourceName: "Sample_4"), title: "Snapdeal", subTitle: "Furnish your bachelor's pad up to 60% off Furnish your bachelor's pad up to 60% off", partnerOffer: "Earn upto 3 points per Rs. 100 spent Earn upto 3 points per Rs. 100 spent")
        let data5 = CouponsRechargeCellModel(forOnlineOffers: #imageLiteral(resourceName: "Sample_4"), title: "Snapdeal", subTitle: "Furnish your bachelor's pad up to 60% off Furnish your bachelor's pad up to 60% off", partnerOffer: "Earn upto 3 points per Rs. 100 spent Earn upto 3 points per Rs. 100 spent")
        
        return [data1, data2, data3, data4, data5]
    }
}
