//
//  InStoreListFetcher.swift
//  PayBack
//
//  Created by valtechadmin on 4/24/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

final internal class InStoreListFetcher: Fetcher {
    
    typealias SuccessHandler = ((InstoreListModel) -> Void)?
    fileprivate var successHandler: SuccessHandler = { _ in }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    
    func getInStoreListNear(lattitude: String, longitude: String, filterParams: StoreLocaterFilterParameters) {
        
        let latt = (filterParams.city == "" || filterParams.city == nil) ? lattitude : ""
        let longi = (filterParams.city == "" || filterParams.city == nil) ? longitude : ""
        let data = InStoreListRequestModel.Data(latitude: latt, longitude: longi, category: filterParams.category ?? "", partner: filterParams.partner ?? "", city: filterParams.city ?? "")
        let requestBody = RequestBody.instoreList(type: "storeLocator", data: data)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(InstoreListModel.self, from: data)
            self.successHandler!(response)
        } catch let jsonError {
            print("InStore list: Json Parsing Error: \(jsonError)")
        }
    }
    
}
