//
//  MemberDashBoardFetcher.swift
//  PayBack
//
//  Created by Dinakaran M on 17/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class MemberDashBoardFetcher: Fetcher {
    typealias SuccessHandler = ((MemberDashboard) -> Void)?
    fileprivate var successHandler: SuccessHandler = { _ in }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    func getMemberDetails() {
        let requestBody = RequestBody.getMemberDashboard()
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            
            let member = try jsonDecoder.decode(MemberDashboard.self, from: data)
            self.successHandler!(member)
        } catch let jsonError {
            print("MemberDashBoardFetcher: Json Parsing Error: \(jsonError)")
        }
    }
}
