//
//  MemberDashBoardNWController.swift
//  PayBack
//
//  Created by Dinakaran M on 17/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class MemberDashBoardNWController {
    
    var getMemberDashboardFetcher = MemberDashBoardFetcher()
    
    typealias SuccessHandler = ((MemberDashboard) -> Void)?
    typealias ErrorHandler = ((String) -> Void)?
    typealias UpdateDashBoardDetails = ((Bool) -> Void)?
    
    fileprivate var successHandler: SuccessHandler = { _ in }
    fileprivate var errorHandler: ErrorHandler = { _ in }
    fileprivate var tokenExpiredHandler: (() -> Void) = { }
    fileprivate var updateDashBoardDetails: UpdateDashBoardDetails = { _ in }
    
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
    func onTokenExpired(tokenExpired: @escaping (() -> Void)) -> Self {
        self.tokenExpiredHandler = tokenExpired
        
        return self
    }
    
    @discardableResult
    func onUpdatedashBoard(closure: UpdateDashBoardDetails) -> Self {
        self.updateDashBoardDetails = closure
        return self
    }
    func getMemberDetails() {
        getMemberDashboardFetcher
            .onTokenExpired(tokenExpired: tokenExpiredHandler)
            .onError { [weak self] (error) in
                self?.errorHandler!(error)
            }
            .onSuccess { [weak self] (memberModel) in
                self?.updateProfileDetails(member: memberModel)
                self?.successHandler!(memberModel)
            }
           .getMemberDetails()
    }
    func updateProfileDetails(member: MemberDashboard) {
        UserProfileUtilities.setUserProfile(forMemberDetails: member)
        self.updateDashBoardDetails!(true)
    }
}
