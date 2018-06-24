//
//  AccountAuthenticator.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/26/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class AccountAuthenticator: Fetcher {
    
    fileprivate var successHandler: (() -> Void)?
    
    @discardableResult
    func onSuccess(success: @escaping () -> Void) -> Self {
        self.successHandler = success
        return self
    }
    func authenticate(alias: String, aliasType: String, secret: String) {
        let requestBody = RequestBody.getAuthentication(alias: alias, aliasType: aliasType, secret: secret)
        self.networkFetch(request: RequestFactory.request(requestBody: requestBody))
    }
    
    override func parse(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let member = try jsonDecoder.decode(Member.self, from: data)
            if let token = member.token {
                self.saveToUserDefaults(token)
            }
            if let memberDashboard = member.getmemberdashboard {
                UserProfileUtilities.setUserProfile(forMemberDetails: memberDashboard)
            }
            self.successHandler!()
        } catch let jsonError {
            print("AccountAuthenticator: Json Parsing Error: \(jsonError)")
        }
        
    }
}

extension AccountAuthenticator {
    fileprivate func saveToUserDefaults(_ token: String) {
        UserProfileUtilities.setValueForKeyInUserDefaults(forKey: kSessionToken, andValue: token)
        UserProfileUtilities.setValueForKeyInUserDefaults(forKey: kIsUserLoged, andValue: true)
        let token = UserProfileUtilities.getAuthenticationToken()
        print("Token: \(token)")
    }
}
