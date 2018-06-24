//
//  DeleteWishListFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 1/30/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

final internal class DeleteWishListFetcher: Fetcher {
    fileprivate var successHandler: ((ErrorCode) -> Void)?
    
    func onSuccess(success: @escaping (ErrorCode) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func deleteWishListForShopOnline(loginUserEmail: String, productId: String) {
        let requestBody = RequestBody.deleteWishListForShopOnline(userEmail: loginUserEmail, productId: productId)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    func addWishListForShopOnline(loginUserEmail: String, productInfo: ProductInfo) {
        let requestBody = RequestBody.addWishListForShopOnline(userEmail: loginUserEmail, productInfo: productInfo)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    func addWishListForRewards(requestModel: RewardsAddWishListRequestModel) {
        let requestBody = RequestBody.addWishListForRewards(requestBody: requestModel)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    func deleteWishListForRewards(userId: String, wishListId: String) {
        let requestBody = RequestBody.deleteWishListForRewards(userId: userId, wishlistId: wishListId)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let resultArray = try jsonDecoder.decode(ErrorCode.self, from: data)
            successHandler!(resultArray)
        } catch let jsonError {
            print("WishListFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
}
