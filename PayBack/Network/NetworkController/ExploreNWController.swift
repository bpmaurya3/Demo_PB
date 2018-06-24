//
//  ExploreNWController.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/2/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class ExploreNWController {
    fileprivate lazy var carouselFetcher: CarouselFetcher = {
        return CarouselFetcher()
    }()
    var carouselSuccessHandler: (([HeroBannerCellModel], _ isExpire: Bool) -> Void) = { _, _  in }
    var carouselErrorHandler: ((String) -> Void) = { _ in }

    let insuranceTypesFetcher = InsuranceTypesFetcher()

    var insuranceTypesSuccessHandler: (([ShopClickCellViewModel]) -> Void) = { _ in }
    var insuranceTypesErrorHandler: ((String) -> Void) = { _ in }

    let insurancePartnersFetcher = InsurancePartnersFetcher()
    var insurancePartnersSuccessHandler: (([ShopClickCellViewModel], OtherPartner) -> Void) = { _, _ in }
    var insurancePartnersErrorHandler: ((String) -> Void) = { _ in }

    var insuranceSubTypesSuccessHandler: (([SegmentCollectionViewCellModel]) -> Void) = { _ in }
    var insuranceSubTypesErrorHandler: ((String) -> Void) = { _ in }

    let insuranceDetailFetcher = CouponsRechargeFetcher()
    var insuranceDetailSuccessHandler: (([CouponsRechargeCellModel]) -> Void) = { _ in }
    var insuranceDetailErrorHandler: ((String) -> Void) = { _ in }
    
    let whyProtectFetcher = InsuranceWhyProtectFetcher()
    var whyProtectSuccessHandler: (([InsuranceProtectCellModel]) -> Void) = { _ in }
    var whyProtectErrorHandler: ((String) -> Void) = { _ in }

    func fetchInsuranceCarouselData() {
        carouselFetcher
            .onSuccess { [weak self] (carousel, expired) in
                self?.carouselSuccessHandler(carousel, expired)
            }
            .onError(error: carouselErrorHandler)
            .fetchInsuranceCarousel()
    }
    
    func fetchInsuranceTypes() {
        insuranceTypesFetcher
            .onSuccess { [weak self] (insuranceTypes) in
                var cellModelArray = [ShopClickCellViewModel]()
                for type in insuranceTypes.iconGridView! {
                    cellModelArray.append(ShopClickCellViewModel(withInsuranceTypes: type))
                }
                self?.insuranceTypesSuccessHandler(cellModelArray)
            }
            .onError(error: insuranceTypesErrorHandler)
            .fetchInsuranceTypes()
    }
    
    func fetchInsurancePartners() {
        insurancePartnersFetcher
            .onSuccess { [weak self] (insurancePartners) in
                var cellModelArray = [ShopClickCellViewModel]()
                if let partners = insurancePartners.partnerDetails {
                    for partner in partners {
                        cellModelArray.append(ShopClickCellViewModel(withParners: partner))
                    }
                }
                self?.insurancePartnersSuccessHandler(cellModelArray, insurancePartners)
            }
            .onError(error: insurancePartnersErrorHandler)
            .fetchInsurancePartners()
    }
    
    func fetchInsuranceSubTypes(tag: String) {
        insuranceTypesFetcher
            .onSuccess { [weak self] (insuranceSubTypes) in
                var cellModelArray = [SegmentCollectionViewCellModel]()
                for subType in insuranceSubTypes.tagImageGridElement! {
                    cellModelArray.append(SegmentCollectionViewCellModel(withInsuranceSubTypes: subType))
                }
                self?.insuranceSubTypesSuccessHandler(cellModelArray)
            }
            .onError(error: insuranceSubTypesErrorHandler)
            .fetchInsuranceSubTypes(tag: tag)
    }
    
    func fetchInsuranceDetail(tag: String) {
        insuranceDetailFetcher
            .onSuccess { [weak self] (insuranceDetails) in
                var cellModelArray = [CouponsRechargeCellModel]()
                
                guard let tilesGrid = insuranceDetails.tileGridElements else {
                    self?.insuranceDetailSuccessHandler(cellModelArray)
                    return
                }
                for insuranceDetail in tilesGrid {
                    cellModelArray.append(CouponsRechargeCellModel(forRecharge: insuranceDetail))
                }
                self?.insuranceDetailSuccessHandler(cellModelArray)
            }
            .onError(error: insuranceDetailErrorHandler)
            .fetchInsuranceDetails(tag: tag)
    }
    
    func fetchInsuranceWhyProtect() {
        whyProtectFetcher
            .onSuccess { [weak self] (whyProtect) in
                var cellModelArray = [InsuranceProtectCellModel]()
                
                guard let tilesGrid = whyProtect.verticalTileGridElements else {
                    self?.whyProtectSuccessHandler(cellModelArray)
                    return
                }
                for protect in tilesGrid {
                    cellModelArray.append(InsuranceProtectCellModel(withWhyProtect: protect))
                }
                self?.whyProtectSuccessHandler(cellModelArray)
            }
            .onError { [weak self] (error) in
                self?.whyProtectErrorHandler(error)
            }
            .fetchWhyProtect()
    }
    
}

