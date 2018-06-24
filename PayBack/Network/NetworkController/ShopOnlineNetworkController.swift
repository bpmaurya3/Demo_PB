//
//  ShopOnlineNetworkController.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class ShopOnlineNetworkController {
    
    fileprivate lazy var carouselFetcher: CarouselFetcher = {
        return CarouselFetcher()
    }()
    fileprivate var carouselSuccessHandler: (([HeroBannerCellModel], Bool) -> Void) = { _, _ in }
    fileprivate var carouselErrorHandler: ((String) -> Void) = { _ in }
    
    typealias BannerSuccess = ((HeroBannerCellModel, Bool) -> Void)
    fileprivate let bannerFetcher = BannerFetcher()
    fileprivate var bannerSuccessHandler: BannerSuccess = { _, _ in }
    fileprivate var bannerErrorHandler: ((String) -> Void) = { _ in }
    
    fileprivate let placardFetcher = PlacardFetcher()
    fileprivate var placardSuccessHandler: BannerSuccess = { _, _ in }
    fileprivate var placardErrorHandler: ((String) -> Void) = { _ in }
    
    fileprivate let topTrendFetcher = TopTrendFetcher()
    fileprivate var topTrendSuccessHandler: (([TopTrendCVCellModel]) -> Void) = { _ in }
    fileprivate var topTrendErrorHandler: ((String) -> Void) = { _ in }
    
    fileprivate let otherOnlinePartnerFetcher = OnlinePartnerFetcher()
    fileprivate var shopClickSuccessHandler: (([ShopClickCellViewModel], OtherPartner) -> Void) = { _, _ in }
    fileprivate var shopClickErrorHandler: ((String) -> Void) = { _ in }
    
    fileprivate let categoriesFetcher = CategoriesFetcher()
    fileprivate var categoriesSuccessHandler: (([ShopClickCellViewModel]) -> Void) = { _ in }
    fileprivate var categoriesErrorHandler: ((String) -> Void) = { _ in }
    
    fileprivate let bestInFashionProductListFetcher = ShowCaseCategoryFetcher()
    fileprivate var bestFashionSuccessHandler: (([ShowCaseCategoryCellVM]) -> Void) = { _ in }
    fileprivate var bestFashionErrorHandler: ((String) -> Void) = { _ in }
    
    fileprivate let electronicsProductListFetcher = ShopOnlineCategoriesProductListFetcher()
    fileprivate var electronicsSuccessHandler: (([ShowCaseCategoryCellVM]) -> Void) = { _ in }
    fileprivate var electronicsErrorHandler: ((String) -> Void) = { _ in }

    internal func fetchTopCarousel() {
        carouselFetcher
            .onSuccess { [weak self] (carousel, expired) in
                self?.carouselSuccessHandler(carousel, expired)
            }
            .onError(error: carouselErrorHandler)
            .fetchCarouselForShopOnline()
       
    }
    
    internal func fetchBanner() {
        bannerFetcher
            .onBannerSuccess(success: { [weak self] (banner, expired) in
                self?.bannerSuccessHandler(banner, expired)
            })
            .onError(error: bannerErrorHandler)
            .fetchBannerForShopOnline()
    }
    
    internal func fetchPlacard() {
        placardFetcher
            .onPlacardSuccess(success: { [weak self] (placard, expired) in
                self?.placardSuccessHandler(placard, expired)
            })
            .onError(error: placardErrorHandler)
            .fetchPlacardForShopOnline()
    }
    
    internal func fetchShopClick() {
        //self.shopClickSuccessHandler(mockShopClick())
            otherOnlinePartnerFetcher
                .onSuccess(success: { [weak self] (otherPartnerData) in
                    
                    var cellModelArray = [ShopClickCellViewModel]()
                    guard let tiles = otherPartnerData.partnerDetails else {
                        return
                    }
                    for earnPartner in tiles {
                        cellModelArray.append(ShopClickCellViewModel(withParners: earnPartner))
                    }
                    self?.shopClickSuccessHandler(cellModelArray, otherPartnerData)
                })
                .onError(error: { [weak self] (error) in
                    self?.shopClickErrorHandler(error)
                })
                .fetch(onlinePartnerFor: .earnPartner)
    }
    
