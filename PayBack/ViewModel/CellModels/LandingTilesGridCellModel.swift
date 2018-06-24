//
//  LandingTilesGridCellModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/27/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class LandingTilesGridCellModel: BaseModel {
    var slideImage: UIImage?
    var iconImage: UIImage?
    
    var imagePath: String?
    var iconImagePath: String?
    var title: String?
    var subTitle: String?
    var allowBgLayout: Bool?
    var redirectionURL: String?
    var redirectionPartnerLogo: String?
    var uniquePageID: String?
    var uniqueKey: String?
    
    init(withOnboardCarouselData data: Carousels) {
        self.imagePath = data.imagePath
        self.title = data.title
        self.subTitle = data.subTitle
    }
    
    init(withImageGridData data: Carousels) {
        self.imagePath = data.imagePath
        self.iconImagePath = data.iconImagePath
        self.title = data.title
        self.subTitle = data.subTitle
        self.allowBgLayout = data.allowBgLayout
        self.redirectionURL = data.redirectionURL
        self.redirectionPartnerLogo = data.redirectionPartnerLogo
    }
    init(withImageGridData data: NavigationSections) {
        self.imagePath = data.imagePath
        self.iconImagePath = data.iconImagePath
        self.title = data.title
        self.allowBgLayout = data.allowBgLayout
        self.uniqueKey = data.uniqueKey
    }
    
    init(image: UIImage, title: String, description: String = "", icon: UIImage = UIImage()) {
        self.slideImage = image
        self.title = title
        self.subTitle = description
        self.iconImage = icon
    }
}
