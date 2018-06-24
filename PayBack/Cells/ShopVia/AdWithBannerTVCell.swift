//
//  AdWithBannerTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/7/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class AdWithBannerTVCell: UITableViewCell {

    var adWithBannerCellModel: HeroBannerCellModel? {
        didSet {
            guard let cellModel = adWithBannerCellModel else {
                self.backgroundImageView.image = nil
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        self.selectionStyle = .none
        self.backgroundColor = ColorConstant.vcBGColor
        self.addSubview(self.backgroundImageView)
        self.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: self.backgroundImageView)
        self.addConstraintsWithFormat("V:|[v0]|", views: self.backgroundImageView)
    }
    
    private func parseData(forBannerCellData bannerData: HeroBannerCellModel) {
        if let image = bannerData.image {
            self.backgroundImageView.image = image
        }
        if let imageUrl = bannerData.imagePath {
            self.backgroundImageView.downloadImageFromUrl(urlString: imageUrl, imageType: .banner)
        }
    }
    deinit {
        print("AdWithBannerTVCell: deinit called")
    }
}
