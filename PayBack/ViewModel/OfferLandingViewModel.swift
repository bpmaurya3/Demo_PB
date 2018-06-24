//
//  OfferLandingViewModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/29/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

class OfferLandingViewModel: NSObject {
    @objc dynamic fileprivate(set) var offerViewModels: [CouponsRechargeCellModel] = [CouponsRechargeCellModel]()
    @objc dynamic fileprivate(set) var carouselViewModel: [HeroBannerCellModel]?
    @objc dynamic fileprivate(set) var gridViewModels: [LandingTilesGridCellModel] = [LandingTilesGridCellModel]()

    private var token: NSKeyValueObservation?
    private var token1: NSKeyValueObservation?
    private var token2: NSKeyValueObservation?
    
    var bindToOfferViewModels: (() -> Void) = {  }
    var bindToCarouselViewModels: (() -> Void) = { }
    var bindToGrigViewModels: (() -> Void) = {  }

    fileprivate var networkController: OfferZoneNWController
    
    init(networkController: OfferZoneNWController) {
        self.networkController = networkController
        super.init()
        self.invalidateObservers()
        token = self.observe(\.offerViewModels, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToOfferViewModels()
        })
        
        token1 = self.observe(\.carouselViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToCarouselViewModels()
        })
        
        token2 = self.observe(\.gridViewModels, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToGrigViewModels()
        })
        
    }
    
    func invalidateObservers() {
        self.token?.invalidate()
        self.token1?.invalidate()
        self.token2?.invalidate()
    }
}

extension OfferLandingViewModel {
    func refreshData() {
        let when = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.fetchCarousel()
        }
    }
    
    func fetchAll() {
        let when = DispatchTime.now() + 0.15
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.fetchTilesGrid()
        }
        let when1 = when + 0.15
        DispatchQueue.main.asyncAfter(deadline: when1) {
            self.fetchLandingOffers()
        }
    }
    
    func carouselModel(at index: Int) -> HeroBannerCellModel? {
        guard let carousels = carouselViewModel, !carousels.isEmpty, carousels.count > index else {
            return nil
        }
        return carousels[index]
    }
    
    func gridModels() -> [LandingTilesGridCellModel]? {
        guard !gridViewModels.isEmpty else {
            return nil
        }
        return self.gridViewModels
    }
    
    func offerModel(at index: Int) -> CouponsRechargeCellModel? {
        guard !offerViewModels.isEmpty, offerViewModels.count > index else {
            return nil
        }
        return self.offerViewModels[index]
    }
}

extension OfferLandingViewModel {
    fileprivate func fetchCarousel() {
        networkController
            .oncarouselSuccess { [weak self] (carouselData, isExpired) in
                self?.carouselViewModel = isExpired ? nil : carouselData
            }
            .onCarouselError { (error) in
                print("\(error)")
                self.carouselViewModel = nil
            }
            .offerCarousel()
    }
    
    fileprivate func fetchLandingOffers() {
        networkController
            .onCouponsDetailsSuccess { [weak self] (landingOffers) in
                self?.offerViewModels = landingOffers
            }
            .onError { [weak self] (error) in
                print("\(error)")
                self?.offerViewModels = []
            }
            .fetchLandingOffers()
    }
    
    fileprivate func fetchTilesGrid() {
        networkController
            .onTilesGridSuccess { [weak self] (gridData) in
                self?.gridViewModels = gridData
            }
            .onError { [weak self] (error) in
                print("\(error)")
                self?.gridViewModels = []
            }
            .fetchOfferZoneGrid()
    }
}
