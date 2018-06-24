//
//  PBShopClickCVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 11/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBShopClickCVCell: UICollectionViewCell {
    
    @IBOutlet weak private var mPartnerImage: UIImageView!
    @IBOutlet weak private var mPartnerOffer: UILabel!
    var shopOrInsurance: ShopOrInsuranceType = .shop
    
    var shopClickCellViewModel: ShopClickCellViewModel? {
        didSet {
            guard let cellModel = shopClickCellViewModel else {
                return
            }
            self.parseData(forShopClickCellData: cellModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mPartnerOffer.font = FontBook.Regular.of(size: 11.0)
        self.mPartnerOffer.textColor = ColorConstant.textColorBlack
        
    }
    
    deinit {
        print("PBShopClickCVCell: deinit called")
    }
    
    private func parseData(forShopClickCellData shopClickCellViewModel: ShopClickCellViewModel) {
        
        if shopOrInsurance == .insurance {
            mPartnerOffer.isHidden = true
        }

        if let image = shopClickCellViewModel.image {
            self.mPartnerImage.image = image
        } else {
            self.mPartnerImage.image = nil
        }
        if let earnInfo = shopClickCellViewModel.title {
            self.mPartnerOffer.text = earnInfo.capitalized
        } else {
            self.mPartnerOffer.text = ""
        }
        if let imagePath = shopClickCellViewModel.imagePath {
            self.mPartnerImage.downloadImageFromUrl(urlString: imagePath)
        } else {
            self.mPartnerImage.image = #imageLiteral(resourceName: "placeholder")
        }
    }
}
