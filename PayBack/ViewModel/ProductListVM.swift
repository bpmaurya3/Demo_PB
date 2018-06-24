//
//  ProductListVM.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 12/6/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
typealias EarnProductListParamsTuple = (searchText: String, page: String, per_page: String, filter: [String: String], sortBy: String)
typealias BurnProductListParamsTuple = (searchText: String, categoryPath: String, limit: String)

class ProductListVM: NSObject {
    var errorHandler: (String) -> Void = { _ in }
    var successHandler: () -> Void = { }

    typealias Params = (searchText: String, categoryPath: String, category: ProductCategory, productListLandingType: ProductType, productName: String)
    @objc dynamic fileprivate(set) var dataSource: [ProductListCellModel] = [ProductListCellModel]()
    
    fileprivate var totalProductCount: Int = 0
    fileprivate var filterModel: [OtherFilterCellModel]?
    fileprivate var sortByModels: [SortByTVCellModel]?
    fileprivate var priceRange: PriceRange?
    fileprivate var lastId = 0
    fileprivate var productListRequestParams: Params?
    fileprivate var networkController: ProductListNetworkController
    
    private var productListObserver: NSKeyValueObservation?
    internal var bindToProductListViewModels: (() -> Void) = { }

    init(networkController: ProductListNetworkController, productListRequestParams: Params) {
        self.networkController = networkController
        self.productListRequestParams = productListRequestParams
        super.init()
        
        productListObserver = self.observe(\.dataSource, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToProductListViewModels()
        })
        
        switch productListRequestParams.productListLandingType {
        case .earnProduct:
            switch productListRequestParams.category {
            case .mobileSearch:
                let params: EarnProductListParamsTuple = (searchText: productListRequestParams.searchText, page: "1", per_page: "10", filter: [:], sortBy: "")
                fetchMobileSearch(requestBody: params, isFilterUpdate: true, isLoadMore: false)
            case .topTrend:
                let params = ShopOnlineProductParamsModel()
                fetchTopTrend(params: params, isFilterUpdate: true, isLoadMore: false)
            case .bestFashion:
                let params = ShopOnlineProductParamsModel(id: productListRequestParams.categoryPath)
                fetchShopOnlineCategories(params: params, isFilterUpdate: true, isLoadMore: false)
            case .shopOnlineCategory:
               let params = ShopOnlineProductParamsModel(id: productListRequestParams.categoryPath)
                fetchShopOnlineCategories(params: params, isFilterUpdate: true, isLoadMore: false)
            default:
                break
            }
        case .burnProduct:
            let params = BurnProductParamsModel(searchText: productListRequestParams.searchText, categoryPath: productListRequestParams.categoryPath)
            fetchDataForBurn(params: params, isFilterUpdate: true, isLoadMore: false)
        default:
            break
        }
    }
    
    func invalidateObservers() {
        self.productListObserver?.invalidate()
    }
    deinit {
        print("ProductListVM: deinit called")
    }
}
extension ProductListVM {
    fileprivate func fetchMobileSearch(requestBody: EarnProductListParamsTuple, isFilterUpdate: Bool, isLoadMore: Bool) {
        self.networkController
            .onEarnProductListSuccess(success: {  [weak self] (count, productList, filterList, sortBy, pricerange) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.totalProductCount = Int(count) ?? 0
                if isFilterUpdate {
                    strongSelf.filterModel = filterList
                    strongSelf.sortByModels = sortBy
                    strongSelf.priceRange = pricerange
                }
                strongSelf.lastId = productList.count
                
                strongSelf.dataSource = productList
                if !isLoadMore {
                    self?.successHandler()
                }
            })
            .onEarnProductListError {[weak self] (error) in
                print("\(error)")
                self?.errorHandler(error)
            }
            .fetchShopOnlineSearchProductList(withParams: requestBody, isLoadMore: isLoadMore)
    }
    fileprivate func fetchShopOnlineCategories(params: ShopOnlineProductParamsModel, isFilterUpdate: Bool, isLoadMore: Bool) {
        self.networkController
            .onCategoryProductListSuccess(success: {  [weak self] (count, productList, filterList, sortBy, pricerange) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.totalProductCount = Int(count) ?? 0
                if isFilterUpdate {
                    strongSelf.filterModel = filterList
                    strongSelf.sortByModels = sortBy
                    strongSelf.priceRange = pricerange
                }
                strongSelf.lastId = productList.count
                
                strongSelf.dataSource = productList
                if !isLoadMore {
                    self?.successHandler()
                }
            })
            .onCategoryProductListError { [weak self](error) in
                print("\(error)")
                self?.errorHandler(error)
            }
            .fetchShopOnlineProductList(withParams: params, isLoadMore: isLoadMore)
    }
    fileprivate func fetchTopTrend(params: ShopOnlineProductParamsModel, isFilterUpdate: Bool, isLoadMore: Bool) {
        self.networkController
            .onTrendingProductListSuccess(success: { [weak self] (count, productList, filterList, sortBy, pricerange) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.totalProductCount = Int(count) ?? 0
                if isFilterUpdate {
                    strongSelf.filterModel = filterList
                    strongSelf.sortByModels = sortBy
                    strongSelf.priceRange = pricerange
                }
                strongSelf.lastId = productList.count
                
                strongSelf.dataSource = productList
                if !isLoadMore {
                    self?.successHandler()
                }
            })
            .onTrendingProductListError(error: {[weak self] (error) in
                print("\(error)")
                self?.errorHandler(error)
            })
            .fetchTopTrendsProductList(withParams: params, isLoadMore: isLoadMore)
    }
    
