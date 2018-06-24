//
//  OnlinePartnerVM.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/6/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class OnlinePartnerVM: NSObject {
    var otherPartner: OtherPartner?
    @objc dynamic fileprivate(set) var carouselViewModel: [HeroBannerCellModel]?
    @objc dynamic fileprivate(set) var tilesViewModel: [OnlinePartnerCellModel] = [OnlinePartnerCellModel]()

    private var carouselObserver: NSKeyValueObservation?
    private var tilesObserver: NSKeyValueObservation?

    internal var bindToCarouselViewModels: (() -> Void) = { }
    internal var bindToTilesViewModels: (() -> Void) = { }

    fileprivate let otherOnlinePartnerFetcher = OnlinePartnerFetcher()
    
    fileprivate lazy var carouselFetcher: CarouselFetcher = {
        return CarouselFetcher()
    }()
    
    override init() {
        super.init()
        carouselObserver = self.observe(\.carouselViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToCarouselViewModels()
        })
        tilesObserver = self.observe(\.tilesViewModel, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToTilesViewModels()
        })
    }
    
    func fetchMockData() {
        mockData()
    }
   
    func fetchOtherOnlineParnerData(partnerFor type: OnlinePartnerType) {
        otherOnlinePartnerFetcher
            .onSuccess(success: { [weak self] (otherPartnerData) in
                self?.otherPartner = otherPartnerData
                var cellModelArray = [OnlinePartnerCellModel]()
                guard let tiles = otherPartnerData.partnerDetails else {
                    return
                }
                for otherPartner in tiles {
                    cellModelArray.append(OnlinePartnerCellModel(withOtherPartner: otherPartner))
                } 
                self?.tilesViewModel = cellModelArray
            })
            .onError(error: { (error) in
                print("\(error)")
            })
            .fetch(onlinePartnerFor: type)
    }
    
    func fetchCarousel(carouselFor type: OnlinePartnerType) {
        carouselFetcher
            .onSuccess { [weak self] (carousel, expired) in
                self?.carouselViewModel = expired ? nil : carousel
            }
            .onError(error: { (error) in
                print("\(error)")
            })
            .fetchCarouselForOnlinePartners(type: type)
    }
    
    func invalidateObservers() {
        self.tilesObserver?.invalidate()
        self.carouselObserver?.invalidate()
    }
    
    func getParterDetails(at index: Int) -> OtherPartner.PartnerDetails? {
        guard let otherPartner = otherPartner, let partnerDetails = otherPartner.partnerDetails, partnerDetails.count > index else {
            return nil
        }
        return partnerDetails[index]
    }
    
    func getCarouselSlide(at index: Int) -> HeroBannerCellModel? {
        guard let model = self.carouselViewModel, model.count > index else {
            return nil
        }
        return model[index]
    }
    
}

extension OnlinePartnerVM {
    
    func mockData() {
        let data1 = OnlinePartnerCellModel(image: "https://www.codeproject.com/KB/GDI-plus/ImageProcessing2/flip.jpg", earnPoints: "Earn up to 200 P per review")
        let data2 = OnlinePartnerCellModel(image: "https://www.codeproject.com/KB/GDI-plus/ImageProcessing2/flip.jpg", earnPoints: "Earn up to 200 P per review")
        let data3 = OnlinePartnerCellModel(image: "https://www.codeproject.com/KB/GDI-plus/ImageProcessing2/flip.jpg", earnPoints: "Earn 8 P per rs 100")
        let data4 = OnlinePartnerCellModel(image: "https://www.codeproject.com/KB/GDI-plus/ImageProcessing2/flip.jpg", earnPoints: "Earn up to 200 P per review")
        let data5 = OnlinePartnerCellModel(image: "https://www.codeproject.com/KB/GDI-plus/ImageProcessing2/flip.jpg", earnPoints: "Earn up to 200 P per review")
        let data6 = OnlinePartnerCellModel(image: "https://www.codeproject.com/KB/GDI-plus/ImageProcessing2/flip.jpg", earnPoints: "Earn up to 200 P per review")
        let data7 = OnlinePartnerCellModel(image: "https://www.codeproject.com/KB/GDI-plus/ImageProcessing2/flip.jpg", earnPoints: "Earn up to 200 P per review")
        let data8 = OnlinePartnerCellModel(image: "https://www.codeproject.com/KB/GDI-plus/ImageProcessing2/flip.jpg", earnPoints: "Earn up to 200 P per review")
        let data9 = OnlinePartnerCellModel(image: "https://www.codeproject.com/KB/GDI-plus/ImageProcessing2/flip.jpg", earnPoints: "Earn up to 200 P per review")
        let data10 = OnlinePartnerCellModel(image: "https://www.codeproject.com/KB/GDI-plus/ImageProcessing2/flip.jpg", earnPoints: "Earn up to 200 P per review")
        
        tilesViewModel = [data1, data2, data3, data4, data5, data6, data7, data8, data9, data10]
    }
    
}
