//
//  PBUserOffersTVCellModel.swift
//  PayBack
//
//  Created by Dinakaran M on 28/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

struct PBUserOffersTVCellModel {

    var rewardsIcon: UIImage?
    var title: String?
    var descreption: String?
    var progresStatue: UIImage?
    
    init(icon: UIImage, title: String, descreption: String, progresImg: UIImage) {
        self.rewardsIcon = icon
        self.title = title
        self.descreption = descreption
        self.progresStatue = progresImg
    }
}
