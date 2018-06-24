//
//  WishListFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 1/29/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

final internal class WishListFetcher: Fetcher {
    fileprivate var successHandler: ((WishListModel) -> Void)?
    
    func onSuccess(success: @escaping (WishListModel) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchCombineWishList(loginUserEmail: String, userId: String) {
        let requestBody = RequestBody.getCombineWishList(userEmail: loginUserEmail, userId: userId )
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let resultArray = try jsonDecoder.decode(WishListModel.self, from: data)
            successHandler!(resultArray)
        } catch let jsonError {
            print("WishListFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
}
