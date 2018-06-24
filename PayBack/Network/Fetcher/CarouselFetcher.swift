//
//  CarouselFetcher.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/30/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class CarouselFetcher: Fetcher {
    typealias CarouselSuccess = (([HeroBannerCellModel], Bool) -> Void)
    fileprivate var successHandler: CarouselSuccess?
    
    func onSuccess(success: @escaping CarouselSuccess) -> Self {
        self.successHandler = success
        
        return self
    }
    
    func fetchOnboard() {
        self.networkFetch(request: RequestFactory.onboard())
    }
    
    func fetchCouponsCarousel() {
        self.networkFetch(request: RequestFactory.couponsCarousel())
    }
    func fetchRechargeCarousel() {
        self.networkFetch(request: RequestFactory.rechargeCarousel())
    }
    func fetchInsuranceCarousel() {
        self.networkFetch(request: RequestFactory.insuranceHeroCarousel())
    }
    func fetchHelpCenterCarousel() {
        self.networkFetch(request: RequestFactory.helpCenterCarousel())
    }
    func fetchRewardsCarousel() {
        self.networkFetch(request: RequestFactory.rewardsCarousel())
    }
    func fetchInstoreOffersCarousel() {
        self.networkFetch(request: RequestFactory.instoreOfferCarousel())
    }
    func fetchOnlineOffersCarousel() {
        self.networkFetch(request: RequestFactory.onlineOfferCarousel())
    }
    func fetchOffersCarousel() {
        self.networkFetch(request: RequestFactory.offerCarousel())
    }
    func fetchCarouselForShopOnline() {
        self.networkFetch(request: RequestFactory.heroBannerForShopOnline(component: "imagecarousel"))
    }
    func fetchCarouselForOnlinePartners(type: OnlinePartnerType) {
        switch type {
        case .otherOnlinePartner:
            self.networkFetch(request: RequestFactory.carouselForEOOP())
        case .burnOnlinePartner:
            self.networkFetch(request: RequestFactory.carouselForBOP())
        case .earnPartner:
            self.networkFetch(request: RequestFactory.carouselForEarnPartner())
        case .bankingService:
             self.networkFetch(request: RequestFactory.carouselForBankingService())
        case .carporateRewards:
            self.networkFetch(request: RequestFactory.carouselForCorporateRewards())
        case .signupPartner:
            break
        }
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
            var cellModelArray = [HeroBannerCellModel]()
            let expired = items.expired ?? false
            if expired == false, let carousels = items.carousels {
                for carousel in carousels {
                    cellModelArray.append(HeroBannerCellModel(withImageGridData: carousel))
                }
            }
            successHandler!(cellModelArray, expired)
        } catch let jsonError {
            
            print("CarouselFetcher: Json Parsing Error: \(jsonError)")
            errorHandler(jsonError.localizedDescription)
        }
    }
}
