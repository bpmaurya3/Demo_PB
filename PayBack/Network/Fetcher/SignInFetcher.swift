//
//  SignInFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 1/19/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

final internal class SignInFetcher: Fetcher {
    fileprivate var successHandler: ((SignInModel) -> Void)?
    
    func onSuccess(success: @escaping (SignInModel) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetch() {
        self.networkFetch(request: RequestFactory.signIn())
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let items = try jsonDecoder.decode(SignInModel.self, from: data)
            guard items.errorCode == nil else {
                errorHandler(items.errorMessage ?? "")
                return
            }
            successHandler!(items)
        } catch let jsonError {
            errorHandler(jsonError.localizedDescription)
            print("SignIn: Json Parsing Error: \(jsonError)")
        }
    }
}
