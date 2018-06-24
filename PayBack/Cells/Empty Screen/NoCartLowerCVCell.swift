//
//  NoCartLowerCVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/4/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class NoCartLowerCVCell: UICollectionViewCell {
   
    @IBOutlet weak fileprivate var imageView: UIImageView!
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var pointsView: SwitchView!
    
    var cellModel: TopTrendCVCellModel? {
        didSet {
            guard let cellModel = cellModel else {
                return
            }
            parseData(cellModel: cellModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
    }
    
    private func parseData(cellModel: TopTrendCVCellModel) {
        if let image = cellModel.productImage {
            self.imageView.image = image
        }
        if let title = cellModel.productTitle {
            self.titleLabel.text = title
        }
        if let points = cellModel.productEarnPoints {
            self.pointsView.titleLable.text = points
        }
        
        if let imagePath = cellModel.imagePath {
            self.imageView.downloadImageFromUrl(urlString: imagePath)
        }
    }
   
}
