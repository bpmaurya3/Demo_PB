//
//  ProductDetailsCarouselCVCell.swift
//  PayBack
//
//  Created by Mohsin Surani on 06/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//  Warning stopped

import UIKit

class ProductDetailsCarouselCVCell: UICollectionViewCell {
    
    var carouselHeaderCellModel: HeroBannerCellModel? {
        didSet {
            guard let cellModel = carouselHeaderCellModel else {
                return
            }
            self.parseData(forBannerCellData: cellModel)
        }
    }
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        self.addSubview(self.backgroundImageView)
        self.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: self.backgroundImageView)
        self.addConstraintsWithFormat("V:|-15-[v0]-10-|", views: self.backgroundImageView)
    }
    
    private func parseData(forBannerCellData bannerData: HeroBannerCellModel) {
        if let image = bannerData.image {
            self.backgroundImageView.image = image
        }
        
        if let imageUrl = bannerData.imagePath {
            self.backgroundImageView.downloadImageFromUrl(urlString: imageUrl, imageType: .carousel)
        } else {
            self.backgroundImageView.image = #imageLiteral(resourceName: "placeholder")
        }
    }
    deinit {
        print("HeroBannerCVCell: deinit called")
    }
}
