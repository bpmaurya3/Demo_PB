//
//  OtherPartnerCollectionCell.swift
//  PayBack
//
//  Created by Dinakaran M on 07/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class OtherPartnerCVCell: UICollectionViewCell {
    
    @IBOutlet weak private var otherimage: UIImageView!
    
    var partnerCollectionCell: OtherPartnerCollectionCellModal? {
        didSet {
            guard let cellModel = partnerCollectionCell else {
                return
            }
            self.parseData(forPartnerColleCelldata: cellModel)
        }
    }
    func parseData(forPartnerColleCelldata collectionData: OtherPartnerCollectionCellModal) {
        if let image = collectionData.image {
            self.otherimage.image = image
        }
        if let imagePath = collectionData.imagePath {
            self.otherimage.downloadImageFromUrl(urlString: imagePath)
        }
    }
}

class OtherPartnerCollectionCellModal: NSObject {
    var image: UIImage?
    var imagePath: String?
    internal init(image: String? = nil) {
        if let img = image {
            self.image = UIImage(named: img)
        }
    }
    init(withPartnerDetails partner: OtherPartner.PartnerDetails) {
        if let logoImage = partner.logoImage {
            self.imagePath = logoImage
        }
    }
    override init() {
        super.init()
    }
}
