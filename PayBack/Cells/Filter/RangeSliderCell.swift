//
//  RangeSliderCell.swift
//  PayBack
//
//  Created by Valtech Macmini on 09/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class RangeSliderCell: UITableViewCell {

    @IBOutlet weak private var priceInfoLabel: UILabel!
    @IBOutlet weak private var fromInfoLabel: UILabel!
    @IBOutlet weak private var fromPriceLabel: UILabel!
    @IBOutlet weak private var toInfoLabel: UILabel!
    @IBOutlet weak private var toPriceLabel: UILabel!
    @IBOutlet weak private var rangeSlider: RangeSlider!
    
    var rangeSliderClosure: ((Int, Int) -> Void) = { _, _  in }
    
    var cellViewModel: RangeSliderCellModel? {
        didSet {
            self.configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceInfoLabel.textColor = ColorConstant.textColorBlack
        fromInfoLabel.textColor = ColorConstant.textColorGray
        toInfoLabel.textColor = ColorConstant.textColorGray
        fromPriceLabel.textColor = ColorConstant.textColorBlack
        toPriceLabel.textColor = ColorConstant.textColorBlack

        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueChanged(_:)), for: .valueChanged)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureCell() {
        if let title = cellViewModel?.title {
            priceInfoLabel.text = title
        }
        if let minvalue = cellViewModel?.minValue {
            rangeSlider.minimumValue = Double(minvalue)
        }
        if let maxValue = cellViewModel?.maxValue {
            rangeSlider.maximumValue = maxValue == 0 ? 1 : Double(maxValue)
        }
        if let lowerValue = cellViewModel?.lowerValue {
            rangeSlider.lowerValue = Double(lowerValue)
            fromPriceLabel.text = "\(cellViewModel?.rangeSymbol ?? "") \(lowerValue)"
        }
        if let upperValue = cellViewModel?.upperValue {
            rangeSlider.upperValue = Double(upperValue)
            toPriceLabel.text = "\(cellViewModel?.rangeSymbol ?? "") \(upperValue)"
        }
    }

    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        cellViewModel?.lowerValue = Int(rangeSlider.lowerValue)
        cellViewModel?.upperValue = Int(rangeSlider.upperValue)
        
        rangeSliderClosure(Int(rangeSlider.lowerValue), Int(rangeSlider.upperValue))

        fromPriceLabel.text = "\(cellViewModel?.rangeSymbol ?? "") \(cellViewModel?.lowerValue ?? 0)"
        toPriceLabel.text = "\(cellViewModel?.rangeSymbol ?? "") \(cellViewModel?.upperValue ?? 0)"
    }
    
    deinit {
        print("Deinit - RangeSliderCell")
    }
}

class RangeSliderCellModel: NSObject {
    var minValue: Int
    var maxValue: Int
    var lowerValue: Int
    var upperValue: Int
    var title: String
    var rangeSymbol: String

    init(minValue: Int, maxValue: Int, lowerValue: Int, upperValue: Int, title: String, rangeSymbol: String) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.lowerValue = lowerValue
        self.upperValue = upperValue
        self.title = title
        self.rangeSymbol = rangeSymbol
    }
}
