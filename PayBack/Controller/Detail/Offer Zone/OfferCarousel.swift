//
//  OfferCarousel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 3/15/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

final internal class OfferCarousel {
    fileprivate var categoryType: CategoryType = .none
    fileprivate var networkController: OfferZoneNWController!
    
    var carouselErrorHandler: ((String) -> Void) = { _ in }
    var carouselSuccessHandler: (([HeroBannerCellModel]?) -> Void) = { _ in }
    
    init(networkController: OfferZoneNWController, categoryType: CategoryType) {
        self.networkController = networkController
        self.categoryType = categoryType
    }
    
    func fetchCarousel() {
        switch categoryType {
        case .inStoreOffer:
            networkController
                .oncarouselSuccess { [weak self] (carouselData, isExpired) in
                    self?.carouselSuccessHandler(isExpired ? nil : carouselData)
                }
                .onCarouselError { [weak self](error) in
                    print("\(error)")
                    self?.carouselErrorHandler(error)
                }
                .fetchInstoreOffersCarousel()
        case .onlineOffer:
            networkController
                .oncarouselSuccess { [weak self] (carouselData, isExpired) in
                    self?.carouselSuccessHandler(isExpired ? nil : carouselData)
                }
                .onCarouselError { [weak self](error) in
                    print("\(error)")
                    self?.carouselErrorHandler(error)
                }
                .fetchOnlineOffersCarousel()
        case .coupans:
            networkController
                .oncarouselSuccess { [weak self] (carouselData, isExpired) in
                    self?.carouselSuccessHandler(isExpired ? nil : carouselData)
                }
                .onCarouselError { [weak self](error) in
                    print("\(error)")
                    self?.carouselErrorHandler(error)
                }
                .fetchCouponsCarouselData()
        case .recharge:
            networkController
                .oncarouselSuccess { [weak self] (carouselData, isExpired) in
                    self?.carouselSuccessHandler(isExpired ? nil : carouselData)
                }
                .onCarouselError { [weak self] (error) in
                    print("\(error)")
                    self?.carouselErrorHandler(error)
                }
                .fetchRechargeCarouselData()
        default:
            break
        }
    }
}
extension OfferCarousel {
    @discardableResult
    func onCasouselError(error: @escaping ((String) -> Void)) -> Self {
        self.carouselErrorHandler = error
        return self
    }
    @discardableResult
    func onCarouselSuccess(success: @escaping (([HeroBannerCellModel]?) -> Void)) -> Self {
        self.carouselSuccessHandler = success
        return self
    }
}
