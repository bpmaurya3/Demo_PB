//
//  OtherOnlinePartnerFetcherTests.swift
//  PayBackTests
//
//  Created by Bhuvanendra Pratap Maurya on 9/21/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

@testable import PayBack
import XCTest

class OtherOnlinePartnerFetcherTests: XCTestCase {
    
    func testFetchingOtherOnlinePartnerTiles() {
        let exp = expectation(description: "Retreive Other Online Partner tiles")
        let timeOut = 10.0
        
        let fetcher = OnlinePartnerFetcher()
        
        fetcher
            .onSuccess { (otherPartner) in
                print(otherPartner)
                exp.fulfill()
            }
            .onError { _ in
                XCTFail()
            }
            .fetch(onlinePartnerFor: .otherOnlinePartner)
        
        waitForExpectations(timeout: timeOut) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testFetchingBurnOnlinePartnerTiles() {
        let exp = expectation(description: "Retreive Burn Online Partner tiles")
        let timeOut = 10.0
        
        let fetcher = OnlinePartnerFetcher()
        
        fetcher
            .onSuccess { (otherPartner) in
                print(otherPartner)
                exp.fulfill()
            }
            .onError { _ in
                XCTFail()
            }
            .fetch(onlinePartnerFor: .burnOnlinePartner)
        
        waitForExpectations(timeout: timeOut) { (error) in
            XCTAssertNil(error)
        }
    }
    
}
