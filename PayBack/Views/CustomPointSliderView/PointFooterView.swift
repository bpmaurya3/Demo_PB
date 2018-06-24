//
//  PointFooterView.swift
//  PayBack
//
//  Created by Mohsin Surani on 05/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PointFooterView: UIView {

    @IBOutlet weak private var earnButton: UIButton!
    @IBOutlet weak private var pointPerMonthLabel: UILabel!
    @IBOutlet weak private var equalLabel: DesignableLabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var InstructionLabel: UILabel!
    
    func setCalculatedValue(totalPoints: Int, redeemValue: Float, maxPoints: Int) {
        pointPerMonthLabel.attributedText = .getAttributedTextforPoint(changingValues: "\(totalPoints)")
        let price = Int((totalPoints * Int(redeemValue * 100)) / 100)
        self.priceLabel.text = "\(StringConstant.rsSymbol) \(price)"
        InstructionLabel.text = "You can earn upto \(maxPoints) points on every \(StringConstant.rsSymbol) 100 spent"
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        setFontsColors()
    }
    
    private func setFontsColors() {
        self.earnButton.titleLabel?.font = FontBook.Regular.of(size: 18)
        self.equalLabel.font = FontBook.Black.of(size: 23)
        self.priceLabel.font = FontBook.Regular.of(size: 24)
        self.InstructionLabel.font = FontBook.Regular.of(size: 12)
    }
    
    deinit {
        print(" PointFooterView deinit called")
    }
}
