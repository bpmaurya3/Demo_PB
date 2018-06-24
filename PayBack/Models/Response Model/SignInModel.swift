//
//  SignInModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 1/19/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct SignInModel: Decodable {
    let errorCode: String?
    let errorMessage: String?
    
    let signInContents: SignInContents
    
    struct SignInContents: Decodable {
        let signInImage: String?
        let signInText: String?
        let showDateOfBirth: Bool?
    }
}
