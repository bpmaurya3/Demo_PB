//
//  ProductListCell.swift
//  PayBack
//
//  Created by Dinakaran M on 06/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ProductListCell: UITableViewCell {
    
    @IBOutlet weak private var productImage: UIImageView!
    @IBOutlet weak private var featuredTag: UIImageView!
    @IBOutlet weak private var productAvailable: UILabel!
    @IBOutlet weak private var finalPrice: UILabel!
    @IBOutlet weak private var origPrice: UILabel!
    @IBOutlet weak private var productName: UILabel!
    
    @IBOutlet weak private var pointsSwitchView: SwitchView!
    var productCellModel: ProductListCellModel? {
        didSet {
            guard let cellModel = productCellModel else {
                return
            }
            self.parseData(forProductListData: cellModel)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.productName.font = FontBook.Bold.of(size: 15.0)
        self.productName.textColor = ColorConstant.productListTextColor
        productName.numberOfLines = 2
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    private func parseData(forProductListData productData: ProductListCellModel) {
        self.productImage.isHidden = true
        self.featuredTag.isHidden = true
        self.productAvailable.isHidden = true
        self.origPrice.isHidden = true
        self.productName.isHidden = true
        self.finalPrice.isHidden = true
        self.pointsSwitchView.isHidden = true
        
        if let image = productData.productImg {
            self.productImage.image = image
            self.productImage.isHidden = false
        }
        if let featuredtag = productData.productFeaturedTag {
            self.featuredTag.isHidden = !featuredtag
        }
        if let availableProduct = productData.productAvailable {
            self.productAvailable.text = availableProduct
            self.productAvailable.isHidden = false
        }
        if let points = productData.productPoints {
             self.pointsSwitchView.isHidden = false
            self.pointsSwitchView.titleLable.text = points

        }
        
        if let originalPrice = productData.productPrize {
            let attribute = NSMutableAttributedString()
            // swiftlint:disable legacy_constructor
            let discountString: NSMutableAttributedString = NSMutableAttributedString(string: "\(StringConstant.rsSymbol) \(originalPrice)")
            discountString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, discountString.length))
            attribute.append(discountString)
            // swiftlint:enable legacy_constructor
            if let offer = productData.productOffer {
                attribute.append(NSMutableAttributedString(string: "(\(offer))"))
            }
            if attribute.length > 0 {
                self.origPrice.attributedText = attribute
                self.origPrice.isHidden = false
            }
        }
        if let name = productData.productName {
            self.productName.text = name
            self.productName.isHidden = false
        }
        
        if let imagePath = productData.productImagePath {
            self.productImage.downloadImageFromUrl(urlString: imagePath)
            self.productImage.isHidden = false
        }
        
        if let finalPrice = productData.productDiscout {
            self.finalPrice.text = "\(StringConstant.rsSymbol) \(finalPrice)"
            self.finalPrice.isHidden = false
        }
    }
}