//    internal func fetchInsuranceClick(boundTo cell: CategoriesTVCell) {
//        cell.cellModel = mockInsuranceClick()
//    }
//
    internal func fetchCategories() {
        //self.categoriesSuccessHandler(mockCategories())
        self.categoriesFetcher
            .onSuccess { (categories) in
                var cellModelArray = [ShopClickCellViewModel]()
                guard let categories = categories.category else {
                    self.categoriesSuccessHandler(cellModelArray)
                    return
                }
                for category in categories {
                    cellModelArray.append(ShopClickCellViewModel(withShopOnlineCategories: category))
                }
                self.categoriesSuccessHandler(cellModelArray)
            }
            .onError { (error) in
                print("\(error)")
                self.categoriesErrorHandler(error)
            }
            .fetchCategoriesForShopOnline()
    }
    
    internal func fetchBestFashion(params: ShopOnlineProductParamsModel) {
        //self.bestFashionSuccessHandler(mockBestFashion())
        self.bestInFashionProductListFetcher
            .onSuccess { (bestInFashions) in
                var cellModelArray = [ShowCaseCategoryCellVM]()
                guard let products = bestInFashions.products else {
                    self.bestFashionSuccessHandler(cellModelArray)
                    return
                }
                for bestFashion in products {
                    cellModelArray.append(ShowCaseCategoryCellVM(withBestFashion: bestFashion))
                }
                self.bestFashionSuccessHandler(cellModelArray)
            }
            .onError { (error) in
                self.bestFashionErrorHandler(error)
            }
            .fetchBestFashion(withParams: params)
    }
    
    internal func fetchElectronicsAppliances(params: ShopOnlineProductParamsModel) {
        //self.bestFashionSuccessHandler(mockBestFashion())
        self.electronicsProductListFetcher
            .onSuccess { (bestInFashions) in
                var cellModelArray = [ShowCaseCategoryCellVM]()
                guard let products = bestInFashions.products else {
                    self.electronicsSuccessHandler(cellModelArray)
                    return
                }
                for bestFashion in products {
                    cellModelArray.append(ShowCaseCategoryCellVM(withBestFashion: bestFashion))
                }
                self.electronicsSuccessHandler(cellModelArray)
            }
            .onError { (error) in
                self.electronicsErrorHandler(error)
            }
            .fetchElectronicsAndAppliances(withParams: params)
    }
    
    internal func fetchTopTrends(parameters params: ShopOnlineProductParamsModel) {
        //self.topTrendSuccessHandler(mockTopTrend())
        
        topTrendFetcher
            .onSuccess { [unowned self] (topTrend) in
                var cellModelArray = [TopTrendCVCellModel]()
                guard let trendings = topTrend.results else {
                    self.topTrendSuccessHandler(cellModelArray)
                    return
                }
                for trend in trendings {
                    cellModelArray.append(TopTrendCVCellModel(withTopTrend: trend))
                }
                self.topTrendSuccessHandler(cellModelArray)
            }
            .onError { [unowned self](error) in
                self.topTrendErrorHandler(error)
            }
            .fetchTopTrend(withParams: params)
    }
}

