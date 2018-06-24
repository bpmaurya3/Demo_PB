//
//  ExclusiveBenefitsCVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 22/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ExclusiveBenefitsCVCell: UICollectionViewCell {

    @IBOutlet weak fileprivate var mBaseView: UIView!
    @IBOutlet weak fileprivate var mLabel: UILabel!
    @IBOutlet weak fileprivate var mImageView: UIImageView!
    
    var cellModel: ExclusiveBenefitsCVCellModel? {
        didSet {
            guard let model = cellModel else {
                return
            }
            self.parseData(cellData: model)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mLabel.font = FontBook.Regular.of(size: 11.0)
        mLabel.textColor = ColorConstant.textColorGray
        mBaseView.layer.borderColor = ColorConstant.paybackPlusExclusiveBoxBorderColor.cgColor
        mBaseView.layer.borderWidth = 1
        mBaseView.layer.cornerRadius = 5
    }
    
    deinit {
        print("ExclusiveBenefitsCVCell deinit called")
    }
    
    override var isSelected: Bool {
        didSet {
            mBaseView.backgroundColor = isSelected ? ColorConstant.paybackPlusBackGroundColorPurple : .white
            mLabel.textColor = isSelected ? .white : ColorConstant.textColorGray
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            mBaseView.backgroundColor = isHighlighted ? ColorConstant.paybackPlusBackGroundColorPurple : .white
            mLabel.textColor = isHighlighted ? .white : ColorConstant.textColorGray
        }
    }
    
    private func parseData(cellData: ExclusiveBenefitsCVCellModel) {
        if let title = cellData.title {
            self.mLabel.text = title
        }
        if let thumbnailImage = cellData.thumbnailImage {
            self.mImageView.image = thumbnailImage
        }
        if let thumbnailPath = cellData.imagePath {
            self.mImageView.downloadImageFromUrl(urlString: thumbnailPath)
        }
    }
}

extension ExclusiveBenefitsCVCell {
    @discardableResult
    func update(baseviewBGColor color: UIColor) -> Self {
        self.mBaseView.backgroundColor = color
        
        return self
    }
    
    @discardableResult
    func update(textColor color: UIColor) -> Self {
        self.mLabel.textColor = color
        
        return self
    }
}
