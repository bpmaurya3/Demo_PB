//
//  ShopOnlineViewModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/30/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ShopOnlineViewModel: NSObject {
    var earnPartner: OtherPartner?
    fileprivate var showCaseCategory = [ShowCaseCategory.ShowCaseCategories]()
    
    @objc dynamic fileprivate(set) var carouselViewModel: [HeroBannerCellModel]?
    @objc dynamic fileprivate(set) var bannerViewModel: HeroBannerCellModel?
    @objc dynamic fileprivate(set) var placardViewModel: HeroBannerCellModel?
    @objc dynamic fileprivate(set) var topTrendViewModel: [TopTrendCVCellModel]?
    @objc dynamic fileprivate(set) var shopClickViewModel: [ShopClickCellViewModel]?
    @objc dynamic fileprivate(set) var categoriesViewModel: [ShopClickCellViewModel]?
    @objc dynamic fileprivate(set) var showcaseCategoriesViewModel: [String: [ShowCaseCategoryCellVM]] = [String: [ShowCaseCategoryCellVM]]()
    
    private var carouselObserver: NSKeyValueObservation?
    private var bannerObserver: NSKeyValueObservation?
    private var placardObserver: NSKeyValueObservation?
    private var topTrendObserver: NSKeyValueObservation?
    private var shopClickObserver: NSKeyValueObservation?
    private var categoriesObserver: NSKeyValueObservation?
    private var bestFashionObserver: NSKeyValueObservation?
    private var electronicsObserver: NSKeyValueObservation?
    
    internal var bindToCarouselViewModels: (() -> Void) = { }
    internal var bindToBannerViewModels: (() -> Void) = { }
    internal var bindToPlacardViewModels: (() -> Void) = { }
    internal var bindToTopTrendViewModels: (() -> Void) = { }
    internal var bindToShopClickViewModels: (() -> Void) = { }
    internal var bindToCategoriesViewModels: (() -> Void) = { }
    internal var bindToElectronicsViewModels: (() -> Void) = { }
    internal var bindToShowCaseCategories: (([ShowCaseCategory.ShowCaseCategories]) -> Void) = { _ in }
    
    fileprivate var networkController: ShopOnlineNetworkController
    fileprivate var shopOnlineShowCaseCategoryFetcher: ShopOnlineShowCaseCategoryFetcher!
    
    init(networkController: ShopOnlineNetworkController) {
        self.networkController = networkController
        super.init()
        carouselObserver = self.observe(\.carouselViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToCarouselViewModels()
        })
        
        bannerObserver = self.observe(\.bannerViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToBannerViewModels()
        })
        
        placardObserver = self.observe(\.placardViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToPlacardViewModels()
        })
        
        topTrendObserver = self.observe(\.topTrendViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToTopTrendViewModels()
        })
        
        shopClickObserver = self.observe(\.shopClickViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToShopClickViewModels()
        })
        categoriesObserver = self.observe(\.categoriesViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToCategoriesViewModels()
        })
        
        electronicsObserver = self.observe(\.showcaseCategoriesViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToElectronicsViewModels()
        })
    }
    
    func invalidateObservers() {
        self.carouselObserver?.invalidate()
        self.bannerObserver?.invalidate()
        self.placardObserver?.invalidate()
        self.topTrendObserver?.invalidate()
        self.shopClickObserver?.invalidate()
        self.categoriesObserver?.invalidate()
        self.bestFashionObserver?.invalidate()
        self.electronicsObserver?.invalidate()
    }
}

extension ShopOnlineViewModel {
    
    internal func fetchRefreshable() {
        let when = DispatchTime.now()
        DispatchQueue.global().asyncAfter(deadline: when) {
            self.fetchTopCarousel()
        }
        let when1 = when + 0.15
        DispatchQueue.global().asyncAfter(deadline: when1) {
            self.fetchBanner()
        }
        let when2 = when1 + 0.15
        DispatchQueue.global().asyncAfter(deadline: when2) {
            self.fetchPlaCard()
        }
    }
    
    internal func fetchNonRefreshable() {
        let whenShowCase = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: whenShowCase) { [weak self] in
            self?.fetchShowCaseCategories()
        }
       
        fetchShopClick()
        fetchCategories()
        fetchTopTrend()
    }
    
    func getPartnerDetails(at index: Int) -> OtherPartner.PartnerDetails? {
        guard let partner = earnPartner, let partnerDetails = partner.partnerDetails, partnerDetails.count > index else {
            return nil
        }
        return partnerDetails[index]
    }
    func getShowCaseCategory(at index: Int) -> ShowCaseCategory.ShowCaseCategories? {
        return showCaseCategory.count > index ? showCaseCategory[index] : nil
    }
}

