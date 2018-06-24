//
//  BannerFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/20/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class BannerFetcher: Fetcher {
    typealias BannerSuccess = ((HeroBannerCellModel, Bool) -> Void)
    fileprivate var bannerSuccessHandler: BannerSuccess?
    
    func onBannerSuccess(success: @escaping BannerSuccess) -> Self {
        self.bannerSuccessHandler = success
        
        return self
    }
    
    func fetchBannerForShopOnline() {
        self.networkFetch(request: RequestFactory.heroBannerForShopOnline(component: "bannerimage"))
    }
    
    func fetchBannerForReward() {
        self.networkFetch(request: RequestFactory.bannerForReward())
    }
    
    func fetchBannerForPaybackPlus() {
        self.networkFetch(request: RequestFactory.bannerForPaybackPlus())
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
            guard let bannerImageObj = items.banneImageObj  else {
                self.bannerSuccessHandler!(HeroBannerCellModel(), true)
                return
            }
            let heroBannerDataModel = HeroBannerCellModel(withBannerImage: bannerImageObj)
            self.bannerSuccessHandler!(heroBannerDataModel, bannerImageObj.expired ?? false)
        } catch let jsonError {
            errorHandler(jsonError.localizedDescription)
            print("HeroBannerFetcher: Json Parsing Error: \(jsonError)")
        }
    }
}
