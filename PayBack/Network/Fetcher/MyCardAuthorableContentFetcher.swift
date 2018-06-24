//
//  MyCardAuthorableContentFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 4/3/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

final internal class MyCardAuthorableContentFetcher: Fetcher {
    fileprivate var successHandler: ((MyCardContent) -> Void)?
    
    func onSuccess(success: @escaping (MyCardContent) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetch() {
        self.networkFetch(request: RequestFactory.myCardContent())
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let result = try jsonDecoder.decode(MyCardContent.self, from: data)
            successHandler!(result)
        } catch let jsonError {
            print("OnlineOffersFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
}
