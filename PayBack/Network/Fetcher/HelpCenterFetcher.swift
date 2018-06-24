//
//  HelpCenterFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/6/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class HelpCenterFetcher: Fetcher {
    fileprivate var successHandler: ((HelpCenter) -> Void)?
    
    func onSuccess(success: @escaping (HelpCenter) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchHelpCenter() {
        self.networkFetch(request: RequestFactory.helpCenter())
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let helpCenter = try jsonDecoder.decode(HelpCenter.self, from: data)
            guard helpCenter.errorCode == nil else {
                errorHandler(helpCenter.errorMessage ?? "")
                return
            }
            successHandler!(helpCenter)
        } catch let jsonError {
            print("HelpCenterFetcher: Json Parsing Error: \(jsonError)")
        }
    }
}
