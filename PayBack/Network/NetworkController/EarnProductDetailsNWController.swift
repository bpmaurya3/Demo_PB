//
//  EarnProductDetailsNWController.swift
//  PayBack
//
//  Created by Dinakaran M on 03/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

final internal class EarnProductDetailsNWController {
    var getEarnProductDetails = EarnProductDetailsFetcher()
   
    typealias SuccessHandler = ((EarnProductDetails) -> Void)?
    typealias ErrorHandler = ((String) -> Void)?
    typealias SpecificationHandler = (([SpecificationCellModel]) -> Void)?
    typealias ComparePrizeHandler = (([CompareCellModel]) -> Void)
    typealias ReviewHandler = (([ReviewCellModel]?, String?) -> Void)
    
    fileprivate var successHandler: SuccessHandler = { _ in }
    fileprivate var errorHandler: ErrorHandler = { _ in }
    fileprivate var comparePrizeHandler: ComparePrizeHandler = { _ in }
    fileprivate var specificationHandler: SpecificationHandler = { _ in }
    fileprivate var reviewHandler: ReviewHandler = { _, _ in }
    
    let deleteWishListFetcher = DeleteWishListFetcher()
    fileprivate var addWishListSuccessHandler: (String) -> Void = { _ in }
    fileprivate var addWishListErrorHandler: (String) -> Void = { _ in }

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
    @discardableResult
    func onComparePrize(comparePrizeData: @escaping ComparePrizeHandler) -> Self {
        self.comparePrizeHandler = comparePrizeData
        return self
    }
    @discardableResult
    func onSpecification(specificationData: SpecificationHandler) -> Self {
        self.specificationHandler = specificationData
        return self
    }
    @discardableResult
    func onReview(reviewData: @escaping ReviewHandler) -> Self {
        self.reviewHandler = reviewData
        return self
    }
    func getEarnProductDetails(productID: String) {
        getEarnProductDetails
            .onError { [weak self] (error) in
                self?.errorHandler!(error)
            }
            .onSuccess { [weak self] (productDetailModel) in
                self?.successHandler!(productDetailModel)
                self?.updateComparePrize(productDetails: productDetailModel)
                self?.updateSpecification(productDetails: productDetailModel)
                self?.updateReview(productDetails: productDetailModel)
            }
            .getProductDetails(productID: productID)
    }
    func updateReview(productDetails: EarnProductDetails) {
        guard let productReview = productDetails.reviews else {
            return
        }
        var reviewModelArray = [ReviewCellModel]()
        if let productReview = productReview.reviews {
            for data in productReview {
                let reviewData = data.value
                for review in reviewData {
                    let model = ReviewCellModel(avgReviewCount: 0, avgRatingCount: 0, avgRating: 0, rating: review.rating ?? 0, reviewTitle: review.title, reviewDate: review.created, reviewDetail: review.text, reviewCustName: review.author)
                    reviewModelArray.append(model!)
                }
            }
            self.reviewHandler(reviewModelArray, nil)
        } else {
            if let error = productReview.errors {
                if !error.isEmpty {
                    self.reviewHandler(nil, error[0].error)
                }
            }
        }
    }
    func updateSpecification(productDetails: EarnProductDetails) {
        guard let productSpecification = productDetails.featureAttribute else {
            return
        }
        var specificationModelArray = [SpecificationCellModel]()
        for data in productSpecification {
            if let name = data.name, let value = data.value {
           specificationModelArray.append(SpecificationCellModel(featureType: name, featureDetail: value)!)
            }
        }
        self.specificationHandler!(specificationModelArray)
    }
    
    func updateComparePrize(productDetails: EarnProductDetails) {
        guard let productData = productDetails.results else {
            return
        }
        var cellModelArray = [CompareCellModel]()
        for data in productData {
            cellModelArray.append(CompareCellModel(withProductDetails: data))
        }
        self.comparePrizeHandler(cellModelArray)
    }
}
extension EarnProductDetailsNWController {
    func addWishLish(loginUserEmail: String, productInfo: ProductInfo) {
        self.deleteWishListFetcher
            .onSuccess {[weak self] (success) in
                self?.addWishListSuccessHandler(success.message ?? "")
            }
            .onError {[weak self] (error) in
                self?.addWishListErrorHandler(error)
            }
            .addWishListForShopOnline(loginUserEmail: loginUserEmail, productInfo: productInfo)
    }
    @discardableResult
    func onAddWishListSuccess(success: @escaping (String) -> Void) -> Self {
        self.addWishListSuccessHandler = success
        return self
    }
    @discardableResult
    func onAddWishListError(error: @escaping (String) -> Void) -> Self {
        self.addWishListErrorHandler = error
        return self
    }
}
