//
//  FourthCartReviewTVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 13/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class FourthCartReviewTVCell: UITableViewCell {

    @IBOutlet weak private var mLabel: UILabel!
    @IBOutlet weak private var mAddButton: UIButton!
    
    var addAddressClouser: (() -> Void) = {  }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        mLabel.font = FontBook.Medium.of(size: 12)
        mAddButton.titleLabel?.font = FontBook.Light.of(size: 18)
    }
    
    deinit {
        print("FourthCartReviewTVCell deinit called")
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        addAddressClouser()
    }
}
