//
//  OnlineOffersFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 2/10/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
final internal class OnlineOffersFetcher: Fetcher {
    fileprivate var successHandler: ((OnlineOffersModel) -> Void)?
    
    func onSuccess(success: @escaping (OnlineOffersModel) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchOnlineOffers(page: String, per_page: String = "10", filer: [String: String]) {
        let requestData = RequestBody.onlineOffers(page: page, per_page: per_page, filer: filer)
        self.networkFetch(request: RequestFactory.request(requestBody: requestData))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let resultArray = try jsonDecoder.decode(OnlineOffersModel.self, from: data)
            successHandler!(resultArray)
        } catch let jsonError {
            print("OnlineOffersFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
}
