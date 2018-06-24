//
//  HomeFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 5/17/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

final internal class HomeFetcher: Fetcher {
    
    typealias SuccessHandler = ((HomeModel) -> Void)?
    fileprivate var successHandler: SuccessHandler = { _ in }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    
    func getHomeContent() {
        self.networkFetch(request: RequestFactory.extentedHome())
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(HomeModel.self, from: data)
            self.successHandler!(response)
        } catch let jsonError {
            print("InStore list: Json Parsing Error: \(jsonError)")
        }
    }
    
}
