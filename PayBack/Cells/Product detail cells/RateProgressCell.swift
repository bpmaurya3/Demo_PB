//
//  RateProgressCell.swift
//  PaybackPopup
//
//  Created by Mohsin Surani on 01/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class RateProgressCell: UITableViewCell {

    @IBOutlet weak private var ratingNumber: UILabel!
    @IBOutlet weak private var ratingProgressView: UIProgressView!
    
    let ratingNumbers = ["5", "4", "3", "2", "1"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.ratingProgressView.layer.masksToBounds = true
        self.ratingProgressView.layer.cornerRadius = 5
    }
    
    func configureProgressCell(index: IndexPath) {
        self.ratingNumber.text = ratingNumbers[index.row]
        let progress: Float = Float(ratingNumbers[index.row]) ?? 0
        self.ratingProgressView.setProgress(progress / 5, animated: false)

        if index.row == ratingNumbers.count - 1 {
            self.ratingProgressView.progressTintColor = UIColor(red: 244 / 255, green: 147 / 255, blue: 66 / 255, alpha: 1)
        } else {
            self.ratingProgressView.progressTintColor = UIColor(red: 22 / 255, green: 155 / 255, blue: 78 / 255, alpha: 1)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        print(" RateProgressCell deinit called")
    }
}
