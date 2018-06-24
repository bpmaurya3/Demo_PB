//
//  StoreDetailsTVCell.swift
//  PayBack
//
//  Created by Dinakaran M on 13/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class StoreDetailsTVCell: UITableViewCell {

    @IBOutlet weak private var offetTitle: UILabel!
    @IBOutlet weak private var offerDiscreption: UILabel!
    var sourceData: StoreDetailsTVCellModel? {
        didSet {
            guard let sourceData = sourceData else {
                return
            }
            self.parsedata(forStoreDetails: sourceData)
        }
    }
    private func parsedata(forStoreDetails storeData: StoreDetailsTVCellModel) {
        if let name = storeData.offerTitle {
            self.offetTitle.text = name
        }
        if let msg = storeData.offerMsg {
            self.offerDiscreption.text = msg
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.offetTitle.textColor = ColorConstant.productListTextColor
        self.offetTitle.font = FontBook.Bold.of(size: 15.0)
        
        self.offerDiscreption.textColor = ColorConstant.productListTextColor
        self.offerDiscreption.font = FontBook.Regular.of(size: 11.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    deinit {
        print("Denit - StoreDetailsTVCell ")
    }
}

class StoreDetailsTVCellModel: NSObject {
    var offerTitle: String?
    var offerMsg: String?
    internal init(offerName: String? = nil, offerMsg: String? = nil) {
        self.offerTitle = offerName
        self.offerMsg = offerMsg
    }
    override init() {
        super.init()
    }
}
