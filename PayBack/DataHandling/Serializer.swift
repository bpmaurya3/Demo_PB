//
//  Serializer.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/22/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class Serializer {
    private let dictionary: [String: Any]?

    private var successHandler: ((Data) -> Void)?
    private var failureHandler: ((String) -> Void)?

    init(dictionary: [String: Any]?) {
        self.dictionary = dictionary
    }

    func serialize() {
        if let dictionary = dictionary {
            do {
                if let data = try? JSONSerialization.data(withJSONObject: dictionary), let successHandler = successHandler {
                    if let json = String(data: data, encoding: .utf8) {
                        print("Serialize Encoded Json: \(json)")
                    }
                    successHandler(data)
                } else if let failureHandler = failureHandler {
                    failureHandler("")
                }
            }
        } else if let failureHandler = failureHandler {
            failureHandler("")
        }
    }

    func onSuccess(success: @escaping (Data) -> Void) -> Self {
        self.successHandler = success

        return self
    }
    
    func onFailure(failure: @escaping ((String) -> Void)) -> Self {
        self.failureHandler = failure
        
        return self
    }
}
