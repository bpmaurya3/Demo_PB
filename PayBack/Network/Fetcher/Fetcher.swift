//
//  Fetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/22/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

class Fetcher: Equatable {
    
    var name: String { return String(describing: self) }
    
    var errorHandler: ((String) -> Void) = { _ in }
    var tokenExpiredHandler: (() -> Void) = { }
    fileprivate var session: URLSession?
    func networkFetch(request: URLRequest) {
        
        // It works only in Devices
        if !Platform.isSimulator {
            guard ReachabilityManager.shared.isNetworkAvailable else {
                self.errorHandler("No Network conection")
                return
            }
        }
        let sessionConfig = URLSessionConfiguration.default
        session = URLSession(configuration: sessionConfig)
        let task = session!.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let strongSelf = self else {
                return
            }
            
            if let error = error {
                print("Request Error: \(error)")
                DispatchQueue.main.async { [weak strongSelf] in
                    if let strongSelf2 = strongSelf {
                        strongSelf2.errorHandler(String(error.localizedDescription))
                    }
                }
                return
            }
            if let response = response as? HTTPURLResponse {
                strongSelf.handleDataTaskResults(forData: data, response: response)
            }
        })
        
        task.resume()
    }
    
    func networkFetchSynchronously(request: URLRequest) {
        let sem = DispatchSemaphore(value: 0)
        // It works only in Devices
        if !Platform.isSimulator {
            guard ReachabilityManager.shared.isNetworkAvailable else {
                self.errorHandler("No Network conection")
                return
            }
        }
        let sessionConfig = URLSessionConfiguration.default
        session = URLSession(configuration: sessionConfig)
        let task = session!.dataTask(with: request, completionHandler: {  [weak self] (data, response, error) in
            sem.signal()
            guard let strongSelf = self else {
                return
            }
            
            if let error = error {
                print("Request Error: \(error)")
                DispatchQueue.main.async { [weak strongSelf] in
                    if let strongSelf2 = strongSelf {
                        strongSelf2.errorHandler(String(error.localizedDescription))
                    }
                }
                return
            }
            if let response = response as? HTTPURLResponse {
                strongSelf.handleDataTaskResults(forData: data, response: response)
            }
        })
        
        task.resume()
        _ = sem.wait(timeout: DispatchTime.distantFuture)
    }
    // Cancel Request
    func cancelTask() {
        guard let session = session else {
            return
        }
        session.getAllTasks { (dataTasks) in
            for task in dataTasks {
                task.cancel()
            }
        }
        //task.cancel()
    }
    // MARK: - Parser
    
    func parse(data: Data) {
        fatalError("Subclass should implement this function")
    }
    
    // MARK: - Handlers
    
    @discardableResult
    func onError(error: @escaping ((String) -> Void)) -> Self {
        self.errorHandler = error
        
        return self
    }
    func onTokenExpired(tokenExpired: @escaping (() -> Void)) -> Self {
        self.tokenExpiredHandler = tokenExpired
        
        return self
    }
    
    // swiftlint:disable operator_whitespace
    static func ==(lhs: Fetcher, rhs: Fetcher) -> Bool {
        return lhs === rhs
    }
    // swiftlint:enable operator_whitespace
}

// MARK: - Data / Response

extension Fetcher {
    
    fileprivate func handleDataTaskResults(forData data: Data?, response: HTTPURLResponse) {
        switch response.statusCode {
        case 200:
            DispatchQueue.main.async { [weak self] in
                self?.extract(data: data)
            }
        case 500:
            self.errorHandler("Internal server error - 500")
        default:
            self.errorHandler("Internal error - Please try again")
            break
        }
    }
    
    fileprivate func extract(data: Data?) {
        let jsonDecoder = JSONDecoder()
        do {
            let error = try jsonDecoder.decode(ErrorCode.self, from: data!)
            guard error.statusCode == nil else {
                self.handleErrorCode(error: error, data: data)
                return
            }
            self.parse(data: data!)
        } catch {
            self.parse(data: data!)
        }
    }
    
    fileprivate func handleErrorCode(error: ErrorCode, data: Data?) {
        switch error.statusCode! {
        case StringConstant.orderDetailsInvalidTokenStatusCode, StringConstant.invalidTokenStatusCode, StringConstant.orderListInvalidTokenStatusCode, StringConstant.CartReviewInvalidTokenStatusCode :
            self.tokenExpiredHandler()
        case StringConstant.successStatusCode:
            self.parse(data: data!)
        default:
            self.errorHandler(error.message ?? StringConstant.typeCodeDefaultErrorMessage)
        }
    }
}
