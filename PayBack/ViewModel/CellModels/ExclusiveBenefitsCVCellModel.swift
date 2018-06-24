//
//  ExclusiveBenefitsCVCellModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/9/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

struct ExclusiveBenefitsCVCellModel {
    var thumbnailImage: UIImage?
    var title: String?
    var imagePath: String?
    var description: String?
    
    init(thumbnailImage image: UIImage, titleText title: String, description: String = "") {
        self.thumbnailImage = image
        self.title = title
        self.description = description
    }
    
    init(withExclusiveData exclusive: PaybackPlusExclusive.IconDescGridView) {
        self.imagePath = exclusive.imagePath
        self.title = exclusive.title
        self.description = exclusive.description
    }
}
