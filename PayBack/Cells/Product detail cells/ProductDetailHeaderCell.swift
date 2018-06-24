//
//  ProductDetailHeaderCell.swift
//  PayBack
//
//  Created by Valtech Macmini on 12/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ProductDetailHeaderCell: UITableViewCell {

    @IBOutlet weak private var compareButton: UIButton!
    @IBOutlet weak private var reviewButton: UIButton!
    @IBOutlet weak private var specifyButton: UIButton!
    
    @IBOutlet weak private var productTitleLabel: UILabel!
    @IBOutlet weak private var originalPriceLabel: UILabel!
    @IBOutlet weak private var actualPriceLabel: UILabel!
    @IBOutlet weak private var couponButton: UIButton!
    @IBOutlet weak private var pointsView: SwitchView!

    @IBOutlet weak private var storeLogoImg: UIImageView!
    @IBOutlet weak private var carousalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak fileprivate var carousel: PBCarousel!
    
    @IBOutlet weak private var segmentHeightConstraint: NSLayoutConstraint!
    
    var reviewActionHandler: (() -> Void )?
    var specifyActionHandler: (() -> Void )?
    var compareActionHandler: (() -> Void )?
    var couponActionHandler: (() -> Void )?
    var carouselActionHandler: ((Int, [HeroBannerCellModel]) -> Void )?
    var goOfferView: AlertCouponPopUp?
    var shopNowActionHandler: ((String, String) -> Void)?
    var shareActionHandler: ((String) -> Void)?
    var couponCode: String?
    var couponDescreption: String?
    var carouselSlides: [HeroBannerCellModel] = [] {
        didSet {
             self.setupCarousel()
        }
    }

    var productDetailsData: EarnProductDetails? {
        didSet {
            if let results = productDetailsData?.metaInfo {
                if let title = results.title {
                   self.productTitleLabel.text = title
                } else {
                    self.productTitleLabel.text = ""
                }

                if let originalPrize = results.origPrice {
                    let prize = Int(originalPrize)
                    let prizeWithStrickLine = Utilities.getTextWithStickLine(string: "\(StringConstant.rsSymbol) \(prize)")
                    self.originalPriceLabel.attributedText = prizeWithStrickLine
                } else {
                    self.originalPriceLabel.text = ""
                }
                if let finalPrize = results.finalPrice {
                    let prize = Int(finalPrize)
                    self.actualPriceLabel.text = "\(StringConstant.rsSymbol) \(prize)"
                } else {
                    self.actualPriceLabel.text = ""
                }
                if let imageVariants = results.imageVariants {
                    var slideArray: [HeroBannerCellModel] = []
                    for slidePath in imageVariants {
                        let slide = HeroBannerCellModel(imagePath: "\(slidePath)")
                        slideArray.append(slide)
                    }
                    carouselSlides = slideArray
                } else {
                    carouselSlides = [HeroBannerCellModel(image: #imageLiteral(resourceName: "placeholder"))]
                }
                if let shopnowLink = results.storeLink, let handler = shopNowActionHandler {
                    if let logourl = results.storeLogo {
                        handler(shopnowLink, logourl)
                    } else {
                        handler(shopnowLink, "")
                    }
                }
                if let storeLogo = results.storeLogo {
                    self.storeLogoImg.downloadImageFromUrl(urlString: storeLogo)
                }
                if let shareLink = results.shareUrl, let handler = self.shareActionHandler {
                    handler(shareLink)
                }
                if let point = results.pbstore_data?.totalPoints {
                    self.pointsView.titleLable.text = "\(point)"
                }
                if let store = results.store, let productDetails = productDetailsData {
                    self.updateCouponCode(productDeatils: productDetails, partnerStore: store)
                } else {
                    self.couponButton.isHidden = true
                   // self.couponButton.isEnabled(state: false)
                }
            }
        }
    }
    func updateCouponCode(productDeatils: EarnProductDetails, partnerStore: String?) {
        guard productDeatils.couponsinfo != nil, let store = partnerStore, let couponCodeArray = productDeatils.couponsinfo?.coupons else {
            return
        }
        for data in couponCodeArray where (data.key == store && !data.value.isEmpty) {
            let couponObjectArray = data.value
            couponCode = couponObjectArray[0].couponCode
            couponDescreption = couponObjectArray[0].couponDescription
        }
        if couponCode == "" || couponCode == nil || couponCode == "No Coupon Code" {
                self.couponButton.isHidden = true
                //self.couponButton.isEnabled(state: false)
        } else {
         	self.couponButton.isHidden = false
           //self.couponButton.isEnabled(state: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.productTitleLabel.text = ""
        self.originalPriceLabel.text = ""
        self.actualPriceLabel.text = ""
        self.pointsView.titleLable.text = ""
        
        self.productTitleLabel.font = FontBook.Bold.of(size: 15.0)
        self.productTitleLabel.textColor = ColorConstant.textColorPointTitle
        
        self.originalPriceLabel.font = FontBook.Arial.of(size: 10.5)
        self.originalPriceLabel.textColor = ColorConstant.originalPrizeColor
        
        self.actualPriceLabel.font = FontBook.Regular.of(size: 25.0)
        self.actualPriceLabel.textColor = ColorConstant.textColorPointTitle
        
        self.carousalHeightConstraint.constant = Carousel_Height
        couponButton.titleLabel?.font = FontBook.Medium.of(size: 12.0)
        couponButton.titleLabel?.textColor = ColorConstant.buttonBackgroundColorPink
        
        compareButton.titleLabel?.font = FontBook.Regular.of(size: 12)
        reviewButton.titleLabel?.font = FontBook.Regular.of(size: 12)
        specifyButton.titleLabel?.font = FontBook.Regular.of(size: 12)
        
        let couponTextwithUnderLine = Utilities.getTextWithUnderLine(string: "COUPON")
        couponButton.titleLabel?.attributedText = couponTextwithUnderLine
 }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if DeviceType.IS_IPAD {
            compareButton.layer.cornerRadius = 24
            pointsView.titleLable.font = UIFont(name: "Arial", size: 19)
        } else if DeviceType.IS_IPHONE_5 {
            segmentHeightConstraint.constant = 65
            compareButton.layer.cornerRadius = 18
        }
        reviewButton.layer.cornerRadius = compareButton.layer.cornerRadius
        specifyButton.layer.cornerRadius = compareButton.layer.cornerRadius
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setupCarousel()
    }
    
    @IBAction func couponAction(_ sender: Any) {
        self.showCouponView()
       // self.couponActionHandler?()
    }
    
    @IBAction func reviewAction(_ sender: Any) {
        UIChangesOfAction(sender: reviewButton)
        self.reviewActionHandler?()
    }
    @IBAction func specificationAction(_ sender: Any) {
        UIChangesOfAction(sender: specifyButton)
        self.specifyActionHandler?()
    }
    @IBAction func compareAction(_ sender: Any) {
        UIChangesOfAction(sender: compareButton)
        self.compareActionHandler?()
    }
    
    private func UIChangesOfAction(sender: UIButton) {
        
        sender.backgroudColorWithTitleColor(color: ColorConstant.primaryColorBlue, titleColor: UIColor.white)

        switch sender {
        case compareButton:
            reviewButton.backgroudColorWithTitleColor(color: UIColor.clear, titleColor: ColorConstant.textColorPointTitle)
            specifyButton.backgroudColorWithTitleColor(color: UIColor.clear, titleColor: ColorConstant.textColorPointTitle)
        case reviewButton:
            specifyButton.backgroudColorWithTitleColor(color: UIColor.clear, titleColor: ColorConstant.textColorPointTitle)
            compareButton.backgroudColorWithTitleColor(color: UIColor.clear, titleColor: ColorConstant.textColorPointTitle)
        default:
            reviewButton.backgroudColorWithTitleColor(color: UIColor.clear, titleColor: ColorConstant.textColorPointTitle)
            compareButton.backgroudColorWithTitleColor(color: UIColor.clear, titleColor: ColorConstant.textColorPointTitle)
        }
    }
    
    deinit {
        print(" ProductDetailHeaderCell deinit called")
    }
}

extension ProductDetailHeaderCell {
    fileprivate func setupCarousel() {
        let configuration = PBCarouselConfiguration()
            .set(collectionViewBounce: true)
            .set(pageControllNumberOfPage: carouselSlides.count)
            .set(collectionViewCellName: .productDetailsCarouselCVCell)
        carousel.confugure(withConfiguration: configuration)
        // Add the slides to the carousel
        self.carousel.slides = carouselSlides
        self.carousel.cellActionHandler = { [weak self] Data in
            guard let strongSelf = self, let handler = self?.carouselActionHandler else {
                return
            }
            handler(Data, strongSelf.carouselSlides)
        }
    }
}
extension ProductDetailHeaderCell {
    func showCouponView() {
        guard let goOfferView = Bundle.main.loadNibNamed("AlertCouponPopUp", owner: self, options: nil)?.first as? AlertCouponPopUp else {
            return
        }
        goOfferView.copyOfferActionHandler = {(Data) in
            print("copy handled: \(Data)")
        }
        if let code = self.couponCode {
            goOfferView.setTitleLabel(couponDecsreption: self.couponDescreption ?? "")
            goOfferView.setCouponCode(code: code)
        }
        goOfferView.frame = CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT)
        APP_DEL?.window?.addSubview(goOfferView)
        self.goOfferView = goOfferView
    }
}