    fileprivate func fetchDataForBurn(params: BurnProductParamsModel, isFilterUpdate: Bool, isLoadMore: Bool) {
        
        self.networkController
            .onBurnProductListSuccess(success: { [weak self] (count, productList, filterList, _, _) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.totalProductCount = Int(count) ?? 0
                if isFilterUpdate {
                    self?.filterModel = filterList
                }
                strongSelf.lastId = productList.count
                strongSelf.dataSource = productList
                if !isLoadMore {
                    self?.successHandler()
                }
            })
            .onBurnProductListError(error: { [weak self] (error) in
                print("\(error)")
                self?.errorHandler(error)
            })
            .fetchBurnProductList(withParams: params, isLoadMore: isLoadMore)
    }
    @discardableResult
    func onSuccess(success: @escaping () -> Void) -> Self {
        self.successHandler = success
        return self
    }
    @discardableResult
    func onError(error: @escaping (String) -> Void) -> Self {
        self.errorHandler = error
        return self
    }
}

extension ProductListVM {
    internal func last() -> Int {
        return self.lastId
    }
    internal func totalCount() -> Int {
        return self.totalProductCount
    }
    internal func getFilterModel() -> [OtherFilterCellModel]? {
        return self.filterModel
    }
    internal func getSortByModel() -> [SortByTVCellModel]? {
        return self.sortByModels
    }
    internal func getPriceRange() -> PriceRange? {
        return self.priceRange
    }
    internal func product(at index: Int) -> ProductListCellModel {
        return dataSource[index]
    }
}

extension ProductListVM {
    fileprivate func fetchProductList(_ productListRequestParams: ProductListVM.Params, _ skip: String, _ filteredData: [String : String], _ isLoadMore: Bool, _ filterModel: RedeemFilterModel) {
        switch productListRequestParams.productListLandingType {
        case .earnProduct:
            switch productListRequestParams.category {
            case .mobileSearch:
                let page = (Int(skip) ?? 0) / 10 + 1
                let params: EarnProductListParamsTuple = (searchText: productListRequestParams.searchText, page: "\(page)", per_page: "10", filter: filteredData, sortBy: filterModel.sort)
                fetchMobileSearch(requestBody: params, isFilterUpdate: false, isLoadMore: isLoadMore)
            case .topTrend:
                let page = (Int(skip) ?? 0) / 10 + 1
                let params = ShopOnlineProductParamsModel(page: "\(page)", filter: filteredData, sortBy: filterModel.sort)
                fetchTopTrend(params: params, isFilterUpdate: false, isLoadMore: isLoadMore)
            case .shopOnlineCategory:
                let page = (Int(skip) ?? 0) / 10 + 1
                let params = ShopOnlineProductParamsModel(id: productListRequestParams.categoryPath, page: "\(page)", filter: filteredData, sortBy: filterModel.sort)
                fetchShopOnlineCategories(params: params, isFilterUpdate: false, isLoadMore: isLoadMore)
            case .bestFashion:
                let page = (Int(skip) ?? 0) / 10 + 1
                let params = ShopOnlineProductParamsModel(id: productListRequestParams.categoryPath, page: "\(page)", filter: filteredData, sortBy: filterModel.sort)
                fetchShopOnlineCategories(params: params, isFilterUpdate: false, isLoadMore: isLoadMore)
            default:
                break
            }
        case .burnProduct:
            let params = BurnProductParamsModel(skip: skip, searchText: productListRequestParams.searchText, categoryPath: filterModel.category, minPoints: filterModel.minPoints, maxPoints: filterModel.maxPoints, brand: filterModel.brand, sort: filterModel.sort)
            fetchDataForBurn(params: params, isFilterUpdate: false, isLoadMore: isLoadMore)
        default:
            break
        }
    }
    
    internal func applyFilterAndLoadMore(skip: String, isLoadMore: Bool, filteredDict: [String: String]) {
        var filteredData = filteredDict
        guard let productListRequestParams = productListRequestParams else {
            return
        }
        var model: RedeemFilterModel!
        if productListRequestParams.productListLandingType == .earnProduct {
            let sort = "\(filteredData["sort"] ?? "")"
            filteredData.removeValue(forKey: "sort")
            if let min = filteredData["min"], let max = filteredData["max"] {
                filteredData.removeValue(forKey: "min")
                filteredData.removeValue(forKey: "max")
                filteredData["Price Range"] = "\(min)-\(max)"
            }
            model = RedeemFilterModel(sort: sort, category: "", brand: "", minPoints: "", maxPoints: "")
        } else {
            let minPoints = "\(filteredData["min"] ?? "")"
            let maxPoints = "\(filteredData["max"] ?? StringConstant.MAX_POINTS_RANGE)"
            let brand = "\(filteredData["Brands"] ?? "")"
            var category = ""
            if productListRequestParams.categoryPath != "" {
                category = productListRequestParams.categoryPath
            }
            if let categories = filteredData["Categories"] {
                category += (category == "" ? "\(categories)" : ",\(categories)")
            }
            let sort = "\(filteredData["sort"] ?? "")"
            filteredData.removeValue(forKey: "sort")
            model = RedeemFilterModel(sort: sort, category: category, brand: brand, minPoints: minPoints, maxPoints: maxPoints)
        }
       
        fetchProductList(productListRequestParams, skip, filteredData, isLoadMore, model)
    }
}
