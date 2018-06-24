//
//  NoCartUpperTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/4/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class NoCartUpperTVCell: UITableViewCell {

    @IBOutlet weak fileprivate var iconImageView: UIImageView!
    @IBOutlet weak fileprivate var title: UILabel!
    @IBOutlet weak fileprivate var descriptionLabel: UILabel!
    @IBOutlet weak fileprivate var continueShoppingBut: UIButton!
    
    var cellModel: NoCartUpperTVCellModel? {
        didSet {
            guard let cellModel = cellModel else {
                return
            }
           self.parseData(with: cellModel)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = ColorConstant.collectionViewBGColor
        continueShoppingBut.backgroundColor = ColorConstant.shopNowButtonBGColor
        continueShoppingBut.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        // Initialization code
    }
    
    private func parseData(with model: NoCartUpperTVCellModel) {
        self.iconImageView.image = model.iconImage
        self.title.text = model.title
        self.descriptionLabel.text = model.descriptionString
    }

    @IBAction func continueShoppingAction(_ sender: Any) {
        print("No cart continue shopping action")
        if let viewController = self.parentViewController?.getPreviousViewController(of: "RewardsCatalogueVC") {
            self.parentViewController?.navigationController?.popToViewController(viewController, animated: true)
        } else if let rewardsCatalogueVC = RewardsCatalogueVC.storyboardInstance(storyBoardName: "Burn") as? RewardsCatalogueVC {
            self.parentViewController?.navigationController?.pushViewController(rewardsCatalogueVC, animated: true)
        }
    }
}

class NoCartUpperTVCellModel: NSObject {
    var iconImage: UIImage
    var title: String
    var descriptionString: String
    
     init(iconImage: UIImage, title: String, descriptionString: String) {
        self.iconImage = iconImage
        self.title = title
        self.descriptionString = descriptionString
    }
}
