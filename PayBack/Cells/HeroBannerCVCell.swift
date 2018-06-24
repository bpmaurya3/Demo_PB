//
//  HeroBannerCVCell.swift
//  PayBack
//
//  Created by Mohsin Surani on 06/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//  Warning stopped

import UIKit

class HeroBannerCVCell: UICollectionViewCell {
    
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
        imageView.contentMode = .scaleToFill
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
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundImageView.image = nil
    }
    private func setupViews() {
        self.addSubview(self.backgroundImageView)
        self.addConstraintsWithFormat("H:|[v0]|", views: self.backgroundImageView)
        self.addConstraintsWithFormat("V:|[v0]|", views: self.backgroundImageView)
    }
    
    private func parseData(forBannerCellData bannerData: HeroBannerCellModel) {
        
        if let imageUrl = bannerData.imagePath {
            self.backgroundImageView.downloadImageFromUrl(urlString: imageUrl, imageType: .carousel)
        } else {
            if let image = bannerData.image {
                self.backgroundImageView.image = image
            } else {
                self.backgroundImageView.image = #imageLiteral(resourceName: "placeholder")
            }
        }
    }
    deinit {
        print("HeroBannerCVCell: deinit called")
    }
    
    @discardableResult
    func set(imageViewContentMode mode: UIViewContentMode) -> Self {
        self.backgroundImageView.contentMode = mode
        
        return self
    }
}
