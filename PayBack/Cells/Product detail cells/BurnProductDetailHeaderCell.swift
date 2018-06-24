//
//  BurnProductDetailHeaderCell.swift
//  PayBack
//
//  Created by Valtech Macmini on 12/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//
import QuartzCore
import UIKit

class BurnProductDetailHeaderCell: UITableViewCell {
    
    @IBOutlet weak private var sectionView: UIView!
    @IBOutlet weak fileprivate var carousal: PBCarousel!
    @IBOutlet weak private var carousalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var productTitleLabel: UILabel!
    @IBOutlet weak private var pointLabel: UILabel!
    @IBOutlet weak private var quantityInfoLabel: UILabel!
    @IBOutlet weak private var stockLabel: UILabel!
    @IBOutlet weak fileprivate var deliveryView: DesignableTFView!
    
    @IBOutlet weak private var deliveryLabel: UILabel!
    @IBOutlet weak private var standardRadioButton: DesignableButton!
    
    @IBOutlet weak private var expressButton: DesignableButton!
    @IBOutlet weak private var standardLabel: UILabel!
    @IBOutlet weak private var expressLabel: UILabel!
    @IBOutlet weak private var deliveryInfoLabel: UILabel!
    
    @IBOutlet weak private var specifyButton: DesignableButton!
    @IBOutlet weak private var reviewButton: DesignableButton!
    @IBOutlet weak private var refundButton: DesignableButton!
    @IBOutlet weak private var favButton: UIButton!
    @IBOutlet weak private var shareButton: UIButton!
    @IBOutlet weak private var dropdownImageView: UIView!
    
    @IBOutlet weak private var decreaseQtyButton: UIButton!
    @IBOutlet weak private var quantityLabel: UILabel!
    @IBOutlet weak private var increaseQtyButton: UIButton!
    @IBOutlet weak private var dropdownView: UIView!
    @IBOutlet weak private var dynamicDataView: UIView!
    @IBOutlet weak private var dropdownLeadingConstraint: NSLayoutConstraint!
    
    typealias OrderQuantityHandler = ((Int) -> Void)
    var reviewActionHandler: (() -> Void )?
    var specifyActionHandler: (() -> Void )?
    var refundActionHandler: (() -> Void )?
    var shareActionHandler: ((String) -> Void)?
    var wishActionHandler: (() -> Void)?
    var quantityProductActionHandler: (() -> Void )?
    var standardActionHandler: (() -> Void )?
    var expressActionHandler: (() -> Void )?
    var editingActionHandler: ((CGFloat, Bool) -> Void)?
    var updateOrderQuantity: OrderQuantityHandler = { _ in }
    var carouselActionHandler: ((Int, [HeroBannerCellModel]) -> Void )?
    
    var stockCount: Int = 0
    var productID: String = ""
    var shareUrl: String = ""
    private var standardArrowPos: CGFloat = 0
    private var expressArrowPos: CGFloat = 0
    
    fileprivate var pinCodeCheckFetcher: PinCodeCheckFetcher!
    
    var carouselSlides: [HeroBannerCellModel] = [] {
        didSet {
            self.setupCarousel()
        }
    }
    var productDetailsData: BurnProductDetails.Result? {
        didSet {
            self.updateUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        configurationFromAwakeFromNib()
        pinCodeCheckFetcher = PinCodeCheckFetcher()
        //favButton.isEnabled(state: false)
//        shareButton.isUserInteractionEnabled = false
    }
    deinit {
        print(" BurnProductDetailHeaderCell deinit called")
    }
}
extension BurnProductDetailHeaderCell {
    @IBAction func quantityProductAction(_ sender: UIButton) {
        sender.setTitle("50", for: .normal)
    }
    
    @IBAction func standardClicked(_ sender: Any) {
        self.standardRadioButton.isSelected = true
        self.expressButton.isSelected = false
        self.animatePopOver(leadingConstraint: standardArrowPos)
        if let handler = self.standardActionHandler {
            handler()
        }
    }
    
