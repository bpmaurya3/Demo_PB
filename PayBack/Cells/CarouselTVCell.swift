//
//  CarouselTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/12/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class CarouselTVCell: UITableViewCell {
    
    var tapOnCarousel: (_ link: String, _ logoPath: String) -> Void = { _, _ in }
    
    fileprivate var carousel: PBCarousel = {
        let carousel = PBCarousel(frame: .zero)
        carousel.backgroundColor = .clear
        return carousel
    }()
    
    var carouselSlides: [HeroBannerCellModel]? {
        didSet {
            guard let slides = carouselSlides else {
                return
            }
            self.carousel.slides = slides
            self.carousel.cellActionHandler = { [weak self] index in
                let data = slides[index]
                if let strongSelf = self, let redirectUrl = data.redirectionURL, redirectUrl != "" {
                    strongSelf.redirectVC(redirectLink: redirectUrl, redirectLogoUrl: data.redirectionPartnerLogo)
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        print("CarouselTVCell: deinit called")
    }
    
    private func setup() {
        addSubview(self.carousel)
        self.selectionStyle = .none
        self.addConstraintsWithFormat("H:|[v0]|", views: self.carousel)
        self.addConstraintsWithFormat("V:|[v0]|", views: self.carousel)
        
        let configuration = PBCarouselConfiguration()
            .set(collectionViewBounce: true)
            .set(collectionViewCellName: .partnerDetailCarousel)
            .set(isHeroCarousel: true)
        
        carousel.confugure(withConfiguration: configuration)
        carousel.cellActionHandler = { [weak self] Data in
            guard let slideImageData = self?.carouselSlides?[Data] else {
                return
            }
            if let redirectUrl = slideImageData.redirectionURL {
                self?.redirectVC(redirectLink: redirectUrl, redirectLogoUrl: slideImageData.redirectionPartnerLogo)
            }
        }
    }    

}
extension CarouselTVCell {
    func redirectVC(redirectLink: String, redirectLogoUrl: String? = "") {
        tapOnCarousel(redirectLink, redirectLogoUrl ?? "")
    }
}
