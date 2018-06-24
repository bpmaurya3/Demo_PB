//
//  RewardsCatalougeVM.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 12/4/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class RewardsCatalougeVM: NSObject {
    @objc dynamic fileprivate(set) var heroCarouselViewModel: [HeroBannerCellModel]?
    @objc dynamic fileprivate(set) var bannerViewModel: HeroBannerCellModel?
    @objc dynamic fileprivate(set) var placardViewModel: HeroBannerCellModel?
    @objc dynamic fileprivate(set) var whatsYourWishViewModel: [ShopClickCellViewModel] = [ShopClickCellViewModel]()
    @objc dynamic fileprivate(set) var recommendedDealsViewModel: [TopTrendCVCellModel] = [TopTrendCVCellModel]()
    @objc dynamic fileprivate(set) var hotDealsViewModel: [TopTrendCVCellModel] = [TopTrendCVCellModel]()
    
    private var heroBannerObserver: NSKeyValueObservation?
    private var bannerObserver: NSKeyValueObservation?
    private var placardObserver: NSKeyValueObservation?
    private var whatsYourWishObserver: NSKeyValueObservation?
    private var recommendedDealsObserver: NSKeyValueObservation?
    private var hotDealsObserver: NSKeyValueObservation?
    
    internal var bindToHeroBannerViewModels: (() -> Void) = { }
    internal var bindToBannerViewModels: (() -> Void) = { }
    internal var bindToPlacardViewModels: (() -> Void) = { }
    internal var bindToWhatsYourWishViewModels: (() -> Void) = { }
    internal var bindToRecommendedDealsViewModels: (() -> Void) = { }
    internal var bindToHotDealsViewModels: (() -> Void) = { }
    
    fileprivate var networkController: RewardCatalogueNetworkController
    
    init(networkController: RewardCatalogueNetworkController) {
        self.networkController = networkController
        super.init()
                
        self.invalidateObservers()
        heroBannerObserver = self.observe(\.heroCarouselViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToHeroBannerViewModels()
        })
        
        bannerObserver = self.observe(\.bannerViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToBannerViewModels()
        })
        
        placardObserver = self.observe(\.placardViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToPlacardViewModels()
        })
        
        whatsYourWishObserver = self.observe(\.whatsYourWishViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToWhatsYourWishViewModels()
        })
        
        recommendedDealsObserver = self.observe(\.recommendedDealsViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToRecommendedDealsViewModels()
        })
        
        hotDealsObserver = self.observe(\.hotDealsViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToHotDealsViewModels()
        })
    }
    
    func invalidateObservers() {
        self.heroBannerObserver?.invalidate()
        self.bannerObserver?.invalidate()
        self.placardObserver?.invalidate()
        self.whatsYourWishObserver?.invalidate()
        self.recommendedDealsObserver?.invalidate()
        self.hotDealsObserver?.invalidate()
    }
    deinit {
        self.invalidateObservers()
        print("RewardsCatalougeVM: deinit called")
    }
}

extension RewardsCatalougeVM {
    
    internal func fetchRefreshable() {
        let when = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.fetchCarouselData()
        }
        let when1 = when + 0.15
        DispatchQueue.main.asyncAfter(deadline: when1) {
            self.fetchBannerImage()
        }
        let when2 = when1 + 0.15
        DispatchQueue.main.asyncAfter(deadline: when2) {
           self.fetchPlacard()
        }
    }
    
    internal func fetchNonRefreshable() {
        fetchWhatsYourWish()
        fetchRecommendedDeals()
        self.fetchHotDealsData()
    }
}

extension RewardsCatalougeVM {
    fileprivate func fetchCarouselData() {
        self.networkController
            .onCarouselSuccess { [weak self] (carouselSlides, isExpired) in
                self?.heroCarouselViewModel = isExpired ? nil : carouselSlides
            }
            .onError { [weak self] (error) in
                print("\(error)")
                self?.heroCarouselViewModel = nil
            }
            .fetchCarouselData()
    }
    
    fileprivate func fetchBannerImage() {
        self.networkController
            .onBannerSuccess { [weak self] (bannerImageModel, expired) in
                self?.bannerViewModel = expired ? nil : bannerImageModel
            }
            .onError {[weak self] (error) in
                print("\(error)")
                self?.bannerViewModel = nil
            }
            .fetchBannerForReward()
    }
    
    fileprivate func fetchPlacard() {
        self.networkController
            .onPlacardSuccess { [weak self] (placardModel, expired) in
               self?.placardViewModel = expired ? nil : placardModel
            }
            .onError { [weak self](error) in
                print("\(error)")
                self?.placardViewModel = nil
            }
            .fetchPlacardForReward()
    }
    
    fileprivate func fetchWhatsYourWish() {
        self.networkController
            .onWhatsYourWishSuccess(success: { [weak self] (categories) in
                self?.whatsYourWishViewModel = categories
            })
            .onError(error: {[weak self] (error) in
                print("\(error)")
                self?.whatsYourWishViewModel = []
            })
            .fetchWhatsYourWish()
    }
    
    func fetchRecommendedDeals() {
        self.networkController
            .onRecommendedDealSuccess(success: { [weak self] (recommendedItems) in
                self?.recommendedDealsViewModel = recommendedItems
            })
            .onError(error: { [weak self] (error) in
                print("\(error)")
                self?.recommendedDealsViewModel = []
            })
            .fetchRecommendedDeals(limit: "3")
    }
    
    fileprivate func fetchHotDealsData() {
        self.networkController
            .onhotDealSuccess(success: { [weak self] (hotItems) in
                self?.hotDealsViewModel = hotItems
            })
            .onError(error: { [weak self] (error) in
                print("\(error)")
                self?.hotDealsViewModel = []
            })
            .fetchHotDeals()
    }
}
