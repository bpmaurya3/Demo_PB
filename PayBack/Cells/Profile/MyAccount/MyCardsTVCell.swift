//
//  MyCardsTVCell.swift
//  PayBack
//
//  Created by Dinakaran M on 06/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class MyCardsTVCell: UITableViewCell {
    
    typealias UpdateSelectedCardClosure = ((Int, Bool) -> Void)
    typealias UpdateSelectedViewTransaction = ((Int) -> Void)
    
    var updateSelectedState: UpdateSelectedCardClosure = { _, _  in }
    var updateSelectedViewTransaction: UpdateSelectedViewTransaction = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tagView.backgroundColor = ColorConstant.myCardTagBackgroundColor
        self.tagLabel.font = FontBook.Medium.of(size: 9.0)
        self.leftArrowView.backgroundColor = UIColor.clear
        self.leftArrowView.layer.addTriangleLeftArrow(startingPoint: 0, color: ColorConstant.CardTagBGColor)
        self.cardHolderName.font = FontBook.Bold.of(size: 17.5)
        self.cardHolderName.textColor = ColorConstant.textColorWhite
        self.cardNumber.font = FontBook.Medium.of(size: 20.0)
        self.cardNumber.textColor = ColorConstant.textColorWhite
        self.pointsLabel.textColor = ColorConstant.backgroudColorBlue
        self.pointsLabel.font = FontBook.Regular.of(size: 17.5)
        self.viewTrasactionButton.titleLabel?.font = FontBook.Regular.of(size: 11.0)
        self.viewTrasactionButton.titleLabel?.textColor = ColorConstant.textColorWhite
        self.viewTrasactionButton.backgroundColor = ColorConstant.buttonBackgroundColorPink
        
        //self.leftArrowView.transform = CGAffineTransform(rotationAngle: 90)
    }
    
    @IBOutlet weak private var leftArrowView: UIView!
    @IBOutlet weak private var tagLabel: UILabel!
    @IBOutlet weak private var tagView: UIView!
    @IBOutlet weak private var checkButton: UIButton!
    @IBOutlet weak private var cardImageView: UIImageView!
    @IBOutlet weak private var viewTrasactionButton: UIButton!
    @IBOutlet weak private var pointsLabel: UILabel!
    @IBOutlet weak private var cardNumber: UILabel!
    @IBOutlet weak private var cardHolderName: UILabel!
    
    @IBAction func viewTransactionAction(_ sender: UIButton) {
        print("View transaction - Tag \(sender.tag)")
        let index = sender.tag
        self.updateSelectedViewTransaction(index)
    }
    @IBAction func checkButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        print("Check/Uncheck Action - Tag \(sender.tag)")
        let index = sender.tag
        self.updateSelectedState(index, sender.isSelected)
    }
    @discardableResult
    func updateSelectedState(closure: @escaping UpdateSelectedCardClosure) -> Self {
        updateSelectedState = closure
        return self
    }
    @discardableResult
    func updateViewTransaction(closure: @escaping UpdateSelectedViewTransaction) -> Self {
        updateSelectedViewTransaction = closure
        return self
    }
    
    var sourceData: MyCardsTVCellModel? {
        didSet {
            guard let sourceData = sourceData else {
                return
            }
            self.parseData(dataForMycards: sourceData)
        }
    }
    
    func parseData(dataForMycards data: MyCardsTVCellModel) {
        if let name = data.holderName {
            self.cardHolderName.text = name
        }
        if let number = data.cardNumber {
            self.cardNumber.text = number
        }
        if let point = data.points {
            self.pointsLabel.text = "ºP \(point)"
        }
        if let tag = data.primaryTag {
            self.tagView.isHidden = !tag
        }
        if let indexTag = data.indexID {
            self.checkButton.tag = indexTag
            self.viewTrasactionButton.tag = indexTag
        }
        if let selectedState = data.isSelected {
            self.checkButton.isSelected = selectedState
        }
        if let imagePath = data.imagePath {
            cardImageView.downloadImageFromUrl(urlString: imagePath, imageType: .none)
        }
    }
    @discardableResult
    func displayCheckButton(display: Bool) -> Self {
        checkButton.isHidden = !display
        
        return self
    }
}
class MyCardsTVCellModel: NSObject {
    var holderName: String?
    var cardNumber: String?
    var points: String?
    var primaryTag: Bool? = false
    var indexID: Int?
    var isSelected: Bool? = false
    var imagePath: String?
    internal init(holderName: String? = nil, cardNumber: String? = nil, points: String? = nil, primaryTag: Bool? = false, indexID: Int? = 0, isSelected: Bool? = false, imagePath: String?) {
        self.holderName = holderName
        self.cardNumber = cardNumber
        self.points = points
        self.primaryTag = primaryTag
        self.indexID = indexID
        self.isSelected = isSelected
        self.imagePath = imagePath
    }
    override init() {
        super.init()
    }
}
