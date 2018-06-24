//
//  InsuranceCategoryCell.swift
//  PayBack
//
//  Created by Valtech Macmini on 26/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class InsuranceCategoryCell: UITableViewCell {

    @IBOutlet weak private var schemeTitle: UILabel!
    @IBOutlet weak private var schemeDetail: UILabel!
    @IBOutlet weak private var knowMoreButton: UIButton!
    @IBOutlet weak private var buyNowButton: UIButton!
    @IBOutlet weak private var getOfferButton: DesignableButton!
    @IBOutlet weak private var offerImageView: UIImageView!
    @IBOutlet weak private var imageBorderView: UIView!
    
    @IBOutlet weak private var tagImageView: UIImageView!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    var rechargeOrInsuranceType: OfferOrInsuranceType = .insuranceCategory
    
    var goOfferTapClouser: ((CouponsRechargeCellModel) -> Void )?
    var buyOrKnowTapClouser: ((String, String) -> Void )?

    var cellViewModel: CouponsRechargeCellModel? {
        didSet {
            self.configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageBorderView.layer.masksToBounds = true
        imageBorderView.layer.borderWidth = 0.5
        imageBorderView.layer.borderColor = UIColor(red: 1 / 255, green: 2 / 255, blue: 2 / 255, alpha: 16).cgColor
    }

    func configureCell() {
        
        setUpUI()
        
        if let title = cellViewModel?.title {
            schemeTitle.text = title
        }
        if let detail = cellViewModel?.subTitle {
            schemeDetail.text = detail
        }
        if let image = cellViewModel?.thumbnailImage {
            offerImageView.image = image
        }
        
        if let imagePath = cellViewModel?.thumbnailPath {
            self.offerImageView.downloadImageFromUrl(urlString: imagePath)
        }
        
        if rechargeOrInsuranceType == .rechargeOffers {
            if let buttonText1 = cellViewModel?.buttonText1 {
                self.getOfferButton.setTitle(buttonText1.uppercased(), for: .normal)
            }
            self.getOfferButton.isHidden = (cellViewModel?.promoCode == nil)

            return
        }
        if let buttonText1 = cellViewModel?.buttonText1, rechargeOrInsuranceType == .insuranceCategory {
            self.knowMoreButton.setTitle(buttonText1.uppercased(), for: .normal)
        }
        self.knowMoreButton.isHidden = (cellViewModel?.buttonText1 == nil || cellViewModel?.buttonText1 == "")
        
        if let buttonText2 = cellViewModel?.buttonText2, rechargeOrInsuranceType == .insuranceCategory {
            self.buyNowButton.setTitle(buttonText2.uppercased(), for: .normal)
        }
        self.buyNowButton.isHidden = (cellViewModel?.buttonText2 == nil || cellViewModel?.buttonText2 == "")
    }
    
    private func setUpUI() {
        schemeTitle.font = FontBook.Bold.ofTVCellTitleSize()
        schemeTitle.textColor = ColorConstant.textColorBlack
        schemeDetail.font = FontBook.Regular.ofTVCellSubTitleSize()
        schemeDetail.textColor = ColorConstant.textColorGray
        
        knowMoreButton.titleLabel?.font = FontBook.Regular.ofButtonTitleSize()
        knowMoreButton.titleLabel?.textColor = ColorConstant.textColorWhite
        knowMoreButton.backgroundColor = ColorConstant.buttonBackgroundColorPink
        
        buyNowButton.titleLabel?.font = FontBook.Regular.ofButtonTitleSize()
        buyNowButton.titleLabel?.textColor = ColorConstant.textColorWhite
        buyNowButton.backgroundColor = ColorConstant.buttonBackgroundColorPink
        
        getOfferButton.titleLabel?.font = FontBook.Regular.ofButtonTitleSize()
        getOfferButton.titleLabel?.textColor = ColorConstant.textColorWhite
        getOfferButton.backgroundColor = ColorConstant.buttonBackgroundColorPink
        
        if rechargeOrInsuranceType == .insuranceCategory {
            self.getOfferButton.isHidden = true
            self.buyNowButton.isHidden = false
        } else {
            self.getOfferButton.isHidden = (cellViewModel?.promoCode == nil)
            self.buyNowButton.isHidden = true
        }
        
        self.knowMoreButton.isHidden = self.buyNowButton.isHidden
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buyAction(_ sender: Any) {
        if let closure = buyOrKnowTapClouser, let model = cellViewModel, let url = model.redirectionUrl, url != "" {
            closure(url, model.redirectionLogoPath ?? "")
        }
    }
    
    @IBAction func knowMoreAction(_ sender: Any) {
        if let closure = buyOrKnowTapClouser, let model = cellViewModel {
            closure(model.redirectionUrl ?? "", model.redirectionLogoPath ?? "")
        }
    }
    @IBAction func getOfferAction(_ sender: Any) {
        if let cellModel = cellViewModel, cellModel.promoCode != nil, cellModel.promoCode != "" {
            self.goOfferTapClouser?(cellModel)
        }
    }
    
    deinit {
        print(" InsuranceCategoryCell deinit called")
    }
}
extension InsuranceCategoryCell {
    @discardableResult
    func update(containerBottomContraint constant: CGFloat) -> Self {
        self.containerViewBottomConstraint.constant = constant
        
        return self
    }
}
