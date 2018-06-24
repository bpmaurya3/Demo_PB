//
//  CarouselCVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 1/18/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

class CarouselCVCell: UICollectionViewCell {
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
            self.carousel.cellActionHandler = { index in
                
                let data = slides[index]
                if let redirectUrl = data.redirectionURL {
                    self.redirectVC(redirectLink: redirectUrl, redirectLogoUrl: data.redirectionPartnerLogo)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    deinit {
        print("CarouselCVCell: deinit called")
    }
    
    private func setup() {
        addSubview(self.carousel)
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
// Redirection ViewController
extension CarouselCVCell {
    func redirectVC(redirectLink: String, redirectLogoUrl: String? = "") {
        tapOnCarousel(redirectLink, redirectLogoUrl ?? "")
    }
}
