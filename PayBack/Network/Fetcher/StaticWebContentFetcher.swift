//
//  StaticWebContentFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 1/31/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

final internal class StaticWebContentFetcher: Fetcher {
    fileprivate var successHandler: ((StaticWebContentModel) -> Void)?
    
    func onSuccess(success: @escaping (StaticWebContentModel) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchStaticWebContent() {
        self.networkFetch(request: RequestFactory.getStaticWebContent())
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let resultArray = try jsonDecoder.decode(StaticWebContentModel.self, from: data)
            successHandler!(resultArray)
        } catch let jsonError {
            print("WishListFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
}
