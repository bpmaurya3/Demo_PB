//
//  AvgRatingCell.swift
//  PayBack
//
//  Created by Valtech Macmini on 12/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class AvgRatingCell: UITableViewCell, UITableViewDataSource {

    @IBOutlet weak private var errorView: UIView!
    @IBOutlet weak private var errorMsg: UILabel!
    @IBOutlet weak private var ratingTableView: UITableView!
    @IBOutlet weak private var ratinglabel: UILabel!
    @IBOutlet weak private var ratingReviewLabel: UILabel!
    @IBOutlet weak private var rateNowButton: UIButton!
    
    var ratingActionHandler: (() -> Void )?
    let ratingNumber = ["5", "4", "3", "2", "1"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ratingTableView.register(UINib(nibName: Cells.rateProgressNibID, bundle: nil), forCellReuseIdentifier: Cells.rateProgressNibID)
        errorView.isHidden = true
        errorMsg.text = ""
        rateNowButton.isHidden = true
    }

    var cellViewModel: ReviewCellModel? {
        didSet {
            errorView.isHidden = true
            if let avgRating = cellViewModel?.avgRating {
                ratinglabel.text = "\(Float(avgRating))"
            }
            if let avgRatingCount = cellViewModel?.avgRatingCount, let avgReviewCount = cellViewModel?.avgReviewCount {
                ratingReviewLabel.text = "\(avgRatingCount) Ratings | \(avgReviewCount) Reviews"
                let lines = self.lines()
                if lines >= 2 {
                    ratingReviewLabel.text = "\(avgRatingCount) Ratings |\(avgReviewCount) Reviews"
                }
            }
        }
    }
    var cellErrorMsg: String? {
        didSet {
            errorMsg.text = cellErrorMsg
            errorView.isHidden = false
        }
    }
    
    private func lines() -> Int {
        var lineCount = 0
        let textSize = CGSize(width: ratingReviewLabel.frame.size.width, height: CGFloat(Float.infinity))
        let rHeight = lroundf(Float(ratingReviewLabel.sizeThatFits(textSize).height))
        let charSize = lroundf(Float(ratingReviewLabel.font.lineHeight))
        lineCount = rHeight / charSize
        print("No of lines \(lineCount)")
        return lineCount
    }
    
    @IBAction func rateORReviewClicked(_ sender: Any) {
        ratingActionHandler?()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratingNumber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.rateProgressNibID, for: indexPath) as? RateProgressCell else {
            return UITableViewCell()
        }
        cell.configureProgressCell(index: indexPath)
        return cell
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        print(" AvgRatingCell deinit called")
    }
}
