//
//  LandingTilesGridFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/25/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class LandingTilesGridFetcher: Fetcher {
    fileprivate var successHandler: (([LandingTilesGridCellModel]) -> Void)?

    func onSuccess(success: @escaping ([LandingTilesGridCellModel]) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchHomeFinal(content: String) {
        self.networkFetch(request: RequestFactory.homeLanding(content: content))
    }
    
    func fetchEarn() {
        self.networkFetch(request: RequestFactory.earnLanding())
    }
    
    func fetchBurn() {
        self.networkFetch(request: RequestFactory.burnLanding())
    }
    
    func fetchExplore() {
        self.networkFetch(request: RequestFactory.exploreLanding())
    }
    
    func fetchOfferGrid() {
        self.networkFetch(request: RequestFactory.offerLandingGrid())
    }
    
    override func parse(data: Data) {
        
        var items: LandingTilesGrid!
        
        let jsonDecoder = JSONDecoder()
        do {
            items = try jsonDecoder.decode(LandingTilesGrid.self, from: data)
            guard items.errorCode == nil else {
                errorHandler(items.errorMessage ?? "")
                return
            }
            var cellModelArray = [LandingTilesGridCellModel]()
            guard let imageGrid = items.imageGrid else {
                successHandler!(cellModelArray)
                return
            }
            for carousel in imageGrid {
                cellModelArray.append(LandingTilesGridCellModel(withImageGridData: carousel))
            }
            successHandler!(cellModelArray)
        } catch let jsonError {
            print("LandingTilesGridFetcher: Json Parsing Error: \(jsonError)")
        }
    }
}
