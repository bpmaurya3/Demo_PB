//
//  PBUserPointTVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 22/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBUserPointTVCell: UITableViewCell {

    @IBOutlet weak fileprivate var mPointBalance: UILabel!
    @IBOutlet weak fileprivate var mPointBalanceLabel: UILabel!
    @IBOutlet weak fileprivate var mImageView: UIImageView!
    @IBOutlet weak fileprivate var cardName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        mPointBalance.font = FontBook.Regular.of(size: 25.0)
        mPointBalance.textColor = ColorConstant.pointTextColor
        mPointBalanceLabel.font = FontBook.Regular.of(size: 12.0)
        mPointBalanceLabel.textColor = ColorConstant.pointlightGrayTextColor
        let userDetails = UserProfileUtilities.getUserDetails()
        if let totalPoints = userDetails?.TotalPoints {
            self.mPointBalance.text = "\(StringConstant.pointsSymbol)\(totalPoints)"
        } else {
            self.mPointBalance.text = "\(StringConstant.pointsSymbol)0"
        }
        var name: String = ""
        if let fname = userDetails?.FirstName {
            name = "\(fname)"
        }
        if let lname = userDetails?.LastName {
            name = "\(name) \(lname)"
        }
        self.cardName.text = "\(name)"
        self.mPointBalanceLabel.text = "Current Point Balance"
    }
    
    deinit {
        print(" PBUserPointTVCell deinit called")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
