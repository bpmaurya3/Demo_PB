//
//  Notifications.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 12/7/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct Notifications: Decodable {
    let statusCode: String?
    let message: String?
    
    let userid: String?
    
    let notifications: [Notification]?
    
    struct Notification: Decodable {
        let title: String?
        let description: String?
        let createdDate: String?
        let imageUrl: String?
        let id: String?
    }
}
