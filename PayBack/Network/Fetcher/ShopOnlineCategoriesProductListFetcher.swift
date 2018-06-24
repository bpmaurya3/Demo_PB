//
//  ShopOnlineCategoriesProductListFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 1/23/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
final internal class ShopOnlineCategoriesProductListFetcher: Fetcher {
    fileprivate var successHandler: ((CategoryProduct) -> Void)?
    
    func onSuccess(success: @escaping (CategoryProduct) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchShopOnlineCategoriesProductList(withParams params: ShopOnlineProductParamsModel) {
        let requestBody = RequestBody.getShopOnlineCategoriesProductList(params: params)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    func fetchElectronicsAndAppliances(withParams params: ShopOnlineProductParamsModel) {
        let requestBody = RequestBody.getShopOnlineCategoriesProductList(params: params)
        self.networkFetchSynchronously(request: RequestFactory.request(requestBody: requestBody))
    }
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let items = try jsonDecoder.decode(CategoryProduct.self, from: data)
            successHandler!(items)
        } catch let jsonError {
            errorHandler(jsonError.localizedDescription)
            print("ShopOnlineCategoriesProductListFetcher: Json Parsing Error: \(jsonError)")
        }
    }
}
