//
//  OnlinePartnerCell.swift
//  PayBack
//
//  Created by Mohsin Surani on 05/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class OnlinePartnerCell: UICollectionViewCell {
    var otherOnLinePartnerModel: OnlinePartnerCellModel? {
        didSet {
            guard let cellModel = otherOnLinePartnerModel else {
                return
            }
            self.parseData(forOtherOnLinePartnerCellData: cellModel)
        }
    }
    @IBOutlet weak private var partnerImageView: UIImageView!
    @IBOutlet weak private var earnPointsLabel: UILabel!
    @IBOutlet weak private var bookDriveButton: UIButton!
    @IBOutlet weak private var earnPointsLabelHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        partnerImageView.backgroundColor = .clear
        bookDriveButton.titleLabel?.adjustsFontSizeToFitWidth = true
        bookDriveButton.isUserInteractionEnabled = false
        earnPointsLabel.font = FontBook.Regular.of(size: 12)
        if DeviceType.IS_IPHONE_5 {
            self.bookDriveButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 135, bottom: 0, right: 0)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.bookDriveButton.titleLabel?.font = FontBook.Medium.of(size: 12)
        }
    }
    
    deinit {
        print("OnlinePartnerCell: deinit called")
    }
    
    private func parseData(forOtherOnLinePartnerCellData otherOnLinePartnerCellData: OnlinePartnerCellModel) {
        if let imageUrl = otherOnLinePartnerCellData.logoImage {
            self.partnerImageView.downloadImageFromUrl(urlString: imageUrl)
        }
        if let descriptionText = otherOnLinePartnerCellData.descriptionText, !descriptionText.isEmpty {
            self.earnPointsLabel.text = descriptionText
        } else {
            self.earnPointsLabelHeightConstraint.constant = 0
        }
        
        if let linkText = otherOnLinePartnerCellData.linkText, !linkText.isEmpty {
            self.bookDriveButton.setTitle("\(linkText.uppercased())", for: .normal)
        } else {
            self.bookDriveButton.isHidden = true
        }
    }
}
