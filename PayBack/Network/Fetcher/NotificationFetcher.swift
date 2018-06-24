//
//  NotificationFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 12/7/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class NotificationFetcher: Fetcher {
    fileprivate var successHandler: ((Notifications) -> Void)?
    
    func onSuccess(success: @escaping (Notifications) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    func fetchNotification(withUserid userId: String) {
        let params = RequestBody.getNotification(userId: userId)
        self.networkFetch(request: RequestFactory.request(requestBody: params))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let notification = try jsonDecoder.decode(Notifications.self, from: data)
            successHandler!(notification)
        } catch let jsonError {
            print("Top Trend: Json Parsing Error: \(jsonError)")
        }
    }
}
