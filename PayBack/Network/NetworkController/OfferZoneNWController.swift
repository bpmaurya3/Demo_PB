//
//  OfferZoneNWController.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/30/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
import MapKit

final internal class OfferZoneNWController {
    
    var errorHandler: ((String) -> Void) = { _ in }
    
    fileprivate lazy var carouselFetcher: CarouselFetcher = {
        return CarouselFetcher()
    }()
    var carouselSuccessHandler: (([HeroBannerCellModel], Bool) -> Void) = { _, _ in }
    var carouselErrorHandler: ((String) -> Void) = { _ in }
    
    fileprivate let segmentTitlesFetcher = SegmentTitlesFetcher()
    var segmentTitlesSuccessHandler: (([SegmentCollectionViewCellModel]) -> Void) = { _ in }
    var segmentTitlesErrorHandler: ((String) -> Void) = { _ in }
    
    fileprivate let couponsRechargeFetcher = CouponsRechargeFetcher()
    var detailsSuccessHandler: (([CouponsRechargeCellModel]) -> Void) = { _ in }
    var onlineOffersSuccessHandler: (([CouponsRechargeCellModel], Int) -> Void) = { _, _  in }
    var detailsErrorHandler: ((String) -> Void) = { _ in }

    let tilesGridFetcher = LandingTilesGridFetcher()
    var tilesGridSuccessHandler: (([LandingTilesGridCellModel]) -> Void) = { _ in }
    
    let onlineOffersFetcher = OnlineOffersFetcher()
    let couponsFetcher = CouponsFetcher()
    let inStoreListFetcher = InStoreListFetcher()
    // MARK: Coupons
    func fetchCoupansSegmentTitles() {
        segmentTitlesFetcher
            .onSuccess { [weak self](categories) in
                var cellModelArray = [SegmentCollectionViewCellModel]()
                guard let categories = categories.departments else {
                    self?.segmentTitlesSuccessHandler(cellModelArray)
                    return
                }
                for category in categories {
                    cellModelArray.append(SegmentCollectionViewCellModel(withCouponsCategory: category))
                }
                self?.segmentTitlesSuccessHandler(cellModelArray)
            }
            .onError(error: segmentTitlesErrorHandler)
            .fetchCouponsCategories()
    }
    
    func fetchCouponsCarouselData() {
        carouselFetcher
            .onSuccess { [weak self] (carousel, expired) in
                self?.carouselSuccessHandler(carousel, expired)
            }
            .onError(error: carouselErrorHandler)
            .fetchCouponsCarousel()
    }
    func fetchCouponsDetails(page: String, filer: [String: String]) {
        couponsFetcher
            .onSuccess(success: { [weak self](coupons) in
                let totalCount = coupons.latestCouponCount ?? 0
                var cellModelArray = [CouponsRechargeCellModel]()
                guard let coupons = coupons.latestCoupons else {
                    self?.onlineOffersSuccessHandler(cellModelArray, totalCount)
                    return
                }
                for coupon in coupons {
                    cellModelArray.append(CouponsRechargeCellModel(forCouponData: coupon))
                }
                self?.onlineOffersSuccessHandler(cellModelArray, totalCount)
            })
            .onError(error: errorHandler)
            .fetchCoupons(page: page, filer: filer)
    }
    
    // MARK: Recharge
    func fetchRechargeSegmentTitles() {
        segmentTitlesFetcher
            .onSuccess { [weak self](categories) in
                var cellModelArray = [SegmentCollectionViewCellModel]()
                guard let categories = categories.categories else {
                    self?.segmentTitlesSuccessHandler(cellModelArray)
                    return
                }
                for category in categories {
                    cellModelArray.append(SegmentCollectionViewCellModel(withRechargeCategory: category))
                }
                self?.segmentTitlesSuccessHandler(cellModelArray)
            }
            .onError(error: segmentTitlesErrorHandler)
            .fetchRechargeCategories()
    }
    
    func fetchRechargeCarouselData() {
        carouselFetcher
            .onSuccess { [weak self] (carousel, expired) in
                self?.carouselSuccessHandler(carousel, expired)
            }
            .onError(error: carouselErrorHandler)
            .fetchRechargeCarousel()
    }
    
