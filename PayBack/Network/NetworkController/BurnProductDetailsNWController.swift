//
//  BurnProductDetailsNWController.swift
//  PayBack
//
//  Created by Dinakaran M on 31/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class BurnProductDetailsNWController {
    var getBurnProductDetails = BurnProductDetailsFetcher()
    typealias SuccessHandler = ((BurnProductDetails) -> Void)?
    typealias ErrorHandler = ((String) -> Void)?
    
    fileprivate var successHandler: SuccessHandler = { _ in }
    fileprivate var errorHandler: ErrorHandler = { _ in }
    
    @discardableResult
    func onSuccess(success: SuccessHandler) -> Self {
        self.successHandler = success
        return self
    }
    @discardableResult
    func onError(error: ErrorHandler) -> Self {
        self.errorHandler = error
        return self
    }
    func getBurnProductDetails(productID: String) {
        getBurnProductDetails
            .onError { [weak self] (error) in
                self?.errorHandler!(error)
            }
            .onSuccess { [weak self] (productDetailModel) in
                self?.successHandler!(productDetailModel)
            }
            .getProductDetails(productID: productID)
    }
}
