//
//  GridViewCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 04/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class GridViewCell: UICollectionViewCell {
    
    @IBOutlet weak fileprivate var opacityView: UIView!
    
    var mLabelText: String = ""{
        didSet {
            configureCell()
        }
    }
    
    var categoryDataArray: LandingTilesGridCellModel? {
        didSet {
            guard let gridItem = categoryDataArray else {
                return
            }
            self.parseData(forOfferGridItem: gridItem)
        }
    }
    @IBOutlet weak private var mBaseImageView: UIImageView!
    @IBOutlet weak private var mIconImageView: UIImageView!
    @IBOutlet weak private var mIconLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mIconImageView.backgroundColor = ColorConstant.primaryColorPink
        mIconLabel.font = FontBook.Regular.of(size: 20)
        self.opacityView.backgroundColor = ColorConstant.secondaryNavigationBGColor
    }
    
    private func configureCell() {
        mIconLabel.text = mLabelText
    }

    deinit {
        print("GridViewCell deinit called")
    }
    
    private func parseData(forOfferGridItem gridItem: LandingTilesGridCellModel) {
        if let allow = gridItem.allowBgLayout {
            self.opacityView.backgroundColor = allow ? ColorConstant.secondaryNavigationBGColor : .clear
        }
        if let imagePath = gridItem.imagePath {
            self.mBaseImageView.downloadImageFromUrl(urlString: imagePath, imageType: .offerTiles)
        } else {
            self.mIconImageView.image = UIImage()
        }
        if let iconImagePath = gridItem.iconImagePath {
            self.mIconImageView.isHidden = false
            self.mIconImageView.downloadImageFromUrl(urlString: iconImagePath)
        } else {
            self.mIconImageView.isHidden = true
        }
        if let title = gridItem.title {
            self.mIconLabel.text = title
        }
    }
}
