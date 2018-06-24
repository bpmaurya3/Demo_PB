//
//  BurnProductListFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/19/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
final internal class BurnProductListFetcher: Fetcher {
    fileprivate var successHandler: ((RedeemProduct) -> Void)?
    
    func onSuccess(success: @escaping (RedeemProduct) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchProductList(withParams params: BurnProductParamsModel) {
        let requestBody = RequestBody.getBurnProductList(params: params)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    override func parse(data: Data) {
        
        let jsonDecoder = JSONDecoder()
        do {
            let result = try jsonDecoder.decode(RedeemProduct.self, from: data)
            successHandler!(result)
            
        } catch let jsonError {
            self.errorHandler(jsonError.localizedDescription)
            print("BurnProductListFetcher: Json Parsing Error: \(jsonError)")
        }
    }
}
