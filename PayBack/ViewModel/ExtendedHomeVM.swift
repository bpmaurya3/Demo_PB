//
//  ExtendedHomeVM.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 5/16/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
import MapKit
import GoogleMaps
import GooglePlaces

class ExtendedHomeVM: NSObject {
    var errorHandler: () -> Void = {}
    fileprivate var homeFetcher: HomeFetcher
    fileprivate var trendingDealFetcher: TopTrendFetcher
    fileprivate var nearbuyOffersFetcher: InStoreListFetcher
    fileprivate var recommendedDealFetcher: BurnProductListFetcher
    fileprivate var shopOnlinePartnerFetcher = OnlinePartnerFetcher()

    @objc dynamic fileprivate(set) var homeAEMContentViewModel: HomeModel?
    @objc dynamic fileprivate(set) var trendingViewModel: [HomeShowCaseCVCellModel]?
    @objc dynamic fileprivate(set) var nearbuyOffersViewModel: [InstoreListTVCellModel]?
    @objc dynamic fileprivate(set) var recommendedDealsViewModel: [HomeShowCaseCVCellModel]?
    @objc dynamic fileprivate(set) var onlinePartnersViewModel: [HomeShowCaseCVCellModel]?
   
    private var homeAEMContentObserver: NSKeyValueObservation?
    private var trendingObserver: NSKeyValueObservation?
    private var recommenedDealObserver: NSKeyValueObservation?
    private var nearbuyOffersObserver: NSKeyValueObservation?
    private var onlinePartnersObserver: NSKeyValueObservation?
   
    var bindToHomeAEMContentViewModels: (() -> Void) = { }
    var bindToTrendingViewModels: (() -> Void) = { }
    var bindToRecommenedDealViewModels: (() -> Void) = { }
    var bindToNearbuyOffersViewModels: (() -> Void) = { }
    var bindToOnlinePartnersViewModels: (() -> Void) = { }
   
    var onlinePartner: OtherPartner?

    override init() {
        trendingDealFetcher = TopTrendFetcher()
        nearbuyOffersFetcher = InStoreListFetcher()
        recommendedDealFetcher = BurnProductListFetcher()
        shopOnlinePartnerFetcher = OnlinePartnerFetcher()
        homeFetcher = HomeFetcher()
        
        super.init()
       
        homeAEMContentObserver = self.observe(\.homeAEMContentViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToHomeAEMContentViewModels()
        })
        trendingObserver = self.observe(\.trendingViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToTrendingViewModels()
        })
        recommenedDealObserver = self.observe(\.recommendedDealsViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToRecommenedDealViewModels()
        })
        nearbuyOffersObserver = self.observe(\.nearbuyOffersViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToNearbuyOffersViewModels()
        })
        onlinePartnersObserver = self.observe(\.onlinePartnersViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToOnlinePartnersViewModels()
        })
    }
}
extension ExtendedHomeVM {
    func refresh() {
         fetchHomeAEMContent()
    }
    fileprivate func fetchHomeAEMContent() {
        homeFetcher
            .onSuccess {[weak self] (homeModel) in
                self?.homeAEMContentViewModel = homeModel
            }
            .onError { [weak self](error) in
                print(error)
                self?.homeAEMContentViewModel = nil
                self?.errorHandler()
            }
            .getHomeContent()
    }
    func fetchShopOnlinePartners() {
        shopOnlinePartnerFetcher
            .onSuccess(success: { [weak self] (otherPartnerData) in
                
                var cellModelArray = [HomeShowCaseCVCellModel]()
                guard let tiles = otherPartnerData.partnerDetails else {
                    return
                }
                for earnPartner in tiles {
                    cellModelArray.append(HomeShowCaseCVCellModel(withOnlinePartner: earnPartner))
                }
                self?.onlinePartnersViewModel = cellModelArray
                self?.onlinePartner = otherPartnerData
            })
            .onError(error: {[weak self](error) in
                print(error)
                self?.onlinePartnersViewModel = []
            })
            .fetch(onlinePartnerFor: .earnPartner)
    }
    func fetchTopTrends(parameters params: ShopOnlineProductParamsModel) {
        trendingDealFetcher
            .onSuccess { [weak self](topTrend) in
                var cellModelArray = [HomeShowCaseCVCellModel]()
                guard let trendings = topTrend.results else {
                    return
                }
                for trend in trendings {
                    cellModelArray.append(HomeShowCaseCVCellModel(withTopTrend: trend))
                }
                self?.trendingViewModel = cellModelArray
            }
            .onError { [weak self] (error) in
                print(error)
                self?.trendingViewModel = []
            }
            .fetchTopTrend(withParams: params)
    }
    
