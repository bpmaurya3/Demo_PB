//
//  CreateOrderFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/28/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

class CreateOrderFetcher: Fetcher {
    fileprivate var successHandler: ((String) -> Void)?

    @discardableResult
    func onSuccess(success: @escaping (String) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func createOrder(shipmentInfo: AddressSplitCellModel, productInfo: CreateOrderProductInfoModel) {
        let requestBody = RequestBody.getCreateOrder(shipmentInfo: shipmentInfo, productInfo: productInfo)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    override func parse(data: Data) {
        let response = String(data: data, encoding: .utf8)
        print("Create Order Response: \(response ?? "No Response")")
        let jsonDecoder = JSONDecoder()
        do {
            let creatOrder = try jsonDecoder.decode(AddToCart.self, from: data)
            successHandler!(creatOrder.message ?? "")
        } catch let jsonError {
            print("creatOrder: Json Parsing Error: \(jsonError)")
        }
    }
}
