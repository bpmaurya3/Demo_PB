//
//  HeroBannerFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/20/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class PlacardFetcher: Fetcher {
    typealias PlacardSuccess = ((HeroBannerCellModel, Bool) -> Void)

    fileprivate var placardSuccessHandler: PlacardSuccess?
    
    func onPlacardSuccess(success: @escaping PlacardSuccess) -> Self {
        self.placardSuccessHandler = success
        
        return self
    }
    
    func fetchPlacardForShopOnline() {
        self.networkFetch(request: RequestFactory.heroBannerForShopOnline(component: "partnerplacard"))
    }
    func fetchPlacardForReward() {
        self.networkFetch(request: RequestFactory.plaCardForReward())
    }
    override func parse(data: Data) {
        
        var items: HeroBanner!
        
        let jsonDecoder = JSONDecoder()
        do {
            items = try jsonDecoder.decode(HeroBanner.self, from: data)
            guard items.errorCode == nil else {
                errorHandler(items.errorMessage ?? "")
                return
            }
            guard let placardDetails = items.partnerPlacardDetails else {
                self.placardSuccessHandler!(HeroBannerCellModel(), true)
                return
            }
            let heroBannerDataModel = HeroBannerCellModel(withPlacard: placardDetails)
            self.placardSuccessHandler!(heroBannerDataModel, placardDetails.expired ?? false)
        } catch let jsonError {
            errorHandler(jsonError.localizedDescription)
            print("PlacardFetcher: Json Parsing Error: \(jsonError)")
        }
    }
}
