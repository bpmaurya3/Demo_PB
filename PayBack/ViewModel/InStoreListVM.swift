//
//  InStoreListVM.swift
//  PayBack
//
//  Created by valtechadmin on 4/24/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces

class InStoreListVM: NSObject {
    
    var errorHandler: (String) -> Void = { _ in }
    var successHandler: () -> Void = { }
    private var fetcher: InStoreListFetcher
    var sortBy: StoreLocaterSortBy = .None {
        didSet {
            sortList(by: sortBy)
        }
    }
    
    private var storeResponseModel: InstoreListModel?
    private var storeListCellModel: [InstoreListTVCellModel] = [InstoreListTVCellModel]()
    private var filterModel: [String: [SearchFilterTVCellModel]] = [String: [SearchFilterTVCellModel]]()
    var filterCount: Int = 0
    var filteredData: [String: String] = [:]
    
    init(withFetcher fetcher: InStoreListFetcher) {
        self.fetcher = fetcher
    }
    
    func fetchInStoreListNear(currentLocation location: CLLocationCoordinate2D, filterParameters filter: StoreLocaterFilterParameters) {
        fetcher.onSuccess(success: {[weak self] (storelistModel) in
            self?.storeResponseModel = storelistModel
            self?.convertToCellModel()
            self?.successHandler()
        })
            .onError(error: { (error) in
                print(error)
                self.errorHandler(error)
            })
            .getInStoreListNear(lattitude: "\(location.latitude)", longitude: "\(location.longitude)", filterParams: filter)
        
    }
    
    private func convertToCellModel() {
        if let filter = storeResponseModel?.filters {
//            if !filterModel.isEmpty {
//                filterModel.removeAll()
//            }
            if filterModel.isEmpty {
                var modelDictionary: [String: [SearchFilterTVCellModel]] = [:]
                for model in filter where (model.displayName == "Category" || model.displayName == "City" || model.displayName == "Partner") {
                    var cellArray = [SearchFilterTVCellModel]()
                    if let facets = model.facets {
                        for (index, facet) in facets.enumerated() {
                            cellArray.append(SearchFilterTVCellModel(partnerName: facet.name, partnerId: "", isEnabled: false, id: index))
                        }
                    }
                    modelDictionary[model.displayName ?? ""] = cellArray
                }
                filterModel = modelDictionary
            }
        }
        if let deals = storeResponseModel?.deals {
            if !storeListCellModel.isEmpty {
                storeListCellModel.removeAll()
            }
            for deal in deals {
                storeListCellModel.append(InstoreListTVCellModel(withStoreDeal: deal))
            }
            sortList(by: sortBy)
        }
    }
}

extension InStoreListVM {
    func onSuccess(success: @escaping (() -> Void)) -> Self {
        self.successHandler = success
        return self
    }
    func onError(error: @escaping ((String) -> Void)) -> Self {
        self.errorHandler = error
        return self
    }
}

extension InStoreListVM {
    
    private func sortList(by sortBy: StoreLocaterSortBy) {
//        var list: [InstoreListTVCellModel] = []
        switch sortBy {
        case .LowTOHigh:
            storeListCellModel.sort {
                if let dist1 = $0.storeDistance, let dist2 = $1.storeDistance {
                   return dist1 < dist2
                }
                return true
            }
        case .HighToLow:
            storeListCellModel.sort {
                if let dist1 = $0.storeDistance, let dist2 = $1.storeDistance {
                    return dist1 > dist2
                }
                return true
            }
        default :
            break
        }
    }
    
    func getStoreListCount() -> Int {
        return storeListCellModel.count
    }
    
    func getCellModel(atIndex index: Int) -> InstoreListTVCellModel? {
        guard !storeListCellModel.isEmpty, storeListCellModel.count > index else {
            return nil
        }
        
        return storeListCellModel[index]
    }
    
    func getStoreList() -> [InstoreListTVCellModel] {
        return storeListCellModel
    }
    
//    func getFilterList() -> [StoreLocaterFilter] {
//        return filterModel
//    }
    
    func getFilterListCount() -> Int {
        return filterModel.count
    }
}
extension InStoreListVM {
    func getFilterModel() -> [String: [SearchFilterTVCellModel]] {
        return filterModel
    }
}
extension InStoreListVM {
    func getSelectedFilterDataModel() -> [String: String] {
        return filteredData
    }
}