extension ExploreNWController {
    @discardableResult
    func onCarouselError(error: @escaping ((String) -> Void)) -> Self {
        
        self.carouselErrorHandler = error
        
        return self
    }
    
    @discardableResult
    func onCarouselSuccess(success: @escaping (([HeroBannerCellModel], _ isExpire: Bool) -> Void)) -> Self {
        
        self.carouselSuccessHandler = success
        
        return self
    }
    
    @discardableResult
    func onInsuranceTypesSuccessHandler(success: @escaping (([ShopClickCellViewModel]) -> Void)) -> Self {
        
        self.insuranceTypesSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onInsuranceTypesError(error: @escaping ((String) -> Void)) -> Self {
        
        self.insuranceTypesErrorHandler = error
        
        return self
    }
    
    @discardableResult
    func onInsurancePartnersSuccessHandler(success: @escaping (([ShopClickCellViewModel], OtherPartner) -> Void)) -> Self {
        
        self.insurancePartnersSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onInsurancePartnersError(error: @escaping ((String) -> Void)) -> Self {
        
        self.insurancePartnersErrorHandler = error
        
        return self
    }

    @discardableResult
    func onInsuranceSubTypesSuccessHandler(success: @escaping (([SegmentCollectionViewCellModel]) -> Void)) -> Self {
        
        self.insuranceSubTypesSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onInsuranceSubTypesError(error: @escaping ((String) -> Void)) -> Self {
        
        self.insuranceSubTypesErrorHandler = error
        
        return self
    }
    
    @discardableResult
    func onInsuranceDetailSuccess(success: @escaping (([CouponsRechargeCellModel]) -> Void)) -> Self {
        
        self.insuranceDetailSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onInsuranceDetailError(error: @escaping ((String) -> Void)) -> Self {
        
        self.insuranceDetailErrorHandler = error
        
        return self
    }
    @discardableResult
    func onWhyProtectSuccess(success: @escaping (([InsuranceProtectCellModel]) -> Void)) -> Self {
        
        self.whyProtectSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onWhyProtectError(error: @escaping ((String) -> Void)) -> Self {
        
        self.whyProtectErrorHandler = error
        
        return self
    }
}

extension ExploreNWController {
    
    fileprivate func mockInsuranceTypeClick() {
        let data1 = ShopClickCellViewModel(image: UIImage(named: "shoppingcart")!, earnInfo: "Life Insurance")
        let data2 = ShopClickCellViewModel(image: UIImage(named: "shoppingcart")!, earnInfo: "Health Insurance")
        let data3 = ShopClickCellViewModel(image: UIImage(named: "shoppingcart")!, earnInfo: "General Insurance")
        let cellModel = [data1, data2, data3]
        insuranceTypesSuccessHandler(cellModel)
    }
    
    func mockInsurance() {
        let data1 = CouponsRechargeCellModel(forInsurenceDetail: #imageLiteral(resourceName: "placeholder"), title: "Smart Life Smart Life Smart Life Smart Life", subTitle: "With top insurance Smart Life Smart Life Smart Life Smart Life")
        
        let data2 = CouponsRechargeCellModel(forInsurenceDetail: #imageLiteral(resourceName: "placeholder"), title: "Smart Life Smart Life Smart Life Smart Life", subTitle: "With top insurance Smart Life Smart Life Smart Life Smart Life")
        
        let data3 = CouponsRechargeCellModel(forInsurenceDetail: #imageLiteral(resourceName: "placeholder"), title: "Smart Life Smart Life Smart Life Smart Life", subTitle: "With top insurance Smart Life Smart Life Smart Life Smart Life")
        let dataSource = [data1, data2, data3]
        
        insuranceDetailSuccessHandler(dataSource)
    }
}
