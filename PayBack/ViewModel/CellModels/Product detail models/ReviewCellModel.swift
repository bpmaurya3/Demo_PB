//
//  ReviewModel.swift
//  PaybackPopup
//
//  Created by Mohsin Surani on 31/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

class ReviewCellModel: NSObject {
    var avgRatingCount: Int?
    var avgReviewCount: Int?
    var avgRating: Int?
    var rating: Int?
    var reviewTitle: String?
    var reviewDetail: String?
    var reviewDate: String?
    var reviewCustName: String?
    
    init?(avgReviewCount: Int, avgRatingCount: Int, avgRating: Int, rating: Int, reviewTitle: String?, reviewDate: String?, reviewDetail: String?, reviewCustName: String?) {
        
        self.avgRatingCount = avgRatingCount
        self.avgReviewCount = avgReviewCount
        self.avgRating = avgRating
        self.rating = rating
        self.reviewTitle = reviewTitle
        self.reviewDate = reviewDate
        self.reviewDetail = reviewDetail
        self.reviewCustName = reviewCustName
    }
    init(withRedeemReview review: String) {
        self.avgReviewCount = 0
        self.avgRating = 0
        self.avgRatingCount = 0
        
        self.reviewDetail = review
    }
}