extension ShopOnlineViewModel {
    fileprivate func fetchTopCarousel() {
        networkController
            .onCarouselSuccess { [weak self] (carouselData, isExpired) in
                self?.carouselViewModel = isExpired ? nil : carouselData
            }
            .onCarouselError { (error) in
                print("\(error)")
                self.carouselViewModel = nil
            }
            .fetchTopCarousel()
    }
    
    fileprivate func fetchBanner() {
        self.networkController
            .onBannerSuccess(success: { [weak self] (bannerDataModel, expired) in
                self?.bannerViewModel = expired ? nil : bannerDataModel
            })
            .onBannerError(error: { [weak self] (error) in
                print("\(error)")
                self?.bannerViewModel = nil
            })
            .fetchBanner()
    }
    
    fileprivate func fetchPlaCard() {
        self.networkController
            .onPlaCardSuccess(success: { [weak self] (placardDataModel, expired) in
                self?.placardViewModel = expired ? nil : placardDataModel
            })
            .onPlaCardError(error: { [weak self](error) in
                print("\(error)")
                self?.placardViewModel = nil
            })
            .fetchPlacard()
    }
    
    fileprivate func fetchShopClick() {
        self.networkController
            .onShopClickSuccess(success: { [weak self] (shopClickData, earnPartner) in
                self?.earnPartner = earnPartner
                self?.shopClickViewModel = shopClickData
            })
            .onShopClickError(error: {[weak self] (error) in
                print("\(error)")
                self?.shopClickViewModel = []
            })
            .fetchShopClick()
    }
    fileprivate func fetchCategories() {
        self.networkController
            .onCategoriesSuccess { [weak self] (categories) in
                self?.categoriesViewModel = categories
            }
            .onCategoriesError(error: { [weak self] (error) in
                print("\(error)")
                self?.categoriesViewModel = []
            })
            .fetchCategories()
    }
    
    func fetchTopTrend() {
        self.networkController
            .onTopTrendSuccess(success: { [weak self] (topTrend) in
                self?.topTrendViewModel = topTrend
            })
            .onTopTrendError(error: { [weak self] (error) in
                print("\(error)")
                self?.topTrendViewModel = []
            })
            .fetchTopTrends(parameters: ShopOnlineProductParamsModel(per_page: "3"))
    }
    fileprivate func fetchShowCaseCategories() {
        self.shopOnlineShowCaseCategoryFetcher = ShopOnlineShowCaseCategoryFetcher()
            .onSuccess(success: { [weak self] (showcaseCategory) in
                guard let strongSelf = self, let showcaseCategories = showcaseCategory.showCaseCategories else {
                    self?.bindToShowCaseCategories([])
                    return
                }
                let categories = Array(showcaseCategories[0..<2]) // TODO: If all category required pass "showcaseCategories"
                strongSelf.bindToShowCaseCategories(categories)
                strongSelf.fetchAuthoredShowCaseCategories(categories: categories)
            })
            .onError(error: { [weak self] (error) in
                self?.bindToShowCaseCategories([])
                print("\(error)")
            })
        self.shopOnlineShowCaseCategoryFetcher.fetch()
    }
    
    fileprivate func fetchElectronics(showcaseCategory: ShowCaseCategory.ShowCaseCategories) {
        guard let id = showcaseCategory.categoryID else {
            self.bindToShowCaseCategories([])
            return
        }
        var i = 0
        self.showCaseCategory.append(showcaseCategory)
        let params = ShopOnlineProductParamsModel(id: id)
        self.networkController
            .onElectronicsSuccess(success: { [weak self] (electronicModels) in
                self?.showcaseCategoriesViewModel[(self?.showCaseCategory[i].categoryName)!] = electronicModels
                i += 1
            })
            .onElectronicsError(error: { [weak self] (error) in
                print("\(error)")
                self?.showcaseCategoriesViewModel[(self?.showCaseCategory[i].categoryName)!] = []
                i += 1
            })
            .fetchElectronicsAppliances(params: params)
    }
}
extension ShopOnlineViewModel {
    fileprivate func fetchAuthoredShowCaseCategories(categories: [ShowCaseCategory.ShowCaseCategories]) {
        self.showCaseCategory = categories
        for category in categories {
            self.fetchElectronics(showcaseCategory: category)
        }
    }
}
