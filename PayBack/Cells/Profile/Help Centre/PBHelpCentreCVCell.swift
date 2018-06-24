//
//  PBHelpCentreCVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 15/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBHelpCentreCVCell: UICollectionViewCell {
    
    @IBOutlet weak fileprivate var mImageView: UIImageView!
    @IBOutlet weak fileprivate var mLabel: UILabel!
    var cellModel: PBHelpCentreTVCellModel? {
        didSet {
            guard let model = cellModel else {
                return
            }
            self.parseData(forHelpGridCellData: model)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 1
        mLabel.font = FontBook.Regular.of(size: 11.0)
        mLabel.textColor = ColorConstant.helpCentreTextColor
    }
    
    private func parseData(forHelpGridCellData cellData: PBHelpCentreTVCellModel) {
        if let title = cellData.title {
            self.mLabel.text = title
        }
        if let imagePath = cellData.imagePath {
            self.mImageView.downloadImageFromUrl(urlString: imagePath)
        }
    }
}

extension PBHelpCentreCVCell {
    @discardableResult
    func update(isImageViewHidden shouldHidden: Bool) -> Self {
        self.mImageView.isHidden = shouldHidden
        self.layer.shadowColor = shouldHidden ? UIColor.clear.cgColor : UIColor.lightGray.cgColor
        return self
    }
    
    @discardableResult
    func update(isTextLabelHidden shouldHidden: Bool) -> Self {
        self.mLabel.isHidden = shouldHidden
        self.layer.shadowColor = shouldHidden ? UIColor.clear.cgColor : UIColor.lightGray.cgColor
        return self
    }
}
