//
//  ExploreFirstTableViewCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 24/05/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit

class ExploreFirstTableViewCell: UITableViewCell {

    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var thumbnailContainerView: UIView!
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var playButton: UIButton!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var buttonInfoLabel: UILabel!
    @IBOutlet weak private var clickHereButton: UIButton!
    
    var playButtonClouser: ((ExplorePayBackCellModel) -> Void) = { _ in }
    var explorePaybackCellModel: ExplorePayBackCellModel? {
        didSet {
            guard let cellModel = explorePaybackCellModel else {
                return
            }
            self.parseData(forData: cellModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clickHereButton.layer.cornerRadius = 3
        activityIndicator.isHidden = true
        blackView.layer.cornerRadius = 10
        titleLabel.font = FontBook.Bold.ofTVCellTitleSize()
        descriptionLabel.font = FontBook.Regular.ofTVCellSubTitleSize()
        buttonInfoLabel.font = FontBook.Italic.ofTVCellSubTitleSize()
        clickHereButton.titleLabel?.font = FontBook.Medium.ofButtonTitleSize()
        clickHereButton.titleLabel?.textColor = ColorConstant.textColorWhite
        titleLabel.textColor = ColorConstant.textColorBlack
        descriptionLabel.textColor = ColorConstant.textColorGray
        buttonInfoLabel.textColor = ColorConstant.textColorGray
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        descriptionLabel.text = ""
        buttonInfoLabel.text = ""
        titleLabel.text = ""
    }
    
    fileprivate func parseData(forData data: ExplorePayBackCellModel) {
        if let title = data.title {
            titleLabel.text = title
        }
        if let description = data.descreption {
            descriptionLabel.text = description
        }
        if let buttonInfo = data.buttonDescription {
            buttonInfoLabel.text = buttonInfo
        }
        if let btnTitle = data.buttonTitle {
            clickHereButton.setTitle(btnTitle, for: .normal)
        }
        if let videoID = data.videoId {
            thumbnailImageView.downloadImageFromUrl(urlString: getImageURl(videoID: videoID))
        }
    }
    
    func updateCell(showIndicator: Bool) {
        if showIndicator {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            playImageView.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            playImageView.isHidden = false
        }
    }
    
    fileprivate func getImageURl(videoID: String) -> String {
        let thumbImageURL = "https://i.ytimg.com/vi/\(videoID)/mqdefault.jpg"
        return thumbImageURL
    }
    
    @IBAction func clickHereButtonAction(_ sender: UIButton) {
        playButtonClouser(explorePaybackCellModel!)
    }
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        playButtonClouser(explorePaybackCellModel!)
    }
    
}
