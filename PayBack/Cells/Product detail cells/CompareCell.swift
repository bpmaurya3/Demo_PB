//
//  compareCell.swift
//  PaybackPopup
//
//  Created by Mohsin Surani on 23/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class CompareCell: UITableViewCell {

    typealias ShopNowHandler = ((String, String) -> Void)
    var shopNowHandler: ShopNowHandler = { _, _ in }
  
    @discardableResult
    func updateShopNow(closure: @escaping ShopNowHandler) -> Self {
        self.shopNowHandler = closure
        return self
    }
    
    @IBOutlet weak private var imgCompany: UIImageView!
    @IBOutlet weak private var imgBorderView: UIView!

    @IBOutlet weak private var canceledPriceLabel: UILabel!
    @IBOutlet weak private var discountLabel: UILabel!
    @IBOutlet weak private var actualPriceLabel: UILabel!
    @IBOutlet weak private var shopButton: UIButton!
    @IBOutlet weak private var pointsView: SwitchView!
    
    @IBOutlet weak private var shopNowWidthConstraint: NSLayoutConstraint!
    
    var cellViewModel: CompareCellModel? {
        didSet {
            self.configureCell()
        }
    }
    @IBAction func shopNowAction(_ sender: UIButton) {
        self.shopNowHandler(cellViewModel?.shopNowLink ?? "", cellViewModel?.partnerLogo ?? "")
    }
    
    func setTagforShopNowButton(tagIndex: Int) {
        self.shopButton.tag = tagIndex
    }
    
    private func configureCell() {
        if let cancelPrice = cellViewModel?.canceledPrice {
            let prize: Int = (cancelPrice as NSString).integerValue
            let prizeWithLine = Utilities.getTextWithStickLine(string: "\(StringConstant.rsSymbol) \(prize)")
            canceledPriceLabel.attributedText = prizeWithLine
        }
        if let discountPrice = cellViewModel?.discountedRate {
            discountLabel.text = "(\(discountPrice) % off)"
        }
        if let actualPrice = cellViewModel?.actualPrice {
            let prize = (actualPrice as NSString).integerValue
            actualPriceLabel.text = "\(StringConstant.rsSymbol) \(prize)"
        }
        if let points = cellViewModel?.points {
            pointsView.titleLable.text = "\(points)"
        }
        if let imageurl = cellViewModel?.partnerLogo {
            imgCompany.downloadImageFromUrl(urlString: imageurl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async { [weak self] in
            self?.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        self.imgCompany.contentMode = .scaleAspectFit
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgBorderView.layer.addBorderRect(color: .lightGray, thickness: 1)
        if DeviceType.IS_IPAD {
            pointsView.titleLable.font = FontBook.Roboto.of(size: 17)
        } else {
            if DeviceType.IS_IPHONE_5 {
                canceledPriceLabel.font = FontBook.Roboto.of(size: 10)
                discountLabel.font = FontBook.Roboto.of(size: 11)
                actualPriceLabel.font = FontBook.Roboto.of(size: 12)
                shopButton.titleLabel?.font = discountLabel.font
                pointsView.titleLable.font = FontBook.Roboto.of(size: 8)
                shopNowWidthConstraint.constant = 60
            }
        }
    }
    deinit {
        print(" CompareCell deinit called")
    }
    
}
