//
//  StoreListingFilterTVCell.swift
//  PayBack
//
//  Created by Dinakaran M on 13/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class StoreListingFilterTVCell: UITableViewCell {

    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var arrowImage: UIImageView!
    var subItemsList: [Any] = []
    
    var sourceData: StoreListingFilterTVCellModel? {
        didSet {
            guard let sourceData = sourceData else {
                return
            }
            self.parseData(forListingFilter: sourceData)
        }
    }
    private func parseData(forListingFilter sourceData: StoreListingFilterTVCellModel) {
        if let ItemName = sourceData.name {
            self.title.text = ItemName
        }
        if let subItems = sourceData.sourceData {
            self.subItemsList = subItems
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.title.textColor = ColorConstant.textColorBlack
        self.title.font = FontBook.Regular.ofTVCellTitleSize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    deinit {
        print("Denit - StoreListingFilterTVCell ")
    }
}
class StoreListingFilterTVCellModel: NSObject {
    var name: String?
    var sourceData: [Any]?
    internal init(name: String? = nil, subItems: [Any]? = nil) {
        self.name = name
        self.sourceData = subItems
    }
    override init() {
        super.init()
    }
}
