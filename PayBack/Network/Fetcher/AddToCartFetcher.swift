//
//  AddToCartFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 12/13/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

class AddToCartFetcher: Fetcher {
    fileprivate var successHandler: ((String) -> Void)?
    
    func onSuccess(success: @escaping (String) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    func addToCart(withQuantity quantity: String, productId: String) {
        let userId = UserProfileUtilities.getUserID()
        if userId == "" {
            self.errorHandler("Login is required to complete this operation")
            return
        }
        let params = RequestBody.getAddToCart(quantity: quantity, productId: productId)
        self.networkFetch(request: RequestFactory.request(requestBody: params))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let addToCart = try jsonDecoder.decode(AddToCart.self, from: data)
            successHandler!(addToCart.message ?? "")
        } catch let jsonError {
            print("AddToCart: Json Parsing Error: \(jsonError)")
        }
    }
}
