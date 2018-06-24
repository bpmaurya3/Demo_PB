//
//  PBWishListVM.swift
//  PayBack
//
//  Created by valtechadmin on 01/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBWishListVM: NSObject {
    @objc dynamic fileprivate(set) var dataSource: [WishListCellModel] = [WishListCellModel]()
    private var wishListObserver: NSKeyValueObservation?
    internal var bindToWishListViewModels: (() -> Void) = { }
    
    var deleteSuccessHandler: (String, WishListCellModel) -> Void = { _, _ in }
    var deleteErrorHandler: (String) -> Void = { _ in }
    
    let wishListFetcher = WishListFetcher()
    let deleteWishListFetcher = DeleteWishListFetcher()
    
    init(withNetworkController controller: UIViewController) {
        super.init()
        wishListObserver = self.observe(\.dataSource, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToWishListViewModels()
        })
    }
    func invalidateObservers() {
        wishListObserver?.invalidate()
    }
    deinit {
        self.invalidateObservers()
    }
    
    func deleteCellModel(model: WishListCellModel) {
        
        if model.prodyctType == "Rewards" {
            let userId = UserProfileUtilities.getUserID()
            guard let wishlistId = model.wishlistId else {
                return
            }
            self.deleteWishListFetcher
                .onSuccess { [weak self] success in
                    if let index = self?.dataSource.index(where: { $0.productId == model.productId }) {
                        self?.dataSource.remove(at: index)
                    }
                    self?.deleteSuccessHandler(success.message ?? "", model)
                }
                .onError { (error) in
                    print("Wishlist delete : \(error)")
                    self.deleteErrorHandler(error)
                }
                .deleteWishListForRewards(userId: userId, wishListId: wishlistId)
        } else {
            let userEmail = UserProfileUtilities.getUserDetails()?.EmailAddress ?? ""
            guard let productId = model.productId else {
                return
            }
            self.deleteWishListFetcher
                .onSuccess { [weak self] success in
                    if let index = self?.dataSource.index(where: { $0.productId == model.productId }) {
                        self?.dataSource.remove(at: index)
                    }
                    self?.deleteSuccessHandler(success.message ?? "", model)
                }
                .onError { (error) in
                    print("Wishlist delete : \(error)")
                    self.deleteErrorHandler(error)
                }
                .deleteWishListForShopOnline(loginUserEmail: userEmail, productId: productId)
        }
    }
}
extension PBWishListVM {
    func fetchWishList() {
        let userEmail = UserProfileUtilities.getUserDetails()?.EmailAddress ?? ""
        let userId = UserProfileUtilities.getUserID()
        
        self.wishListFetcher
            .onSuccess { [weak self] (wishListModel) in
                var cellModelArray = [WishListCellModel]()
                guard let results = wishListModel.wishListDetails else {
                    self?.dataSource = cellModelArray
                    return
                }
                for result in results {
                    cellModelArray.append(WishListCellModel(withWishListModel: result))
                }
                self?.dataSource = cellModelArray
            }
            .onError { (error) in
                print("\(error)")
                self.dataSource = []
            }
            .fetchCombineWishList(loginUserEmail: userEmail, userId: userId)
    }
}

extension PBWishListVM {
    @discardableResult
    func onDeleteSuccess(success: @escaping ((String, WishListCellModel) -> Void)) -> Self {
        self.deleteSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onDeleteError(error: @escaping ((String) -> Void)) -> Self {
        self.deleteErrorHandler = error
        
        return self
    }
}

extension PBWishListVM {
    fileprivate func wishListData() {
        
        let data1 = WishListCellModel(mProductImage: #imageLiteral(resourceName: "Sample_2"), mProductName: "BlackBerry z10 Black", mItemCode: "RNW2000", mProductPrice: "14,999", remainingPointLabel: "You are 3000 Points away from your wish", points: "200")
        let data2 = WishListCellModel(mProductImage: #imageLiteral(resourceName: "camera"), mProductName: "Nikon D7000", mItemCode: "RNW1300", mProductPrice: "25,999", remainingPointLabel: "You are 3000 Points away from your wish", points: "300")
        let data3 = WishListCellModel(mProductImage: #imageLiteral(resourceName: "Sample_2"), mProductName: "BlackBerry z10 Black", mItemCode: "RNW2000", mProductPrice: "14000", remainingPointLabel: "You are 3000 Points away from your wish", points: "5000")
        let data4 = WishListCellModel(mProductImage: #imageLiteral(resourceName: "camera"), mProductName: "Nikon D7000", mItemCode: "RNW1300", mProductPrice: "25,999", remainingPointLabel: "You are 3000 Points away from your wish", points: "30")
        let data5 = WishListCellModel(mProductImage: #imageLiteral(resourceName: "Sample_2"), mProductName: "BlackBerry z10 Black", mItemCode: "RNW2000", mProductPrice: "14000", remainingPointLabel: "You are 3000 Points away from your wish", points: "600")
        let data6 = WishListCellModel(mProductImage: #imageLiteral(resourceName: "camera"), mProductName: "Nikon D7000", mItemCode: "RNW1300", mProductPrice: "25,999", remainingPointLabel: "You are 3000 Points away from your wish", points: "450")
        
        dataSource = [data1, data2, data3, data4, data5, data6]
    }
}