extension ShopOnlineNetworkController {
    @discardableResult
    func onCarouselSuccess(success: @escaping (([HeroBannerCellModel], Bool) -> Void)) -> Self {
        self.carouselSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onCarouselError(error: @escaping ((String) -> Void)) -> Self {
        self.carouselErrorHandler = error
        
        return self
    }
    @discardableResult
    func onBannerSuccess(success: @escaping BannerSuccess) -> Self {
        self.bannerSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onBannerError(error: @escaping ((String) -> Void)) -> Self {
        self.bannerErrorHandler = error
        
        return self
    }
    @discardableResult
    func onPlaCardSuccess(success: @escaping BannerSuccess) -> Self {
        self.placardSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onPlaCardError(error: @escaping ((String) -> Void)) -> Self {
        self.placardErrorHandler = error
        
        return self
    }
    @discardableResult
    func onTopTrendSuccess(success: @escaping (([TopTrendCVCellModel]) -> Void)) -> Self {
        self.topTrendSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onTopTrendError(error: @escaping ((String) -> Void)) -> Self {
        self.topTrendErrorHandler = error
        
        return self
    }
    @discardableResult
    func onShopClickSuccess(success: @escaping (([ShopClickCellViewModel], OtherPartner) -> Void)) -> Self {
        self.shopClickSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onShopClickError(error: @escaping ((String) -> Void)) -> Self {
        self.shopClickErrorHandler = error
        
        return self
    }
    @discardableResult
    func onCategoriesSuccess(success: @escaping (([ShopClickCellViewModel]) -> Void)) -> Self {
        self.categoriesSuccessHandler = success
        return self
    }
    @discardableResult
    func onCategoriesError(error: @escaping ((String) -> Void)) -> Self {
        self.categoriesErrorHandler = error
        return self
    }
    @discardableResult
    func onBestFashionSuccess(success: @escaping (([ShowCaseCategoryCellVM]) -> Void)) -> Self {
        self.bestFashionSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onBestFashionError(error: @escaping ((String) -> Void)) -> Self {
        self.bestFashionErrorHandler = error
        
        return self
    }
    @discardableResult
    func onElectronicsSuccess(success: @escaping (([ShowCaseCategoryCellVM]) -> Void)) -> Self {
        self.electronicsSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onElectronicsError(error: @escaping ((String) -> Void)) -> Self {
        self.electronicsErrorHandler = error
        
        return self
    }
}

extension ShopOnlineNetworkController {
    fileprivate func mockShopClick() -> [ShopClickCellViewModel] {
        let data1 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_1"), earnInfo: "Earn 8 *P per Rs. 800")
        let data2 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_4"), earnInfo: "Earn 8 *P per Rs. 800")
        let data3 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_1"), earnInfo: "Earn 8 *P per Rs. 800")
        let data4 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_4"), earnInfo: "Earn 8 *P per Rs. 800")
        let data5 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_1"), earnInfo: "Earn 8 *P per Rs. 800")
        let data6 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_4"), earnInfo: "Earn 8 *P per Rs. 800")
        let data7 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_1"), earnInfo: "Earn 8 *P per Rs. 800")
        let data8 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_4"), earnInfo: "Earn 8 *P per Rs. 800")
        let data9 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_1"), earnInfo: "Earn 8 *P per Rs. 800")
        let data10 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_4"), earnInfo: "Earn 8 *P per Rs. 800")
        
        return [data1, data2, data3, data4, data5, data6, data7, data8, data9, data10]
    }
    
    fileprivate func mockInsuranceClick() -> [ShopClickCellViewModel] {
        let data1 = ShopClickCellViewModel(forInsurance: #imageLiteral(resourceName: "Sample_4"))
        let data2 = ShopClickCellViewModel(forInsurance: #imageLiteral(resourceName: "Sample_1"))
        let data3 = ShopClickCellViewModel(forInsurance: #imageLiteral(resourceName: "Sample_1"))
        let data4 = ShopClickCellViewModel(forInsurance: #imageLiteral(resourceName: "Sample_1"))
        let data5 = ShopClickCellViewModel(forInsurance: #imageLiteral(resourceName: "Sample_1"))
        let data6 = ShopClickCellViewModel(forInsurance: #imageLiteral(resourceName: "Sample_4"))
        let data7 = ShopClickCellViewModel(forInsurance: #imageLiteral(resourceName: "Sample_1"))
        let data8 = ShopClickCellViewModel(forInsurance: #imageLiteral(resourceName: "Sample_1"))
        let data9 = ShopClickCellViewModel(forInsurance: #imageLiteral(resourceName: "Sample_4"))
        let data10 = ShopClickCellViewModel(forInsurance: #imageLiteral(resourceName: "Sample_1"))
        return [data1, data2, data3, data4, data5, data6, data7, data8, data9, data10]
    }
    
    fileprivate func mockCategories() -> [ShopClickCellViewModel] {
        let data1 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_6"), earnInfo: "Mobile & Accessories")
        let data2 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_5"), earnInfo: "Electronics")
        let data3 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_6"), earnInfo: "Fashion")
        let data4 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_5"), earnInfo: "Home & Kitchen")
        let data5 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_6"), earnInfo: "Mobile & Accessories")
        let data6 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_5"), earnInfo: "Electronics")
        let data7 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_6"), earnInfo: "Fashion")
        let data8 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_5"), earnInfo: "Home & Kitchen")
        let data9 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_6"), earnInfo: "Mobile & Accessories")
        let data10 = ShopClickCellViewModel(image: #imageLiteral(resourceName: "Sample_5"), earnInfo: "Electronics")
        
        return [data1, data2, data3, data4, data5, data6, data7, data8, data9, data10]
    }
    
    fileprivate func mockBestFashion() -> [ShowCaseCategoryCellVM] {
        let data1 = ShowCaseCategoryCellVM(productImage: #imageLiteral(resourceName: "Sample_2"), productName: "BlackBerry z10 Black", earnPoints: "300", actualPrice: "25,000", partnerImage: #imageLiteral(resourceName: "Sample_3"), offerPrice: "13,999", productID: "20huss97ip87p")
        let data2 = ShowCaseCategoryCellVM(productImage: #imageLiteral(resourceName: "camera"), productName: "Nikon D7000", earnPoints: "400", actualPrice: "25,000", partnerImage: #imageLiteral(resourceName: "Sample_7"), offerPrice: "13,999", productID: "20huss97ip87p")
        let data3 = ShowCaseCategoryCellVM(productImage: #imageLiteral(resourceName: "Sample_2"), productName: "BlackBerry z10 Black", earnPoints: "500", actualPrice: "25,000", partnerImage: #imageLiteral(resourceName: "Sample_3"), offerPrice: "13,999", productID: "20huss97ip87p")
        let data4 = ShowCaseCategoryCellVM(productImage: #imageLiteral(resourceName: "camera"), productName: "Nikon D7000", earnPoints: "300", actualPrice: "25,000", partnerImage: #imageLiteral(resourceName: "Sample_7"), offerPrice: "13,999", productID: "20huss97ip87p")
        let data5 = ShowCaseCategoryCellVM(productImage: #imageLiteral(resourceName: "Sample_2"), productName: "BlackBerry z10 Black", earnPoints: "340", actualPrice: "25,000", partnerImage: #imageLiteral(resourceName: "Sample_3"), offerPrice: "13,999", productID: "20huss97ip87p")
        
        return [data1, data2, data3, data4, data5]
    }
    
    fileprivate func mockTopTrend() -> [TopTrendCVCellModel] {
        let data1 = TopTrendCVCellModel(isFeatured: false, productImage: #imageLiteral(resourceName: "Sample_2"), productTitle: "Blackberry", productPrice: "Rs. 40000", productDealPrice: "Rs. 26,999", productEarnPoints:"200", productID: "20huss97ip87p")
        let data2 = TopTrendCVCellModel(isFeatured: false, productImage: #imageLiteral(resourceName: "Sample_2"), productTitle: "Blackberry", productPrice: "Rs. 40000", productDealPrice: "Rs. 26,999", productEarnPoints:"200", productID: "20huss97ip87p")
        let data3 = TopTrendCVCellModel(isFeatured: false, productImage: #imageLiteral(resourceName: "Sample_2"), productTitle: "Blackberry", productPrice: "Rs. 40000", productDealPrice: "Rs. 26,999", productEarnPoints:"200", productID: "20huss97ip87p")
    
        return [data1, data2, data3]
    }
}
