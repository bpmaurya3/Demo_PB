//
//  PBUserOffersTVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 22/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBUserOffersTVCell: UITableViewCell {

    @IBOutlet weak private var progressImage: UIImageView!
    @IBOutlet weak private var icon: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    @IBOutlet weak private var titleDescreption: UILabel!
    var sourceData: PBUserOffersTVCellModel? {
        didSet {
            guard let sourceData = sourceData else {
                return
            }
            self.parseData(withUserOfferData: sourceData)
        }
    }
    func parseData(withUserOfferData data: PBUserOffersTVCellModel) {
        if let iconImage = data.rewardsIcon {
            self.icon.image = iconImage
        }
        if let title = data.title {
            self.titleLabel.text = title
        }
        if let progressImg = data.progresStatue {
            self.progressImage.image = progressImg
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.font = FontBook.Regular.of(size: 15.0)
        self.titleLabel.textColor = ColorConstant.pointTextColor
        self.titleDescreption.font = FontBook.Regular.of(size: 12.0)
        self.titleDescreption.textColor = ColorConstant.bonusPointTextColor
        self.backgroundView?.backgroundColor = ColorConstant.bonusBackGroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        print(" PBUserOffersTVCell deinit called")
    }
    
}