    @IBAction func expressClicked(_ sender: Any) {
        self.standardRadioButton.isSelected = false
        self.expressButton.isSelected = true
        self.animatePopOver(leadingConstraint: expressArrowPos)
        if let handler = self.expressActionHandler {
            handler()
        }
    }
    @IBAction func specificationClicked(_ sender: UIButton) {
        if let handler = self.specifyActionHandler {
            handler()
        }
        UIChangesOfAction(sender: sender)
    }
    
    @IBAction func reviewClicked(_ sender: UIButton) {
        if let handler = self.reviewActionHandler {
            handler()
        }
        UIChangesOfAction(sender: sender)
    }
    
    @IBAction func refundClicked(_ sender: UIButton) {
        self.refundActionHandler?()
        UIChangesOfAction(sender: sender)
    }
    @IBAction func shareAction(_ sender: Any) {
        if let handler = self.shareActionHandler {
            handler(self.shareUrl)
        }
        print("Share Action Clicked")
    }
    
    @IBAction func alterAmountQuantityAction(_ sender: UIButton) {
        var quantity: Int = Int(quantityLabel.text ?? "") ?? 0
        switch sender {
        case decreaseQtyButton:
            if quantity > 1 {
                quantity -= 1
            }
        default:
            let stock = stockCount
            if quantity < stock {
                quantity += 1
            }
        }
        quantityLabel.text = "\(quantity)"
        self.updateOrderQuantity(quantity)
    }
    @IBAction func favAction(_ sender: Any) {
        print("Wish List Clicked")
        if let handler = self.wishActionHandler {
            handler()
        }
    }
}
extension BurnProductDetailHeaderCell {
    fileprivate func updateUI() {
        guard let productDetailsData = productDetailsData  else {
            return
        }
        if let productDataName = productDetailsData.name {
            productTitleLabel.text = productDataName
        } else {
            productTitleLabel.text = ""
        }
        if let actualPoints = productDetailsData.price?.actualPoints {
            let points = "\(Int(actualPoints)) \(StringConstant.pointsSymbol)"
            pointLabel.text = points
        } else {
            pointLabel.text = ""
        }
        if let pID = productDetailsData.productId {
            self.productID = pID
        }
        if let shareURL = productDetailsData.shareUrl {
            self.shareUrl = shareURL
        }
        if let stock = productDetailsData.stock {
            let stockInString = String(stock)
            stockCount = stock
            stockLabel.text = "\(stockInString) IN-STOCK"
        } else {
            stockLabel.text = ""
        }
        
        let carousalArray: [String] = productDetailsData.variants ?? []
        var carosalImages: [HeroBannerCellModel] = []
        for slidepath in carousalArray {
            carosalImages.append(HeroBannerCellModel(imagePath: slidepath))
        }
        self.carouselSlides = carosalImages
    }
    fileprivate func configurationFromAwakeFromNib() {
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                strongSelf.dynamicDataView.layer.addBorder(edge: .top, color: .lightGray, thickness: 0.5)

                strongSelf.standardArrowPos = strongSelf.standardRadioButton.center.x
                strongSelf.expressArrowPos = strongSelf.expressButton.center.x
                
                strongSelf.dropdownLeadingConstraint.constant = strongSelf.standardArrowPos
            }
        }
        
        self.dropdownView.layer.addTrianglePopOver(startingPoint: 0, color: UIColor(red: 239 / 255, green: 239 / 255, blue: 239 / 255, alpha: 1))
        
        self.addShadow()
        
        self.standardRadioButton.imageView?.contentMode = .scaleAspectFit
        self.standardRadioButton.clipsToBounds = true
        self.standardRadioButton.isSelected = true
        
        self.expressButton.imageView?.contentMode = .scaleAspectFit
        self.expressButton.clipsToBounds = true
        
