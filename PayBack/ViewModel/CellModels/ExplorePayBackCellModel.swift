//
//  ExplorePayBackCellModel.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 29/05/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct ExplorePayBackCellModel {
    let id: Int
    var title: String?
    var descreption: String?
    var videoId: String?
    var buttonTitle: String?
    var buttonDescription: String?
    
    init(id: Int, title: String?, description: String?, videoId: String?, buttonTitle: String?, buttonDescription: String?) {
        self.id = id
        self.title = title
        self.descreption = description
        self.videoId = videoId
        self.buttonTitle = buttonTitle
        self.buttonDescription = buttonDescription
    }
}
