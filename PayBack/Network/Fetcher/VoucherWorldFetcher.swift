//
//  VoucherWorldFetcher.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 17/05/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
import UIKit

class VoucherWorldFetcher: Fetcher {
    fileprivate var successHandler: ((VoucherWorldModel) -> Void)?
    
    func onSuccess(success: @escaping (VoucherWorldModel) -> Void) -> Self {
        self.successHandler = success
        return self
    }

    func fetchVoucherWorld() {
        let authToken = UserProfileUtilities.getAuthenticationToken()
        let params = RequestBody.getVoucherWorld(token: authToken)
        self.networkFetch(request: RequestFactory.request(requestBody: params))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let vouchers = try jsonDecoder.decode(VoucherWorldModel.self, from: data)
            successHandler!(vouchers)
        } catch let jsonError {
            print("Top Trend: Json Parsing Error: \(jsonError)")
        }
    }
}
