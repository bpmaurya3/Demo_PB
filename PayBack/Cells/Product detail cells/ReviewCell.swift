//
//  ReviewCell.swift
//  PaybackPopup
//
//  Created by Mohsin Surani on 23/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var retingStarImage: UIImageView!
    @IBOutlet weak private var rateTitleLabel: UILabel!
    @IBOutlet weak private var rateDescLabel: UILabel!
    @IBOutlet weak private var custDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DispatchQueue.main.async { [weak self] in
            self?.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }

    var cellViewModel: ReviewCellModel? {
        didSet {
            self.configureCell()
        }
    }
    
    private func configureCell() {
        if let reviewTitle = cellViewModel?.reviewTitle {
            rateTitleLabel.text = reviewTitle
        } else {
            rateTitleLabel.text = ""
        }
        if let reviewDetail = cellViewModel?.reviewDetail {
            rateDescLabel.text = reviewDetail
        } else {
            rateDescLabel.text = ""
        }
        if let reviewDate = cellViewModel?.reviewDate, let reviewCustName = cellViewModel?.reviewCustName {
            custDateLabel.text = "\(reviewCustName), \(reviewDate)"
        } else {
            custDateLabel.text = ""
        }
        if let rating = cellViewModel?.rating {
            ratingLabel.text = "  \(rating)"
            ratingLabel.isHidden = false
            retingStarImage.isHidden = false
        } else {
            ratingLabel.isHidden = true
            retingStarImage.isHidden = true
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    deinit {
        print(" ReviewCell deinit called")
    }
}