    func fetchRechargeDetails(withTag tag: String) {
        couponsRechargeFetcher
            .onSuccess(success: { [weak self](coupons) in
                var cellModelArray = [CouponsRechargeCellModel]()
                guard let rechargeData = coupons.tileGridElements else {
                    self?.detailsSuccessHandler(cellModelArray)
                    return
                }
                for recharge in rechargeData {
                    cellModelArray.append(CouponsRechargeCellModel(forRecharge: recharge))
                }
                self?.detailsSuccessHandler(cellModelArray)
            })
            .onError(error: errorHandler)
            .fetchRechargeDetails(tag: tag)
    }
  
    // MARK: Instore Offers
    func fetchInstoreOffersCarousel() {
        carouselFetcher
            .onSuccess { [weak self] (carousel, expired) in
                self?.carouselSuccessHandler(carousel, expired)
            }
            .onError(error: carouselErrorHandler)
            .fetchInstoreOffersCarousel()
    }
    
    func fetchInstoreOffersSegmentTitles(location: CLLocationCoordinate2D) {
        let filter = StoreLocaterFilterParameters(category: nil, city: nil, partner: nil)
        inStoreListFetcher
            .onSuccess(success: {[weak self] (storelistModel) in
                var cellModelArray = [SegmentCollectionViewCellModel]()
                guard let fiters = storelistModel.filters, let categories = fiters.first(where: { $0.displayName == "Category" }), let facets = categories.facets else {
                    self?.segmentTitlesSuccessHandler(cellModelArray)
                    return
                }
                for category in facets {
                    cellModelArray.append(SegmentCollectionViewCellModel(title: category.name!))
                }
                self?.segmentTitlesSuccessHandler(cellModelArray)
            })
            .onError(error: segmentTitlesErrorHandler)
            .getInStoreListNear(lattitude: "\(location.latitude)", longitude: "\(location.longitude)", filterParams: filter)
//        segmentTitlesFetcher
//            .onSuccess { [weak self](categories) in
//                var cellModelArray = [SegmentCollectionViewCellModel]()
//                guard let categories = categories.categories else {
//                    self?.segmentTitlesSuccessHandler(cellModelArray)
//                    return
//                }
//                for category in categories {
//                    cellModelArray.append(SegmentCollectionViewCellModel(withInstoreOffersCategory: category))
//                }
//                self?.segmentTitlesSuccessHandler(cellModelArray)
//            }
//            .onError(error: errorHandler)
//            .fetchInstoreOffersCategories()
    }
    
    func fetchInstoreOffersDetails(withTag tag: String, location: CLLocationCoordinate2D) {
        let filter = StoreLocaterFilterParameters(category: tag, city: nil, partner: nil)
        inStoreListFetcher
            .onSuccess(success: {[weak self] (storelistModel) in
                var cellModelArray = [CouponsRechargeCellModel]()
                guard let strongSelf = self, let deals = storelistModel.deals else {
                    self?.detailsSuccessHandler(cellModelArray)
                    return
                }
                for deal in deals {
                    cellModelArray.append(CouponsRechargeCellModel(instoreOffers: deal))
                }
                
                strongSelf.detailsSuccessHandler(cellModelArray)
            })
            .onError(error: errorHandler)
            .getInStoreListNear(lattitude: "\(location.latitude)", longitude: "\(location.longitude)", filterParams: filter)
        
//        couponsRechargeFetcher
//            .onSuccess(success: { [weak self](inStoreOffers) in
//                var cellModelArray = [CouponsRechargeCellModel]()
//                guard let inStoreOffers = inStoreOffers.tileGridElements else {
//                    self?.detailsSuccessHandler(cellModelArray)
//                    return
//                }
//                for inStoreOffer in inStoreOffers {
//                    cellModelArray.append(CouponsRechargeCellModel(forRecharge: inStoreOffer))
//                }
//                self?.detailsSuccessHandler(cellModelArray)
//            })
//            .onError(error: errorHandler)
//            .fetchInstoreOffersDetails(tag: tag)
    }
    
    // Online Offers
    
    func fetchOnlineOffersCarousel() {
        carouselFetcher
            .onSuccess { [weak self] (carousel, expired) in
                self?.carouselSuccessHandler(carousel, expired)
            }
            .onError(error: carouselErrorHandler)
            .fetchOnlineOffersCarousel()
    }
    
