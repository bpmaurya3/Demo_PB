//
//  RewardCatalogueNetworkController.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/14/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class RewardCatalogueNetworkController {
    
    var errorHandler: ((String) -> Void) = { _ in }

    let categoryFetcher = CategoriesFetcher()
    var whatsYourWishSuccessHandler: (([ShopClickCellViewModel]) -> Void) = { _ in }
    
    let hotDealFetcher = BurnProductListFetcher()
    var hotDealSuccessHandler: (([TopTrendCVCellModel]) -> Void) = { _ in }
    
    let recommendedDealFetcher = BurnProductListFetcher()
    var recommendedDealSuccessHandler: (([TopTrendCVCellModel]) -> Void) = { _ in }
    
    typealias BannerSuccess = ((HeroBannerCellModel, Bool) -> Void)
    let bannerFetcher = BannerFetcher()
    var bannerSuccessHandler: BannerSuccess = { _, _ in }
    
    let placardFetcher = PlacardFetcher()
    var placardSuccessHandler: BannerSuccess = { _, _ in }
    
    fileprivate lazy var carouselFetcher: CarouselFetcher = {
        return CarouselFetcher()
    }()
    var carouselSuccessHandler: (([HeroBannerCellModel], _ isExpire: Bool) -> Void) = { _, _  in }
    
    internal func fetchCarouselData() {
        carouselFetcher
            .onSuccess { [weak self] (carousel, expired) in
                self?.carouselSuccessHandler(carousel, expired)
            }
            .onError(error: errorHandler)
            .fetchRewardsCarousel()
    }
    
    internal func fetchBannerForReward() {
        bannerFetcher
            .onBannerSuccess(success: { [weak self] (banner, expired) in
                self?.bannerSuccessHandler(banner, expired)
            })
            .onError(error: errorHandler)
            .fetchBannerForReward()
    }
    
    internal func fetchPlacardForReward() {
        placardFetcher
            .onPlacardSuccess(success: { [weak self] (placard, expired) in
                self?.placardSuccessHandler(placard, expired)
            })
            .onError(error: errorHandler)
            .fetchPlacardForReward()
    }
    
    internal func fetchWhatsYourWish() {
        //cell.cellModel = mockWhatsYourWish()
        
        let encodedData = RequestBody.getWhatsYourWish()
        
        categoryFetcher
            .onSuccess(success: { [weak self] (categories) in
                var cellModelArray = [ShopClickCellViewModel]()
                guard let categoryList = categories.categoryList else {
                    self?.whatsYourWishSuccessHandler(cellModelArray)
                    return
                }
                for result in categoryList {
                    cellModelArray.append(ShopClickCellViewModel(withRewardCategories: result))
                }
                self?.whatsYourWishSuccessHandler(cellModelArray)
            })
            .onError(error: errorHandler)
            .fetchCategoriesForReward(withParams: encodedData)
    }
    
    internal func fetchRecommendedDeals(limit: String) {
       // cell.cellModel = mockRecommendedDeals()
        let params = BurnProductParamsModel(limit: limit, categoryPath: "recommended-deals")
        
        recommendedDealFetcher
            .onSuccess(success: { [unowned self](redeemProduct) in
                var cellModelArray = [TopTrendCVCellModel]()
                guard let results = redeemProduct.result else {
                    self.recommendedDealSuccessHandler(cellModelArray)
                    return
                }
                for result in results {
                    cellModelArray.append(TopTrendCVCellModel(withRedeemProductItem: result))
                }
                self.recommendedDealSuccessHandler(cellModelArray)
            })
            .onError(error: errorHandler)
            .fetchProductList(withParams: params)
    }
    
    internal func fetchHotDeals() {
        //cell.cellModel = mockHotDeals()
        let params = BurnProductParamsModel(categoryPath: "gifts")
       
        hotDealFetcher
            .onSuccess(success: { [unowned self](redeemProduct) in
                var cellModelArray = [TopTrendCVCellModel]()
                guard let result = redeemProduct.result else {
                    self.hotDealSuccessHandler(cellModelArray)
                    return
                }
                for result in result {
                    cellModelArray.append(TopTrendCVCellModel(withRedeemProductItem: result))
                }
                self.hotDealSuccessHandler(cellModelArray)
            })
            .onError(error: errorHandler)
            .fetchProductList(withParams: params)
    }
    
    deinit {
        print("RewardCatalogueNetworkController: deinit called")
    }
}
extension RewardCatalogueNetworkController {
    
    @discardableResult
    func onError(error: @escaping ((String) -> Void)) -> Self {
        self.errorHandler = error
        
        return self
    }
    @discardableResult
    func onWhatsYourWishSuccess(success: @escaping (([ShopClickCellViewModel]) -> Void)) -> Self {
        self.whatsYourWishSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onRecommendedDealSuccess(success: @escaping (([TopTrendCVCellModel]) -> Void)) -> Self {
        self.recommendedDealSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onhotDealSuccess(success: @escaping (([TopTrendCVCellModel]) -> Void)) -> Self {
        self.hotDealSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onCarouselSuccess(success: @escaping (([HeroBannerCellModel], _ isExpire: Bool) -> Void)) -> Self {
        self.carouselSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onBannerSuccess(success: @escaping BannerSuccess) -> Self {
        self.bannerSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onPlacardSuccess(success: @escaping BannerSuccess) -> Self {
        self.placardSuccessHandler = success
        
        return self
    }
    
}

extension RewardCatalogueNetworkController {
    fileprivate func mockWhatsYourWish() -> [ShopClickCellViewModel] {
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
    
    fileprivate func mockRecommendedDeals() -> [TopTrendCVCellModel] {
        let data1 = TopTrendCVCellModel(isFeatured: false, productImage: #imageLiteral(resourceName: "Sample_2"), productTitle: "Blackberry", productPrice: "", productDealPrice: "", productEarnPoints:"200", productID: "20huss97ip87p")
        let data2 = TopTrendCVCellModel(isFeatured: false, productImage: #imageLiteral(resourceName: "Sample_2"), productTitle: "Blackberry", productPrice: "", productDealPrice: "", productEarnPoints:"200", productID: "20huss97ip87p")
        let data3 = TopTrendCVCellModel(isFeatured: false, productImage: #imageLiteral(resourceName: "Sample_2"), productTitle: "Blackberry", productPrice: "", productDealPrice: "", productEarnPoints:"200", productID: "20huss97ip87p")
        
        return [data1, data2, data3]
    }
    
    fileprivate func mockHotDeals() -> [TopTrendCVCellModel] {
        let data1 = TopTrendCVCellModel(isFeatured: false, productImage: #imageLiteral(resourceName: "Sample_2"), productTitle: "Blackberry", productPrice: "", productDealPrice: "", productEarnPoints:"200", productID: "20huss97ip87p")
        let data2 = TopTrendCVCellModel(isFeatured: false, productImage: #imageLiteral(resourceName: "Sample_2"), productTitle: "Blackberry", productPrice: "", productDealPrice: "", productEarnPoints:"200", productID: "20huss97ip87p")
        let data3 = TopTrendCVCellModel(isFeatured: false, productImage: #imageLiteral(resourceName: "Sample_2"), productTitle: "Blackberry", productPrice: "", productDealPrice: "", productEarnPoints:"200", productID: "20huss97ip87p")
        
        return [data1, data2, data3]
    }
}
