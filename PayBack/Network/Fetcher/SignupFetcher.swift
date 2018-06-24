//
//  SignupFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 1/19/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

final internal class SignupFetcher: Fetcher {
    fileprivate var successHandler: ((SignupImageGridModel) -> Void)?
    
    func onSuccess(success: @escaping (SignupImageGridModel) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetch() {
        self.networkFetch(request: RequestFactory.signupImageGrid())
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let items = try jsonDecoder.decode(SignupImageGridModel.self, from: data)
            guard items.errorCode == nil else {
                errorHandler(items.errorMessage ?? "")
                return
            }
            successHandler!(items)
        } catch let jsonError {
            errorHandler(jsonError.localizedDescription)
            print("SignupFetcher: Json Parsing Error: \(jsonError)")
        }
    }
}
