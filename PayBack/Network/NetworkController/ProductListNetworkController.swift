//
//  ProductListNetworkController.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/13/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class ProductListNetworkController {
    fileprivate var dataSource: [ProductListCellModel] = []
    
    fileprivate var earnProductListFetcher = EarnProductListFetcher()
    fileprivate var burnProductListFetcher = BurnProductListFetcher()
    
    typealias ProductListSuccessHandler = ((String, [ProductListCellModel], [OtherFilterCellModel], [SortByTVCellModel], PriceRange?) -> Void)
    typealias ProductListErrorHandler = ((String) -> Void)
    
    fileprivate var earnProductListSuccessHandler: ProductListSuccessHandler = { _, _, _, _, _  in }
    fileprivate var earnProductListErrorHandler: ProductListErrorHandler = { _ in }
    
    fileprivate var burnProductListSuccessHandler: ProductListSuccessHandler = { _, _, _, _, _   in }
    fileprivate var burnProductListErrorHandler: ProductListErrorHandler = { _ in }
    
    fileprivate let topTrendFetcher = TopTrendFetcher()
    fileprivate var trendingProductListSuccessHandler: ProductListSuccessHandler = { _, _, _, _, _  in }
    fileprivate var trendingProductListErrorHandler: ProductListErrorHandler = { _ in }
    
    fileprivate let shopOnlineCategoriesProductListFetcher = ShopOnlineCategoriesProductListFetcher()
    fileprivate var categoryProductListSuccessHandler: ProductListSuccessHandler = { _, _, _, _, _  in }
    fileprivate var categoryProductListErrorHandler: ProductListErrorHandler = { _ in }
    
    // MARK: Earn
    
    fileprivate func parseFilter(_ filters: [RedeemProduct.Filter], _ filterCellArray: inout [OtherFilterCellModel]) {
        for filter in filters {
            if filterCellArray.contains(where: { $0.title == filter.displayName }) {
                continue
            }
            var vals = [OtherFilterCellModel.Value]()
            
            guard let values = filter.values else {
                continue
            }
            for value in values {
                guard let brandId = value.id else {
                    continue
                }
                vals.append(OtherFilterCellModel.Value(valueName: value.name ?? "", valueId:  brandId))
            }
            filterCellArray.append(OtherFilterCellModel(title: filter.displayName ?? "", values: vals))
        }
    }
    fileprivate func parseFilter(_ filters: [ProductFilter], _ filterCellArray: inout [OtherFilterCellModel]) {
        for filter in filters {
            if filterCellArray.contains(where: { $0.title == filter.displayName }) {
                continue
            }
            var vals = [OtherFilterCellModel.Value]()
            
            guard let values = filter.values else {
                continue
            }
            for value in values {
                vals.append(OtherFilterCellModel.Value(valueName: value, valueId: value))
            }
            filterCellArray.append(OtherFilterCellModel(title: filter.displayName ?? "", values: vals))
        }
    }
    
    func fetchShopOnlineSearchProductList(withParams params: EarnProductListParamsTuple, isLoadMore: Bool) {
        if !isLoadMore {
            dataSource.removeAll()
        }
        earnProductListFetcher
            .onSuccess(success: { [weak self] (earnProduct) in
                guard let strongSelf = self, let searchedItem = earnProduct.products else {
                    self?.earnProductListSuccessHandler("0", [], [], [], nil)
                    return
                }
                var cellModelArray = [ProductListCellModel]()
                for result in searchedItem {
                    cellModelArray.append(ProductListCellModel(withCategoryProductData: result))
                }
                strongSelf.dataSource += cellModelArray

                var filterCellArray = [OtherFilterCellModel]()

                if let filters = earnProduct.filters {
                    self?.parseFilter(filters, &filterCellArray)
                }
                var sortByCellArray = [SortByTVCellModel]()

                if let sortBy = earnProduct.sortBy {
                    self?.parseSortBy(sortBy, &sortByCellArray)
                }
                var count = 0
                if let ct = earnProduct.totalCount {
                    count = ct
                }
                strongSelf.earnProductListSuccessHandler("\(count)", strongSelf.dataSource, filterCellArray, sortByCellArray, earnProduct.priceRange)
            })
            .onError(error: earnProductListErrorHandler)
            .fetchProductList(withParams: params)
    }
    internal func fetchTopTrendsProductList(withParams params: ShopOnlineProductParamsModel, isLoadMore: Bool) {
        if !isLoadMore {
            dataSource.removeAll()
        }
        topTrendFetcher
            .onSuccess { [unowned self] (topTrend) in
                guard let trendings = topTrend.results else {
                    self.trendingProductListSuccessHandler("0", [], [], [], nil)
                    return
                }
                var cellModelArray = [ProductListCellModel]()
                
                for trending in trendings {
                    cellModelArray.append(ProductListCellModel(withTopTrendData: trending))
                }
                self.dataSource += cellModelArray
                
                var filterCellArray = [OtherFilterCellModel]()
                if let filters = topTrend.filters {
                    self.parseFilter(filters, &filterCellArray)
                }
                var sortByCellArray = [SortByTVCellModel]()
                
                if let sortBy = topTrend.sortBy {
                    self.parseSortBy(sortBy, &sortByCellArray)
                }
                var count = "0"
                if let ct = topTrend.totalCount {
                    count = String(ct)
                }
                self.trendingProductListSuccessHandler(count, self.dataSource, filterCellArray, sortByCellArray, topTrend.priceRange)
            }
            .onError { [unowned self](error) in
                self.trendingProductListErrorHandler(error)
            }
            .fetchTopTrend(withParams: params)
    }
    
    fileprivate func parseSortBy(_ sortBy: [SortByModel], _ sortByCellArray: inout [SortByTVCellModel]) {
        for sort in sortBy {
            sortByCellArray.append(SortByTVCellModel(withSortByModel: sort, isSelected: false))
        }
    }
    
    internal func fetchShopOnlineProductList(withParams params: ShopOnlineProductParamsModel, isLoadMore: Bool) {
        if !isLoadMore {
            dataSource.removeAll()
        }
        shopOnlineCategoriesProductListFetcher
            .onSuccess { [unowned self] (categoryProduct) in
                guard let products = categoryProduct.products else {
                    self.categoryProductListSuccessHandler("0", [], [], [], nil)
                    return
                }
                var cellModelArray = [ProductListCellModel]()
                
                for product in products {
                    cellModelArray.append(ProductListCellModel(withCategoryProductData: product))
                }
                self.dataSource += cellModelArray
                
                var filterCellArray = [OtherFilterCellModel]()
                if let filters = categoryProduct.filters {
                    self.parseFilter(filters, &filterCellArray)
                }
                var sortByCellArray = [SortByTVCellModel]()
                if let sortBy = categoryProduct.sortBy {
                    self.parseSortBy(sortBy, &sortByCellArray)
                }
                var count = 0
                if let ct = categoryProduct.totalCount {
                    count = ct
                }
                self.categoryProductListSuccessHandler("\(count)", self.dataSource, filterCellArray, sortByCellArray, categoryProduct.priceRange)
            }
            .onError { [unowned self](error) in
                self.categoryProductListErrorHandler(error)
            }
            .fetchShopOnlineCategoriesProductList(withParams: params)
    }
    
    // MARK: Redeem/Burn
    
    func fetchBurnProductList(withParams params: BurnProductParamsModel, isLoadMore: Bool) {
        if !isLoadMore {
            dataSource.removeAll()
        }
        burnProductListFetcher
            .onSuccess(success: { [weak self] (redeemProduct) in
                guard let strongSelf = self, let searchedItem = redeemProduct.result else {
                    self?.burnProductListSuccessHandler("0", [], [], [], nil)
                    return
                }
                var cellModelArray = [ProductListCellModel]()
                for result in searchedItem {
                    cellModelArray.append(ProductListCellModel(withBurnSearchData: result))
                }
                strongSelf.dataSource += cellModelArray
                
                var filterCellArray = [OtherFilterCellModel]()
                if let filters = redeemProduct.filters {
                    self?.parseFilter(filters, &filterCellArray)
                }
                
                var count = "0"
                if let ct = redeemProduct.count {
                    count = ct
                }
                strongSelf.burnProductListSuccessHandler(count, strongSelf.dataSource, filterCellArray, [], nil)
            })
            .onError(error: burnProductListErrorHandler)
            .fetchProductList(withParams: params)
    }
}
extension ProductListNetworkController {
    // MARK: Earn
    @discardableResult
    func onEarnProductListSuccess(success: @escaping ProductListSuccessHandler) -> Self {
        self.earnProductListSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onEarnProductListError(error: @escaping ProductListErrorHandler) -> Self {
        self.earnProductListErrorHandler = error
        
        return self
    }
    @discardableResult
    func onTrendingProductListSuccess(success: @escaping ProductListSuccessHandler) -> Self {
        self.trendingProductListSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onTrendingProductListError(error: @escaping ProductListErrorHandler) -> Self {
        self.trendingProductListErrorHandler = error
        
        return self
    }
    @discardableResult
    func onCategoryProductListSuccess(success: @escaping ProductListSuccessHandler) -> Self {
        self.categoryProductListSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onCategoryProductListError(error: @escaping ProductListErrorHandler) -> Self {
        self.categoryProductListErrorHandler = error
        
        return self
    }
    // MARK: Burn
    @discardableResult
    func onBurnProductListSuccess(success: @escaping ProductListSuccessHandler) -> Self {
        self.burnProductListSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onBurnProductListError(error: @escaping ProductListErrorHandler) -> Self {
        self.burnProductListErrorHandler = error
        
        return self
    }
}

extension ProductListNetworkController {
    fileprivate func mockProductList() -> [ProductListCellModel] {
        let data1 = ProductListCellModel(pImage: "camera", pFeatureTag: true, pAvailable: "Available from 7 sellers", pPoints: "5000", pPrize : "Rs. 15,950", pOffer : "40% off ", pDiscount:"Rs 30,000", pName : "Nikon Coolpix B500 Point & Shoot Camera (Black)")
        let data2 = ProductListCellModel(pImage: "camera", pFeatureTag: false, pAvailable: nil, pPoints: "5000", pPrize : nil, pOffer : nil, pDiscount:nil, pName : "Nikon Coolpix B500 Point & Shoot Camera (Black)")
        let data3 = ProductListCellModel(pImage: "camera", pFeatureTag: false, pAvailable: "Available from 7 sellers", pPoints: "5000", pPrize : "Rs. 15,950", pOffer : "40% off", pDiscount:nil, pName : "Nikon Coolpix B500 Point & Shoot Camera (Black)")
        let data4 = ProductListCellModel(pImage: "camera", pFeatureTag: false, pAvailable: nil, pPoints: "5000", pPrize : nil, pOffer : nil, pDiscount:nil, pName : "Nikon Coolpix B500 Point & Shoot Camera (Black)")
        let data5 = ProductListCellModel(pImage: "camera", pFeatureTag: false, pAvailable: "Available from 7 sellers", pPoints: "5000", pPrize : "Rs. 15,950", pOffer : "40% off ", pDiscount:"Rs 30,000", pName : "Nikon Coolpix B500 Point & Shoot Camera (Black)")
        let data6 = ProductListCellModel(pImage: "camera", pFeatureTag: true, pAvailable: "Available from 7 sellers", pPoints: "5000", pPrize : "Rs. 15,950", pOffer : "40% off ", pDiscount:"Rs 30,000", pName : "Nikon Coolpix B500 Point & Shoot Camera (Black)")
        
        return [data1, data2, data3, data4, data5, data6]
    }
}
