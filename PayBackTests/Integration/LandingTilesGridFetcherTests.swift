//
//  LandingTilesGridFetcherTests.swift
//  PayBackTests
//
//  Created by Bhuvanendra Pratap Maurya on 9/28/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

@testable import PayBack
import XCTest

class LandingTilesGridFetcherTests: XCTestCase {
    let timeout = 10.0
    let fetcher = LandingTilesGridFetcher()
    
    func testFetchHomeFinal() {
        let exp = expectation(description: "Retreived HomeFinal data")
        
        fetcher
            .onSuccess { (onboard) in
                print("\(onboard)")
                exp.fulfill()
            }
            .onError { (_) in
                XCTFail()
            }
            .fetchHomeFinal(content: "home-loggedout")
        
        waitForExpectations(timeout: timeout) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testFetchEarn() {
        let exp = expectation(description: "Retreived Earn Landing data")
        
        fetcher
            .onSuccess { (onboard) in
                print("\(onboard)")
                exp.fulfill()
            }
            .onError { (_) in
                XCTFail()
            }
            .fetchEarn()
        
        waitForExpectations(timeout: timeout) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testFetchBurn() {
        let exp = expectation(description: "Retreived Burn Landing data")
        
        fetcher
            .onSuccess { (onboard) in
                print("\(onboard)")
                exp.fulfill()
            }
            .onError { (_) in
                XCTFail()
            }
            .fetchBurn()
        
        waitForExpectations(timeout: timeout) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testFetchExplore() {
        let exp = expectation(description: "Retreived Explore Landing data")
        
        fetcher
            .onSuccess { (onboard) in
                print("\(onboard)")
                exp.fulfill()
            }
            .onError { (_) in
                XCTFail()
            }
            .fetchExplore()
        
        waitForExpectations(timeout: timeout) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testFetchOfferGrid() {
        let exp = expectation(description: "Retreived Offer Grid data")
        
        fetcher
            .onSuccess { (onboard) in
                print("\(onboard)")
                exp.fulfill()
            }
            .onError { (_) in
                XCTFail()
            }
            .fetchOfferGrid()
        
        waitForExpectations(timeout: timeout) { (error) in
            XCTAssertNil(error)
        }
    }
}