    func fetchInStoreListNear(currentLocation location: CLLocationCoordinate2D) {
        let filter = StoreLocaterFilterParameters(category: nil, city: nil, partner: nil)
        nearbuyOffersFetcher
            .onSuccess(success: {[weak self] (storelistModel) in
                var cellModelArray = [InstoreListTVCellModel]()
                guard let deals = storelistModel.deals, !deals.isEmpty else {
                    return
                }
                for deal in deals[0..<10] {
                    cellModelArray.append(InstoreListTVCellModel(withStoreDeal: deal))
                }
                self?.nearbuyOffersViewModel = cellModelArray
            })
            .onError(error: {[weak self] (error) in
                print(error)
                self?.nearbuyOffersViewModel = []
            })
            .getInStoreListNear(lattitude: "\(location.latitude)", longitude: "\(location.longitude)", filterParams: filter)
        
    }
    
    internal func fetchRecommendedDeals(limit: String) {
        let params = BurnProductParamsModel(limit: limit, categoryPath: "recommended-deals")
        
        recommendedDealFetcher
            .onSuccess(success: { [weak self](redeemProduct) in
                var cellModelArray = [HomeShowCaseCVCellModel]()
                guard let results = redeemProduct.result else {
                    return
                }
                for result in results {
                    cellModelArray.append(HomeShowCaseCVCellModel(withRedeemProductItem: result))
                }
                self?.recommendedDealsViewModel = cellModelArray
            })
            .onError(error: {[weak self] (error) in
                print(error)
                self?.recommendedDealsViewModel = []
            })
            .fetchProductList(withParams: params)
    }
    
}
extension ExtendedHomeVM {
    func setNilToNearbyOffers() {
        self.nearbuyOffersViewModel = nil
    }
    func getHeaderCongifuration() -> HeaderInfo {
        guard let homeMdel = self.homeAEMContentViewModel, let homeContent = homeMdel.appHome, let headerInfo = homeContent.headerInfo  else {
            return HeaderInfo(headerTextColor: "#FFFFFF", headerBGColor: "#005ea4", headerBarCodeIcon: "", headerNonLogInTxt: "Welcome!", headerNonLogInDescTxt: "Enter the world of rewarding journey")
        }
        return headerInfo
    }
    func getImageGrid() -> [LandingTilesGridCellModel] {
        var cellModelArray = [LandingTilesGridCellModel]()
        guard let homeMdel = self.homeAEMContentViewModel, let homeContent = homeMdel.appHome, let  imageGridContent = homeContent.navigationSections  else {
            return cellModelArray
        }
        for imageGrid in imageGridContent {
            cellModelArray.append(LandingTilesGridCellModel(withImageGridData: imageGrid))
        }
        return cellModelArray
    }
    
    func getShowCaseContent() -> [ShowCaseTuple] {
        guard let homeMdel = self.homeAEMContentViewModel, let homeContent = homeMdel.appHome, let  showcaseContent = homeContent.showcaseList  else {
            return []
        }
        
        var contents = [ShowCaseTuple]()
        for content in showcaseContent {
            var cellModelArray = [HeroBannerCellModel]()
            if let carouselElements = content.showcaseCarousel {
                for carousel in carouselElements {
                    cellModelArray.append(HeroBannerCellModel(withAuthCarouselElmts: carousel))
                }
            }
            var instantVouchers = [HomeShowCaseCVCellModel]()
            if let showcaseGrid = content.showcaseGrid {
                for grid in showcaseGrid {
                    instantVouchers.append(HomeShowCaseCVCellModel(withInstantVoucher: grid))
                }
            }
            contents.append(ShowCaseTuple(instantVouchers, cellModelArray, content.title ?? "", content.channelType ?? ""))
        }
        return contents
    }
}
