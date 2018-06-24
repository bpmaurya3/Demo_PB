//
//  WriteToUsFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 6/11/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
final internal class WriteToUsFetcher: Fetcher {
    fileprivate var successHandler: ((WriteToUsModel) -> Void)?
    
    func onSuccess(success: @escaping (WriteToUsModel) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func sendFeedBack(email: String?, mobileNo: String?, message: String, toEmail: String?) {
        self.networkFetch(request: RequestFactory.writeToUs(email: email, mobileNo: mobileNo, message: message, toEmail: toEmail))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let resultArray = try jsonDecoder.decode(WriteToUsModel.self, from: data)
            successHandler!(resultArray)
        } catch let jsonError {
            print("CouponsFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
}
