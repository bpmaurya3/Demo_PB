//
//  HomeShowCaseCVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 5/14/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit

class HomeShowCaseCVCell: UICollectionViewCell {
    
    var cellModel: HomeShowCaseCVCellModel? {
        didSet {
            self.parseData(cellModel: cellModel!)
        }
    }
    
    @IBOutlet weak var partnerImageView: UIImageView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsView: SwitchView!
    @IBOutlet weak var buyActionButton: UIButton!
    @IBOutlet weak var buyButtonheightConstraint: NSLayoutConstraint!

    var buyNowClosure: (HomeShowCaseCVCellModel) -> Void = { _ in }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.partnerImageView.isHidden = true
        self.itemImageView.isHidden = true
        self.titleLabel.isHidden = true
        self.priceLabel.isHidden = true
        self.pointsLabel.isHidden = true
        self.titleLabel.text = ""
        self.priceLabel.text = ""
        self.pointsLabel.text = ""
        self.pointsView.isHidden = true
        self.buyActionButton.isHidden = true
        self.buyButtonheightConstraint.constant = 0
        
        titleLabel.font = FontBook.Bold.of(size: 12)
        pointsView.titleLable.font = FontBook.Medium.of(size: 13)
        self.pointsLabel.textColor = ColorConstant.shopNowButtonBGColor
        self.pointsLabel.font = FontBook.Regular.of(size: 12)
        
        self.buyActionButton.layer.borderColor = ColorConstant.grayBorderDelivery.cgColor
        self.buyActionButton.layer.borderWidth = 1
        self.buyActionButton.setTitleColor(ColorConstant.shopNowButtonBGColor, for: .normal)
        self.buyActionButton.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.isHidden = true
        self.priceLabel.isHidden = true
        self.pointsLabel.isHidden = true
        self.titleLabel.text = ""
        self.priceLabel.text = ""
        self.pointsLabel.text = ""
        self.partnerImageView.image = nil
        self.itemImageView.image = nil
        self.pointsView.isHidden = true
        self.buyActionButton.setTitle(nil, for: .normal)
        self.pointsView.titleLable.text = nil
        self.buyActionButton.isHidden = true
        self.buyButtonheightConstraint.constant = 0
    }
    //swiftlint:disable function_body_length
    private func parseData(cellModel: HomeShowCaseCVCellModel) {
        if let partImage = cellModel.partnerImage {
            partnerImageView.image = partImage
            partnerImageView.isHidden = false
        }
        if let partnerImage = cellModel.partnerImagePath {
            partnerImageView.downloadImageFromUrl(urlString: partnerImage)
            partnerImageView.isHidden = false
        }
        if let title = cellModel.title {
            self.titleLabel.text = title
            self.titleLabel.isHidden = false
        }
        if let productPrice = cellModel.actualPrice {
            priceLabel.attributedText = Utilities.getTextWithStickLine(string: "\(StringConstant.rsSymbol) \(productPrice)")
            priceLabel.isHidden = false
        }
        
        if let dealPrice = cellModel.dealPrice {
            let dealPrice = Utilities.getTextWithColor(color: ColorConstant.textColorRed, text: "  \(StringConstant.rsSymbol) \(dealPrice)")
            
            let combination = NSMutableAttributedString()
            combination.append(priceLabel.attributedText ?? NSAttributedString())
            combination.append(dealPrice)
            priceLabel.attributedText = combination
            priceLabel.isHidden = false
        }
        
        if let earnPoints = cellModel.points {
            pointsView.titleLable.text = earnPoints
            pointsView.isHidden = false
            self.buyButtonheightConstraint.constant = 30
        } else {
            self.buyButtonheightConstraint.constant = 0
        }
        
        if let pointsText = cellModel.pointsText {
            self.pointsLabel.text = "\(pointsText) POINTS"
            self.pointsLabel.isHidden = false
            self.buyButtonheightConstraint.constant = 0
        }
        
        if let buyActionTitle = cellModel.buyActionTitle {
            self.buyActionButton.setTitle("  \(buyActionTitle)  ", for: .normal)
            self.buyActionButton.isHidden = false
            self.buyButtonheightConstraint.constant = 30
        } else {
            self.buyButtonheightConstraint.constant = 0
        }
        
        if let imageUrl = cellModel.itemImagePath {
            self.itemImageView.downloadImageFromUrl(urlString: imageUrl)
            self.itemImageView.isHidden = false
        }
        
        if let itemImage = cellModel.itemImage {
            itemImageView.image = itemImage
            itemImageView.isHidden = false
        }
    }
    //swiftlint:enable function_body_length
}
extension HomeShowCaseCVCell {
    @IBAction func buyNowAction(_ sender: Any) {
        // buyNowClosure(cellModel!)
        
        guard let url = cellModel?.redirectionURL, url != "" else {
            return
        }
        
        let isUserLogedInStatus = UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged)
        