    func fetchOnlineOffersSegmentTitles() {
        onlineOffersFetcher
            .onSuccess { [weak self] (onlineOffersModel) in
                var cellModelArray = [SegmentCollectionViewCellModel]()
                guard let categories = onlineOffersModel.offerzoneDeals?.filters else {
                    self?.segmentTitlesSuccessHandler(cellModelArray)
                    return
                }
                // swiftlint:disable first_where
                let departMents = categories.filter({ $0.displayName == "Department" }).first
                guard let values = departMents?.values else {
                    self?.segmentTitlesSuccessHandler(cellModelArray)
                    return
                }
                // swiftlint:enable first_where
                cellModelArray.append(SegmentCollectionViewCellModel(withOnlineOffersFilters: "Top Offers"))
                for category in values {
                    cellModelArray.append(SegmentCollectionViewCellModel(withOnlineOffersFilters: category))
                }
                self?.segmentTitlesSuccessHandler(cellModelArray)
            }
            .onError { [weak self] (error) in
                print("\(error)")
                self?.segmentTitlesErrorHandler(error)
            }
            .fetchOnlineOffers(page: "1", per_page: "1", filer: [:])
    }
    
    func fetchOnlineOffersDetails(page: String, filer: [String: String]) {
        onlineOffersFetcher
            .onSuccess { [weak self] (onlineOffersModel) in
                let totalCount = onlineOffersModel.offerzoneDeals?.totalCount ?? 0
                var cellModelArray = [CouponsRechargeCellModel]()
                guard let onlineOffers = onlineOffersModel.offerzoneDeals?.results else {
                    self?.onlineOffersSuccessHandler(cellModelArray, totalCount)
                    return
                }
                for result in onlineOffers {
                    cellModelArray.append(CouponsRechargeCellModel(forOnlineOffers: result))
                }
                self?.onlineOffersSuccessHandler(cellModelArray, totalCount)
            }
            .onError { (error) in
                print("\(error)")
                self.detailsErrorHandler(error)
            }
            .fetchOnlineOffers(page: page, filer: filer)
    }
    // Offer Zone Landing
    func offerCarousel() {
        carouselFetcher
            .onSuccess { [weak self] (carousel, expired) in
                self?.carouselSuccessHandler(carousel, expired)
            }
            .onError(error: carouselErrorHandler)
            .fetchOffersCarousel()
    }
    
    func fetchOfferZoneGrid() {
        tilesGridFetcher
            .onSuccess { [weak self] (tiles) in
                self?.tilesGridSuccessHandler(tiles)
            }
            .onError(error: errorHandler)
            .fetchOfferGrid()
    }
    
    func fetchLandingOffers() {
        couponsRechargeFetcher
            .onSuccess(success: { [weak self](offers) in
                var cellModelArray = [CouponsRechargeCellModel]()
                guard let landingOffers = offers.verticalTileGridElements else {
                    self?.detailsSuccessHandler(cellModelArray)
                    return
                }
                for offer in landingOffers {
                    cellModelArray.append(CouponsRechargeCellModel(forRecharge: offer))
                }
                self?.detailsSuccessHandler(cellModelArray)
            })
            .onError(error: errorHandler)
            .fetchLandingOffers()
    }
    
}

extension OfferZoneNWController {
    
    @discardableResult
    func onError(error: @escaping ((String) -> Void)) -> Self {
        self.errorHandler = error
        return self
    }
    @discardableResult
    func oncarouselSuccess(success: @escaping (([HeroBannerCellModel], Bool) -> Void)) -> Self {
        self.carouselSuccessHandler = success
        return self
    }
    @discardableResult
    func onCarouselError(error: @escaping ((String) -> Void)) -> Self {
        self.carouselErrorHandler = error
        return self
    }
    @discardableResult
    func onsegmentTitlesSuccess(success: @escaping (([SegmentCollectionViewCellModel]) -> Void)) -> Self {
        self.segmentTitlesSuccessHandler = success
        return self
    }
    @discardableResult
    func onSegmentTitlesError(error: @escaping ((String) -> Void)) -> Self {
        self.segmentTitlesErrorHandler = error
        return self
    }
    @discardableResult
    func onCouponsDetailsSuccess(success: @escaping (([CouponsRechargeCellModel]) -> Void)) -> Self {
        self.detailsSuccessHandler = success
        return self
    }
    @discardableResult
    func onOnlineOffersSuccess(success: @escaping (([CouponsRechargeCellModel], Int) -> Void)) -> Self {
        self.onlineOffersSuccessHandler = success
        return self
    }
    