        let font = FontBook.Regular.ofSubTitleSize()
        let minFontSize: CGFloat = 9.0
        
        self.deliveryView
            .set(TFkeyboardType: .numberPad)
            .setToolbar(prevResponder: nil, nextResponder: nil)
            .set(TFFont: font, minFontSize: minFontSize)
            .addTextRule { (text) -> TextRuleResult in
                return TextRuleResult(withConditionResult: text.isNotEmpty() && text.isNumberFormat() && text.length == 6,
                                      failedMessage: NSLocalizedString("Pincode you've entered is invalid", comment: "A failure message telling the user that pincode is invalid"))
            }
            .textField.delegate = self
    }
}
extension BurnProductDetailHeaderCell {
    fileprivate func configureUI() {
        self.productTitleLabel.font = FontBook.Bold.of(size: 15.0)
        self.productTitleLabel.textColor = ColorConstant.textColorPointTitle
        self.pointLabel.font = FontBook.Medium.of(size: 25.0)
        self.pointLabel.textColor = ColorConstant.textColorBlue
        
        configureQuantitySelection()
        
        self.deliveryLabel.font = FontBook.Medium.of(size: 15.0)
        self.deliveryLabel.textColor = ColorConstant.textColorBlue
        
        self.standardLabel.font = FontBook.Regular.of(size: 12.0)
        self.standardLabel.textColor = ColorConstant.textColorPointTitle
        
        self.expressLabel.font = FontBook.Regular.of(size: 12.0)
        self.expressLabel.textColor = ColorConstant.textColorPointTitle
        
        self.deliveryInfoLabel.font = FontBook.Regular.of(size: 12.0)
        self.deliveryInfoLabel.textColor = ColorConstant.textColorPointTitle
        
        configurTabButtons()
        
        carousalHeightConstraint.constant = Carousel_Height
    }
    fileprivate func configurTabButtons() {
        self.reviewButton.titleLabel?.font = FontBook.Regular.of(size: 12.0)
        self.refundButton.titleLabel?.font = FontBook.Regular.of(size: 12.0)
        self.specifyButton.titleLabel?.font = FontBook.Regular.of(size: 12.0)
        
        if DeviceType.IS_IPAD {
            refundButton.layer.cornerRadius = 24
            reviewButton.layer.cornerRadius = refundButton.layer.cornerRadius
            specifyButton.layer.cornerRadius = refundButton.layer.cornerRadius
        }
    }
    
    fileprivate func configureQuantitySelection() {
        self.quantityInfoLabel.font = FontBook.Medium.of(size: 12.0)
        self.quantityInfoLabel.textColor = ColorConstant.textColorPointTitle
        
        self.quantityLabel.font = FontBook.Medium.of(size: 11.5)
        self.quantityLabel.textColor = ColorConstant.textColorPointTitle
        
        self.decreaseQtyButton.titleLabel?.font = FontBook.Medium.of(size: 11.5)
        self.decreaseQtyButton.titleLabel?.textColor = ColorConstant.textColorPointTitle
        self.increaseQtyButton.titleLabel?.font = FontBook.Medium.of(size: 11.5)
        self.increaseQtyButton.titleLabel?.textColor = ColorConstant.textColorPointTitle
    }
    fileprivate func addShadow() {
        deliveryInfoLabel.layer.shadowColor = deliveryInfoLabel.textColor.cgColor
        deliveryInfoLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        deliveryInfoLabel.layer.shadowRadius = 2
        deliveryInfoLabel.layer.shadowOpacity = 0.4
        deliveryInfoLabel.layer.masksToBounds = false
        deliveryInfoLabel.layer.shouldRasterize = true
    }
    fileprivate func animatePopOver( leadingConstraint: CGFloat) {
        self.dropdownLeadingConstraint.constant = leadingConstraint
        self.needsUpdateConstraints()
        
        UIView.animate(withDuration: 0.0) {
            self.layoutIfNeeded()
        }
    }
    fileprivate func UIChangesOfAction(sender: UIButton) {
        sender.backgroudColorWithTitleColor(color: ColorConstant.primaryColorBlue, titleColor: UIColor.white)
        
        switch sender {
        case specifyButton:
            reviewButton.backgroudColorWithTitleColor(color: UIColor.clear, titleColor: ColorConstant.textColorPointTitle)
            refundButton.backgroudColorWithTitleColor(color: UIColor.clear, titleColor: ColorConstant.textColorPointTitle)
        case reviewButton:
            specifyButton.backgroudColorWithTitleColor(color: UIColor.clear, titleColor: ColorConstant.textColorPointTitle)
            refundButton.backgroudColorWithTitleColor(color: UIColor.clear, titleColor: ColorConstant.textColorPointTitle)
        default:
            specifyButton.backgroudColorWithTitleColor(color: UIColor.clear, titleColor: ColorConstant.textColorPointTitle)
            reviewButton.backgroudColorWithTitleColor(color: UIColor.clear, titleColor: ColorConstant.textColorPointTitle)
        }
    }
    @discardableResult
    func getOrderQuantity(closure: @escaping OrderQuantityHandler) -> Self {
        self.updateOrderQuantity = closure
        return self
    }
}

extension BurnProductDetailHeaderCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        let newLength = text.count + string.count - range.length
        
        if string.allowNumbersOnly() && newLength <= 6 {
            if newLength == 6 {
                self.checkPinCode(pincode: "\(text)\(string)")
            } else {
                self.clearWarning()
            }
            return true
        }
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var frame = textField.frame
        if let tempframe = textField.superview?.convert(textField.frame, to: nil) {
          frame = tempframe
        }
        editingActionHandler?(frame.height + 70, false)
        self.clearWarning()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editingActionHandler?(0, self.deliveryView.satisfiesAllTextRules())
        guard let text = self.deliveryView.textField.text, text.isNotEmpty() else {
            return
        }
        if let text = textField.text, text.length < 6 {
            self.deliveryView.warningLable.textColor = .red
            self.deliveryView.applyAllTextRules()
            self.expressActionHandler!()
        } else {
            self.checkPinCode(pincode: textField.text ?? "")
        }
    }
    
    fileprivate func checkPinCode(pincode: String) {
        pinCodeCheckFetcher
            .onError { [weak self] (error) in
                print("\(error)")
                self?.showWarning(warnText: error, isError: true)
            }
            .onSuccess { [weak self] (result) in
                self?.showWarning(warnText: result, isError: false)
            }
            .checkPinCode(pinCode: pincode, productId: self.productID)
    }
}

extension BurnProductDetailHeaderCell {
    fileprivate func setupCarousel() {
        
        let configuration = PBCarouselConfiguration()
            .set(collectionViewBounce: true)
            .set(pageControllNumberOfPage: carouselSlides.count)
            .set(collectionViewCellName: .productDetailsCarouselCVCell)
        
        carousal.confugure(withConfiguration: configuration)
        // Add the slides to the carousel
        self.carousal.slides = carouselSlides
        self.carousal.lastIndex = { ( _ ) in
            
        }
        self.carousal.cellActionHandler = { [weak self] Data in
            if let strongSelf = self, let handler = strongSelf.carouselActionHandler {
                handler(Data, strongSelf.carouselSlides)
            }
        }
    }
    fileprivate func clearWarning() {
        self.deliveryView.clearInlineError()
        self.expressActionHandler!()
    }
    fileprivate func showWarning(warnText: String, isError: Bool) {
        self.deliveryView.warningInfo = warnText
        self.deliveryView.warningLable.textColor = (isError == true) ? .red : ColorConstant.myTranscationPointColorGreen
        self.expressActionHandler!()
    }
}