        let burn_VoucherWorld = PoliciesVC.storyboardInstance(storyBoardName: "Profile") as? PoliciesVC
        burn_VoucherWorld?.type = .voucherWorld
        burn_VoucherWorld?.urlToBeOpen = url
        
        if isUserLogedInStatus {
            self.puchToVoucherWorld(viewController: burn_VoucherWorld)
        } else {
            self.signInAction(viewController: burn_VoucherWorld)
        }
    }
    private func signInAction(viewController: UIViewController? = nil) {
        var parentController: BaseViewController?
        if let controller = self.parentViewController as? ExtendedHomeVC {
            parentController = controller
        }
        if let controller = self.parentViewController as? InstantVoucherVC {
            parentController = controller
        }
        var tempViewController: UIViewController?
        
        parentController?
            .onLoginSuccess {[weak self] in
                if let vc = viewController {
                    tempViewController = vc
                }
                if let viewController = tempViewController {
                    self?.puchToVoucherWorld(viewController: viewController)
                    tempViewController = nil
                }
            }
            .onLoginError(error: {(error) in
                parentController?.showErrorView(errorMsg: error)
            })
            .signInPopUp()
    }
    private func puchToVoucherWorld(viewController: UIViewController? = nil) {
        guard let parentController = self.parentViewController else {
            return
        }
        parentController.navigationController?.pushViewController(viewController!, animated: true)
    }
}
class HomeShowCaseCVCellModel: NSObject {
    var partnerImage: UIImage?
    var itemImage: UIImage?
    
    var itemId: String?
    var partnerImagePath: String?
    var itemImagePath: String?
    var title: String?
    var actualPrice: String?
    var dealPrice: String?
    var pointsText: String?
    var points: String?
    var buyActionTitle: String?
    var redirectionURL: String?
    var itemType: String?
    var appDeepLink: String?
    
    init(partnerImage: UIImage, itemImage: UIImage, title: String, actualPrice: String, finalPrice: String, points: String) {
        self.partnerImage = partnerImage
        self.itemImage = itemImage
        self.title = title
        self.actualPrice = actualPrice
        self.dealPrice = finalPrice
        self.points = points
    }
    init(itemImage: UIImage, title: String, buyButtonTitle: String) {
        self.itemImage = itemImage
        self.title = title
        self.buyActionTitle = buyButtonTitle
       
    }
    
    init(itemImage: UIImage, title: String, pointText: String) {
        self.itemImage = itemImage
        self.title = title
        self.pointsText = pointText
        
    }
    init(withInstantVoucher grid: ShowcaseGrid) {
        self.itemImagePath = grid.logoPath
        self.title = grid.title
        self.buyActionTitle = grid.ctaLabel
        self.redirectionURL = grid.redirectionURL
    }
    
    init(withRedeemProductItem item: RedeemProduct.Result) {
        if let name = item.name {
            self.title = name
        }
        
        if let actualPoints = item.price?.actualPoints {
            self.pointsText = String(actualPoints)
        }
        
        if let small = item.images?.medium {
            self.itemImagePath = RequestFactory.getFinalRewardsImageURL(urlString: small[0])
        }
        if let productID = item.productId {
            self.itemId = productID
        }
    }
    
    init(withTopTrend item: TopTrend.Trending) {
        if let name = item.title {
            self.title = name
        }
        if let actualPoints = item.pbStoreData?.totalPoints {
            self.points = String(actualPoints)
        }
        if let price = item.origPrice {
            self.actualPrice = String(price)
        }
        if let finalPrice = item.finalPrice {
            self.dealPrice = finalPrice
        }
        if let storeLogo = item.storeLogo {
            self.partnerImagePath = storeLogo
        }
        if let small = item.img {
            self.itemImagePath = small
        }
        if let productID = item.id {
            self.itemId = productID
        }
        self.itemType = item.itemType
        self.appDeepLink = item.url
    }
    init(withOnlinePartner partnerDetails: OtherPartner.PartnerDetails) {
        self.itemImagePath = partnerDetails.logoImage
        self.title = partnerDetails.description
        self.redirectionURL = partnerDetails.linkUrl
    }
}
