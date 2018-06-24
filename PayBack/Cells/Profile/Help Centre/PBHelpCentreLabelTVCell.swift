//
//  PBHelpCentreLabelTVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 15/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBHelpCentreLabelTVCell: UITableViewCell {
    
    @IBOutlet weak private var mLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mLabel.font = FontBook.Regular.of(size: 15.0)
        mLabel.textColor = ColorConstant.productListTextColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
