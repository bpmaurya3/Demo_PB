//
//  OnBoardCVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/27/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class OnBoardCVCell: UICollectionViewCell {
    @IBOutlet weak private var backgroundImgV: UIImageView!
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundImgV.contentMode = .scaleToFill
    }
    deinit {
        print("OnboardCVCell deinit called")
    }
    internal var slide: HeroBannerCellModel? {
        didSet {
            guard let slide = slide else {
                return
            }
            self.parseData(forSlide: slide)
        }
    }
    
    func parseData(forSlide slide: HeroBannerCellModel) {
        if let image = slide.image {
            self.backgroundImgV.image = image
        }
        if let imageUrl = slide.imagePath {
            self.backgroundImgV.downloadImageFromUrl(urlString: imageUrl, imageType: .none)
            backgroundImgV.contentMode = .scaleToFill
        } else {
            self.backgroundImgV.image = #imageLiteral(resourceName: "placeholder")
            self.backgroundImgV.contentMode = .scaleAspectFit
        }
        if let title = slide.title {
            self.titleLabel.text = title
        }
        
        if let description = slide.subTitle {
            self.descriptionLabel.text = description
        }
    }
}
