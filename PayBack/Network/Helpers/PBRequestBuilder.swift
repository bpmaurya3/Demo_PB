//
//  PBRequestBuilder.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/22/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

class RequestBuilder {
    enum MethodType: String {
        case POST, GET, PUT, DELETE
    }
    
    private var methodType: MethodType = .GET
    private var urlString: String?
    private var httpBody: Data?
    private var contentType: String?

    private var additionalHeaders: [String: String]?
    
    private var accept: String?
    
    private var authorizationToken: String?
    
    func ofType(_ type: MethodType) -> Self {
        methodType = type
        return self
    }
    
    func set(urlString: String) -> Self {
        self.urlString = urlString
        return self
    }
    
    func set(httpBodyFromString: String) -> Self {
        self.httpBody = httpBodyFromString.data(using: .utf8)
        return self
    }
    
    func set(httpBody: Data) -> Self {
        self.httpBody = httpBody
        return self
    }
    
    func set(contentType: String) -> Self {
        self.contentType = contentType
        return self
    }
    
    func set(authorizationToken: String) -> Self {
        self.authorizationToken = authorizationToken
        return self
    }
    
    func set(accept: String) -> Self {
        self.accept = accept
        return self
    }
    
    func set(additionalHeaders: [String: String]) -> Self {
        self.additionalHeaders = additionalHeaders
        return self
    }
    
    func build() -> URLRequest? {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = methodType.rawValue
       
        if let contentType = contentType {
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        if let authorizationToken = authorizationToken {
            request.addValue(authorizationToken, forHTTPHeaderField: "auth-token")
        }
        
        if let httpBody = httpBody {
            request.httpBody = httpBody
        }
        
        return request
    }
}
