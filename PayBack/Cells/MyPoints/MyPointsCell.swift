//
//  MyPointsCell.swift
//  PayBack
//
//  Created by Mohsin Surani on 05/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
import TGPControls

class MyPointsCell: UITableViewCell {

    @IBOutlet weak private var categoryImageView: UIImageView!
    @IBOutlet weak private var categoryLabel: UILabel!
    @IBOutlet weak private var startView: UIView!
    @IBOutlet weak private var endView: UIView!

    @IBOutlet weak private var spendingLabel: DesignableLabel!
    @IBOutlet weak private var oneTo10Labels: TGPCamelLabels!
    @IBOutlet weak private var expenseSlider: TGPDiscreteSlider!

    var pointActionHandler: (() -> Void )?

    var cellViewModel: PointCalculatorCellModel? {
        didSet {
            self.configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setFontColors()
        colorRadiusAlter(color: ColorConstant.startPointRadioColor, view: startView)
        colorRadiusAlter(color: ColorConstant.endPointRadioColor, view: endView)
        
        expenseSlider.ticksListener = oneTo10Labels
        expenseSlider.addTarget(self, action: #selector(self.paybackSliderValueDidChange(_:event:)), for: .valueChanged)
    }
    
    private func setFontColors() {
        self.categoryLabel.textColor = ColorConstant.textColorPointTitle
        self.categoryLabel.font = FontBook.Regular.of(size: 12)     
    }
    
    @objc func paybackSliderValueDidChange(_ sender: TGPDiscreteSlider, event: UIEvent) {
        print(sender.value)
    
//        let diff: CGFloat = CGFloat((CGFloat((cellViewModel?.maxValue)!)) / 10000)

        //%.02f
        let value = String(format: "%.00f", (sender.value) * 1000)
        setEndRadioColor()
        self.spendingLabel.attributedText = .getAttributedTextForRoom(changingValues: "\(value)")
        cellViewModel?.price = Int(value) ?? 0
        self.pointActionHandler?()
    }
    
    private func colorRadiusAlter(color: UIColor, view: UIView) {
        view.layer.addBorderRect(color: color, thickness: 4)
        view.layer.cornerRadius = view.frame.width / 2
    }
    
    private func configureCell() {
        guard let cellViewModel = cellViewModel else {
            return
        }
        if let title = cellViewModel.title {
            self.categoryLabel.text = title
        }

        if let imgUrl = cellViewModel.imageUrl {
            self.categoryImageView.downloadImageFromUrl(urlString: imgUrl)
        }
        
        if let minimumValue = cellViewModel.minValue, let maximumValue = cellViewModel.maxValue {
            oneTo10Labels.tickMinMax = CGPoint(x: minimumValue, y: maximumValue)
            let diff: CGFloat = CGFloat(CGFloat(maximumValue - minimumValue) / 9000)
            expenseSlider.incrementValue = diff
            expenseSlider.minimumValue = CGFloat(minimumValue / 1000)
        }
        
        if var price = cellViewModel.price {
            if let min = cellViewModel.minValue, price < min {
                price = min
            } else if let max = cellViewModel.maxValue, price > max {
                price = max
            }
            
            self.spendingLabel.attributedText = .getAttributedTextForRoom(changingValues: "\(price)")
            self.expenseSlider.value = CGFloat((CGFloat(price)) / 1000)
            setEndRadioColor()
        }
    }
    
    private func setEndRadioColor() {
        if let cellModel = cellViewModel, let max = cellModel.maxValue, expenseSlider.value >= CGFloat(max) {
            endView.layer.borderColor = ColorConstant.startPointRadioColor.cgColor
        } else {
            endView.layer.borderColor = ColorConstant.endPointRadioColor.cgColor
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        print(" MyPointsCell deinit called")
    }
}
class PointCalculatorCellModel: NSObject {
    var imageUrl: String?
    var title: String?
    var price: Int?
    var minValue: Int?
    var maxValue: Int?
    var earnPointsForValue: Float?
    
    init(withPointCalculator result: PointCalculator.PointsCalculatorInfo.Categories) {
        if let catTitle = result.iconText {
            self.title = catTitle
        }
        
        if let initialPrice = result.initialValue {
            self.price = initialPrice
        }
        
        if let minimum = result.minValue {
            self.minValue = minimum
        }
        
        if let maximum = result.maxValue {
            self.maxValue = maximum
        }
        
        if let earnPtPerValue = result.earnPointsForValue {
            self.earnPointsForValue = earnPtPerValue
        }
        
        if let imgURL = result.iconImage {
            self.imageUrl = imgURL
        }
    }
}
