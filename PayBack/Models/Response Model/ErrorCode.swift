//
//  ErrorCode.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 12/27/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct ErrorCode: Decodable {
    let statusCode: String?
    let message: String?
    
    let errorCode: String?
    let errorMessage: String?
}