    @discardableResult
    func onCouponsDetailsError(error: @escaping ((String) -> Void)) -> Self {
        self.detailsErrorHandler = error
        return self
    }
    @discardableResult
    func onTilesGridSuccess(success: @escaping (([LandingTilesGridCellModel]) -> Void)) -> Self {
        self.tilesGridSuccessHandler = success
        return self
    }
}

extension OfferZoneNWController {
     func mockSegmentTitles() -> [SegmentCollectionViewCellModel] {
        let segmentTitle1 = SegmentCollectionViewCellModel(title: "Top Offers", itemId: 0)
        let segmentTitle2 = SegmentCollectionViewCellModel(title: "Food", itemId: 1)
        let segmentTitle3 = SegmentCollectionViewCellModel(title: "Grocery", itemId: 2)
        let segmentTitle4 = SegmentCollectionViewCellModel(title: "Apparels", itemId: 3)
        let segmentTitle5 = SegmentCollectionViewCellModel(title: "Electronics", itemId: 4)
        
        let titles =  [segmentTitle1, segmentTitle2, segmentTitle3, segmentTitle4, segmentTitle5]
        
        return titles
    }
    
     func mockCarouselData() -> [HeroBannerCellModel] {
        let slide = HeroBannerCellModel(image: #imageLiteral(resourceName: "camera"))
        let slide1 = HeroBannerCellModel(image: #imageLiteral(resourceName: "camera"))
        let slide2 = HeroBannerCellModel(image: #imageLiteral(resourceName: "demo2"))
        let slide3 = HeroBannerCellModel(image: #imageLiteral(resourceName: "demo"))
        let slide4 = HeroBannerCellModel(image: #imageLiteral(resourceName: "demo2"))
        let slides = [slide, slide1, slide2, slide3, slide4]
        return slides
    }
    
    func mockHelpCenterSegmentTitles() -> [SegmentCollectionViewCellModel] {
            let segmentTitle1 = SegmentCollectionViewCellModel(image: #imageLiteral(resourceName: "White"), title: "Account\nInformation", itemId: 0)
            let segmentTitle2 = SegmentCollectionViewCellModel(image: #imageLiteral(resourceName: "White"), title: "Pin\nEnquiry", itemId: 1)
            let segmentTitle3 = SegmentCollectionViewCellModel(image: #imageLiteral(resourceName: "White"), title: "Card\nRelated", itemId: 2)
            let segmentTitle4 = SegmentCollectionViewCellModel(image: #imageLiteral(resourceName: "White"), title: "Earning\nPoints", itemId: 3)
            let segmentTitle5 = SegmentCollectionViewCellModel(image: #imageLiteral(resourceName: "White"), title: "Reediming\nPoints", itemId: 4)
            let segmentTitle6 = SegmentCollectionViewCellModel(image: #imageLiteral(resourceName: "White"), title: "Partner\nInformation", itemId: 5)
            let segmentTitle7 = SegmentCollectionViewCellModel(image: #imageLiteral(resourceName: "White"), title: "Transactions", itemId: 6)
            let segmentTitle8 = SegmentCollectionViewCellModel(image: #imageLiteral(resourceName: "White"), title: "Coupons", itemId: 4)
            let segmentTitle9 = SegmentCollectionViewCellModel(image: #imageLiteral(resourceName: "White"), title: "Promotions", itemId: 8)
            let segmentTitle10 = SegmentCollectionViewCellModel(image: #imageLiteral(resourceName: "White"), title: "Others", itemId: 9)
            
            let titles =  [segmentTitle1, segmentTitle2, segmentTitle3, segmentTitle4, segmentTitle5, segmentTitle6, segmentTitle7, segmentTitle8, segmentTitle9, segmentTitle10]
            
            return titles
    }
}
