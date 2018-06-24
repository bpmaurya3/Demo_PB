//
//  PBHelpCentreTVCellModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/6/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

struct PBHelpCentreTVCellModel {
    var imagePath: String?
    var title: String?
    
    init(withHelpCenterData data: HelpCenter.AccordionDetails) {
        self.imagePath = data.imagePath
        self.title = data.title
    }
    init() {}
    
}
