//
//  StoreLocaterSortPopupView.swift
//  PayBack
//
//  Created by valtechadmin on 4/26/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit

class StoreLocaterSortPopupView: UIView {

    @IBOutlet weak private var hightolowlabel: UILabel!
    @IBOutlet weak private var lowtohighlabel: UILabel!
    @IBOutlet weak private var sortLabel: UILabel!
    @IBOutlet weak private var hightolow: UIButton!
    @IBOutlet weak private var lowtohigh: UIButton!
    
    fileprivate var productType: ProductType = .none
    
    var closeButtonClouser: (() -> Void ) = {  }
    var sortClouser: ((StoreLocaterSortBy) -> Void ) = { _ in }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.sortLabel.backgroundColor = ColorConstant.primaryColorPink
        self.sortLabel.textColor = ColorConstant.textColorWhite
        self.sortLabel.font = FontBook.Bold.ofPopUpHeaderTitleSize()
        self.lowtohighlabel.font = FontBook.Regular.ofPopUpSubTitleSize()
        self.hightolowlabel.font = FontBook.Regular.ofPopUpSubTitleSize()
    }
    
    @IBAction func hightoLowButtonAction(_ sender: UIButton) {
        sender.isSelected = true
        lowtohigh.isSelected = false
        sortClouser(.HighToLow)
        self.closePopup()
    }
    
    @IBAction func lowToHighButtonAction(_ sender: UIButton) {
        sender.isSelected = true
        hightolow.isSelected = false
        sortClouser(.LowTOHigh)
        self.closePopup()
    }
    private func closePopup() {
        closeButtonClouser()
    }
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.closePopup()
    }
   
    @discardableResult
    func set(sortOption optionType: StoreLocaterSortBy) -> Self {
        
        switch optionType {
        case .LowTOHigh:
            lowtohigh.isSelected = true
        case .HighToLow:
            hightolow.isSelected = true
        default:
            break
        }
        return self
    }
}
