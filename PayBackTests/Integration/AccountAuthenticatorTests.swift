//
//  AccountAuthenticatorTests.swift
//  PayBackTests
//
//  Created by Bhuvanendra Pratap Maurya on 9/28/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

@testable import PayBack
import XCTest

class AccountAuthenticatorTests: XCTestCase {
    
    let timeout = 10.0
    
    func testAuthenticationWithValidCredentials() {
        
        let authenticator = AccountAuthenticator()
        
        let auth = AuthenticationModel(authenticationRequest: AuthenticateRequestStruct(authentiction: AuthenticationStruct(identity: IdentificationStruct(alias: "9313891689", aliasType: "3"), security: SecurityStruct(secret: "3166", secretType: "4"))))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(auth) {
            let exp = expectation(description: "Authenticate user")
            authenticator
                .onSuccess { 
                    exp.fulfill()
                }
                .onError { (error) in
                    XCTAssertNil(error)
                    XCTFail()
                }
                .authenticate(withCredential: encodedData)
        }
        waitForExpectations(timeout: timeout) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testAuthenticationWithWrongCredentials() {
        
        let authenticator = AccountAuthenticator()
        
        let auth = AuthenticationModel(authenticationRequest: AuthenticateRequestStruct(authentiction: AuthenticationStruct(identity: IdentificationStruct(alias: "9313894589", aliasType: "3"), security: SecurityStruct(secret: "2237", secretType: "4"))))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(auth) {
            let exp = expectation(description: "Authentication failed")
            authenticator
                .onSuccess { 
                    XCTFail()
                }
                .onError { (error) in
                    print("\(error)")
                    exp.fulfill()
                }
                .authenticate(withCredential: encodedData)
        }
        waitForExpectations(timeout: timeout) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testAuthenticationWithWrongMobileNo() {
        
        let authenticator = AccountAuthenticator()
        
        let auth = AuthenticationModel(authenticationRequest: AuthenticateRequestStruct(authentiction: AuthenticationStruct(identity: IdentificationStruct(alias: "9313894589", aliasType: "3"), security: SecurityStruct(secret: "2017", secretType: "4"))))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(auth) {
            let exp = expectation(description: "Authentication failed")
            authenticator
                .onSuccess {
                    XCTFail()
                }
                .onError { (_) in
                    exp.fulfill()
                }
                .authenticate(withCredential: encodedData)
        }
        waitForExpectations(timeout: timeout) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testAuthenticationWithWrongPIN() {
        
        let authenticator = AccountAuthenticator()
        
        let auth = AuthenticationModel(authenticationRequest: AuthenticateRequestStruct(authentiction: AuthenticationStruct(identity: IdentificationStruct(alias: "9313891689", aliasType: "3"), security: SecurityStruct(secret: "2217", secretType: "4"))))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(auth) {
            let exp = expectation(description: "Authentication failed")
            authenticator
                .onSuccess {
                    XCTFail()
                }
                .onError { (_) in
                    exp.fulfill()
                }
                .authenticate(withCredential: encodedData)
        }
        waitForExpectations(timeout: timeout) { (error) in
            XCTAssertNil(error)
        }
    }
}
