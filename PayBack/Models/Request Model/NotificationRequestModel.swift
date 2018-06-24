//
//  NotificationRequestModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 12/7/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct NotificationRequestModel: Encodable {
    let ViewUserNotificationsRequest: ViewUserNotifications
    
    init(viewUserNotification: ViewUserNotifications) {
        self.ViewUserNotificationsRequest = viewUserNotification
    }
    struct ViewUserNotifications: Encodable {
        let userid: String
        
        init(userId: String) {
            self.userid = userId
        }
    }
}
