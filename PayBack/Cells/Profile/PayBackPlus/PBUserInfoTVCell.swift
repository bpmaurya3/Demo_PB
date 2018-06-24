//
//  PBUserInfoTVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 22/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBUserInfoTVCell: UITableViewCell {

    @IBOutlet weak private var mProfileName: UILabel!
    @IBOutlet weak private var mProfileDate: UILabel!
    
    var cellModel: UserProfileModel? {
        didSet {
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mProfileName.font = FontBook.Light.of(size: 17.5)
        self.mProfileName.textColor = ColorConstant.textColorWhite
        self.mProfileDate.font = FontBook.Regular.of(size: 12.0)
        self.mProfileDate.textColor = ColorConstant.textColorWhite
    }
    
    private func configureCell() {
        var name: String = ""
        self.mProfileName.text = ""

        if let firstName = cellModel?.FirstName {
            name = firstName
        }
        if let lastName = cellModel?.LastName {
            name += " "+lastName
        }
        if name != "" {
            self.mProfileName.text = "Hi, \(name)"
        } else {
            self.mProfileName.text = "Hi,"
        }
        self.mProfileDate.text = "Member since: "
    }
    
    deinit {
        print(" PBUserInfoTVCell deinit called")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
