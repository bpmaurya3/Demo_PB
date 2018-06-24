//
//  InsuranceProtectCell.swift
//  PayBack
//
//  Created by Valtech Macmini on 13/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class InsuranceProtectCell: UITableViewCell {

    @IBOutlet weak private var protectImageView: UIImageView!
    @IBOutlet weak private var protectTitle: UILabel!
    @IBOutlet weak private var protectDetail: UILabel!
    
    var cellViewModel: InsuranceProtectCellModel? {
        didSet {
            self.configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        protectImageView.backgroundColor = .clear
        self.protectTitle.textColor = ColorConstant.productTitleTextColor
        self.protectTitle.font = FontBook.Bold.of(size: 13.0)
        self.protectDetail.textColor = ColorConstant.productDescriptionTextColor
        self.protectDetail.font = FontBook.Regular.of(size: 12.0)
    }
    
    private func configureCell() {
        
        if let title = cellViewModel?.insuranceTitle {
            protectTitle.text = title
        }
        if let detail = cellViewModel?.insuranceDetail {
            protectDetail.text = detail
        }
        if let iconPath = cellViewModel?.iconImagePath {
            protectImageView.downloadImageFromUrl(urlString: iconPath, imageType: .none)
        }
    }
    
    deinit {
        print(" InsuranceProtectCell deinit called")
    }
}

class InsuranceProtectCellModel: NSObject {
    var insuranceTitle: String?
    var insuranceDetail: String?
    var iconImagePath: String?
    var redirectionURL: String?
    
    init?(insuranceTitle: String, insuranceDetail: String?) {
        super.init()
        
        self.insuranceTitle = insuranceTitle
        self.insuranceDetail = insuranceDetail
    }
    
    init(withWhyProtect protect: CouponsRecharge.ResponseData) {
        self.insuranceTitle = protect.gridImageTitle
        self.insuranceDetail = protect.gridImageSubtitle
        self.iconImagePath = protect.gridImagePath
        self.redirectionURL = protect.redirectionURL
    }
}
