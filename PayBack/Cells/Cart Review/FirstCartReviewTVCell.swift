//
//  FirstCartReviewTVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 13/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class FirstCartReviewTVCell: UITableViewCell {

    @IBOutlet weak private var shippingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        shippingLabel.font = FontBook.Bold.of(size: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        print("FirstCartReviewTVCell deinit called")
    }
}
