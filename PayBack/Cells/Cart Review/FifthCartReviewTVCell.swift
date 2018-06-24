//
//  FifthCartReviewTVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 13/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class FifthCartReviewTVCell: UITableViewCell {

    @IBOutlet weak private var mEditButton: UIButton!
    @IBOutlet weak private var mDeliveryTypeLabel: UILabel!
    @IBOutlet weak private var freeDeliveryLabel: UILabel!
    @IBOutlet weak private var estDeliveryLabel: UILabel!
    @IBOutlet weak private var orderSummarylabel: UILabel!

    @IBOutlet weak private var viewContent: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        freeDeliveryLabel.attributedText = .getAttributedStringForFreeDelivery(staticText: "Free Delivery ", changingValues: "(Approx 4-5 business days)")
        estDeliveryLabel.attributedText = .getAttributedStringForEstDelivery(staticText: "Estimated Delivery: ", changingValues: "15th Feb 2017")
        viewContent.layer.addBorderRect(color: .blue, thickness: 1)
        
        mDeliveryTypeLabel.font = FontBook.Bold.of(size: 15)
        orderSummarylabel.font = FontBook.Bold.of(size: 15)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    deinit {
        print("FifthCartReviewTVCell deinit called")
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
    }
}
