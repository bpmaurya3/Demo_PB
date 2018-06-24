//
//  OfferZoneMenuCategory.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 3/15/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
import MapKit

final internal class OfferZoneMenuCategory {
    
    fileprivate var categoryType: CategoryType = .none
    fileprivate var networkController: OfferZoneNWController!
    
    var menuCategoryErrorHandler: ((String) -> Void) = { _ in }
    var menuCategorySuccessHandler: (([SegmentCollectionViewCellModel]) -> Void) = { _ in }
    
    init(networkController: OfferZoneNWController, categoryType: CategoryType) {
        self.networkController = networkController
        self.categoryType = categoryType
    }
    
    func fetchMenuCategory(location: CLLocation?) {
        switch categoryType {
        case .inStoreOffer:
            guard let currentLoc = location else {
                self.menuCategorySuccessHandler([])
                return
            }
            networkController
                .onsegmentTitlesSuccess { [weak self] (segmentTitles) in
                    self?.menuCategorySuccessHandler(segmentTitles)
                }
                .onSegmentTitlesError { [weak self]  (error) in
                    print("\(error)")
                    self?.menuCategoryErrorHandler(error)
                }
                .fetchInstoreOffersSegmentTitles(location: currentLoc.coordinate)
        case .onlineOffer:
            networkController
                .onsegmentTitlesSuccess { [weak self] (segmentTitles) in
                    self?.menuCategorySuccessHandler(segmentTitles)
                }
                .onSegmentTitlesError { [weak self]  (error) in
                    print("\(error)")
                    self?.menuCategoryErrorHandler(error)
                }
                .fetchOnlineOffersSegmentTitles()
        case .coupans:
            networkController
                .onsegmentTitlesSuccess { [weak self] (segmentTitles) in
                    self?.menuCategorySuccessHandler(segmentTitles)
                }
                .onSegmentTitlesError { [weak self]  (error) in
                    print("\(error)")
                    self?.menuCategoryErrorHandler(error)
                }
                .fetchCoupansSegmentTitles()
        case .recharge:
            networkController
                .onsegmentTitlesSuccess { [weak self] (segmentTitles) in
                    self?.menuCategorySuccessHandler(segmentTitles)
                }
                .onSegmentTitlesError { [weak self]  (error) in
                    print("\(error)")
                    self?.menuCategoryErrorHandler(error)
                }
                .fetchRechargeSegmentTitles()
        default:
            break
        }
    }
}
extension OfferZoneMenuCategory {
    @discardableResult
    func onMenuCategoryError(error: @escaping ((String) -> Void)) -> Self {
        self.menuCategoryErrorHandler = error
        return self
    }
    @discardableResult
    func onMenuCategorySuccess(success: @escaping (([SegmentCollectionViewCellModel]) -> Void)) -> Self {
        self.menuCategorySuccessHandler = success
        return self
    }
}
