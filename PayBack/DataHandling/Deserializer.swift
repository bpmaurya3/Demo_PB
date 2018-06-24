//
//  Deserializer.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/22/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class Deserializer {
    private let data: Data?

    private var successHandler: (([String: Any]) -> Void)?
    private var failureHandler: ((String) -> Void)?

    init(data: Data?) {
        self.data = data
    }

    func deserialize() {
        if let data = data {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let successHandler = successHandler {
                    successHandler(json)
                } else if let failureHandler = failureHandler {
                    failureHandler("")
                }
            } catch {
                if let failureHandler = failureHandler {
                    failureHandler(error.localizedDescription)
                }
            }
        } else if let failureHandler = failureHandler {
            failureHandler("")
        }
    }

    func onSuccess(success: @escaping ([String: Any]) -> Void) -> Self {
        self.successHandler = success

        return self
    }

    func onFailure(failure: @escaping ((String) -> Void)) -> Self {
        self.failureHandler = failure
        return self
    }
}
