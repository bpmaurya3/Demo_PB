//
//  OfferZoneCategoryDetails.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 3/15/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
import MapKit

final internal class OfferZoneCategoryDetails {
    
    fileprivate var categoryType: CategoryType = .none
    fileprivate var networkController: OfferZoneNWController!
    
    var categoryDetailsErrorHandler: ((String) -> Void) = { _ in }
    var categoryDetailsSuccessHandler: (([CouponsRechargeCellModel], Int) -> Void) = { _, _  in }
    
    init(networkController: OfferZoneNWController, categoryType: CategoryType) {
        self.networkController = networkController
        self.categoryType = categoryType
    }
    
    func fetchCategoryDetails(withCategory categoryTag: String, lastId: Int, location: CLLocation?) {
        switch categoryType {
        case .inStoreOffer:
            guard let currentLoc = location else {
               self.categoryDetailsSuccessHandler([], 0)
                return
            }
            fetchInstoreOffers(categoryTag: categoryTag, location: currentLoc.coordinate)
        case .onlineOffer:
            fetchOnlineOffers(isLoadMore: false, categoryTag: categoryTag, lastId: lastId)
        case .recharge:
            networkController
                .onCouponsDetailsSuccess(success: { [weak self] (couponsDetails) in
                    self?.categoryDetailsSuccessHandler(couponsDetails, 0)
                })
                .onError(error: { [weak self] error in
                    self?.categoryDetailsErrorHandler(error)
                })
                .fetchRechargeDetails(withTag: categoryTag)
        case .coupans:
            fetchCoupons(isLoadMore: false, categoryTag: categoryTag, lastId: lastId)
        default:
            break
        }
    }
    fileprivate func fetchInstoreOffers(categoryTag: String, location: CLLocationCoordinate2D) {
        networkController
            .onCouponsDetailsSuccess(success: { [weak self] (couponsDetails) in
                self?.categoryDetailsSuccessHandler(couponsDetails, 0)
            })
            .onError(error: {[weak self] error in
                self?.categoryDetailsErrorHandler(error)
            })
            .fetchInstoreOffersDetails(withTag: categoryTag, location: location)
    }
    fileprivate func fetchCoupons(isLoadMore: Bool, categoryTag: String, lastId: Int) {
        print("LastId \(lastId)")
        let skip = lastId / 10 + 1
        networkController
            .onOnlineOffersSuccess(success: { [weak self] (couponsDetails, totalCount)  in
                self?.categoryDetailsSuccessHandler(couponsDetails, totalCount)
            })
            .onError(error: { [weak self] error in
                self?.categoryDetailsErrorHandler(error)
            })
            .fetchCouponsDetails(page: "\(skip)", filer: categoryTag == "Top Offers" ? [:] : ["Department": categoryTag])
    }
    fileprivate func fetchOnlineOffers(isLoadMore: Bool, categoryTag: String, lastId: Int) {
        print("LastId \(lastId)")
        let skip = lastId / 10 + 1
        networkController
            .onOnlineOffersSuccess(success: { [weak self] (couponsDetails, totalCount) in
                self?.categoryDetailsSuccessHandler(couponsDetails, totalCount)
            })
            .onError(error: {[weak self] error in
                self?.categoryDetailsErrorHandler(error)
            })
            .fetchOnlineOffersDetails(page: "\(skip)", filer: categoryTag == "Top Offers" ? [:] : ["Department": categoryTag])
    }
}

extension OfferZoneCategoryDetails {
    @discardableResult
    func onCategoryDetailsError(error: @escaping ((String) -> Void)) -> Self {
        self.categoryDetailsErrorHandler = error
        return self
    }
    @discardableResult
    func onCategoryDetailsSuccess(success: @escaping (([CouponsRechargeCellModel], Int) -> Void)) -> Self {
        self.categoryDetailsSuccessHandler = success
        return self
    }
}
