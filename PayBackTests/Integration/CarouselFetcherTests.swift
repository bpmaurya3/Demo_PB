//
//  CarouselFetcherTests.swift
//  PayBackTests
//
//  Created by Bhuvanendra Pratap Maurya on 11/14/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
import XCTest

class CarouselFetcherTests: XCTestCase {
    
    let timeout = 10.0
    let fetcher = CarouselFetcher()
    
    func testFetchingOnboardData() {
        let exp = expectation(description: "Retreived onboard data")
        
        fetcher
            .onSuccess { (onboard) in
                print("\(onboard)")
                exp.fulfill()
            }
            .onError { (_) in
                XCTFail()
            }
            .fetchOnboard()
        
        waitForExpectations(timeout: timeout) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testFetchCouponsCarousel() {
        let exp = expectation(description: "Retreived CouponsCarousel data")
        
        fetcher
            .onSuccess { (onboard) in
                print("\(onboard)")
                exp.fulfill()
            }
            .onError { (_) in
                XCTFail()
            }
            .fetchCouponsCarousel()
        
        waitForExpectations(timeout: timeout) { (error) in
            XCTAssertNil(error)
        }
    }
    func testFetchRechargeCarousel() {
        let exp = expectation(description: "Retreived RechargeCarousel data")
        
        fetcher
            .onSuccess { (onboard) in
                print("\(onboard)")
                exp.fulfill()
            }
            .onError { (_) in
                XCTFail()
            }
            .fetchRechargeCarousel()
        
        waitForExpectations(timeout: timeout) { (error) in
            XCTAssertNil(error)
        }
    }
    func testFetchInsuranceCarousel() {
        let exp = expectation(description: "Retreived InsuranceCarousel data")
        
        fetcher
            .onSuccess { (onboard) in
                print("\(onboard)")
                exp.fulfill()
            }
            .onError { (_) in
                XCTFail()
            }
            .fetchInsuranceCarousel()
        
        waitForExpectations(timeout: timeout) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testFetchHelpCenterCarousel() {
        let exp = expectation(description: "Retreived HelpCenterCarousel data")
        
        fetcher
            .onSuccess { (onboard) in
                print("\(onboard)")
                exp.fulfill()
            }
            .onError { (_) in
                XCTFail()
            }
            .fetchHelpCenterCarousel()
        
        waitForExpectations(timeout: timeout) { (error) in
            XCTAssertNil(error)
        }
    }
}
