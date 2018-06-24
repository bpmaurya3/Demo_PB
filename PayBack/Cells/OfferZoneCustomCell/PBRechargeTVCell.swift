//
//  PBRechargeTVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 20/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBRechargeTVCell: UITableViewCell {

    var rechargeCellModel: RechargeCellModel? {
        didSet {
            guard let cellModel = rechargeCellModel else {
                return
            }
            self.parseData(forRechargeCellData: cellModel)
        }
    }
    
    @IBOutlet weak private var partnerInfo: UILabel!
    @IBOutlet weak private var partnerName: UILabel!
    @IBOutlet weak private var partnerImageView: UIImageView!
    
    var goOfferTapClouser: (() -> Void) = {  }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    deinit {
        print(" PBRechargeTVCell deinit called")
    }
    
    func setupUI() {
        partnerImageView.layer.borderWidth = 1
        partnerImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.selectionStyle = .none
    }
    
    private func parseData(forRechargeCellData rechargeCellData: RechargeCellModel) {
        if let image = rechargeCellData.partnerImage {
            self.partnerImageView.image = image
        }
        if let partnerName = rechargeCellData.partnerName {
            self.partnerName.text = partnerName
        }
        if let partnerInfo = rechargeCellData.partnerInfo {
            self.partnerInfo.text = partnerInfo
        }
    }
    
    @IBAction func getOfferButtonAction(_ sender: UIButton) {
        goOfferTapClouser()
    }
}

internal class RechargeCellModel: NSObject {
    var partnerImage: UIImage?
    var partnerInfo: String?
    var partnerName: String?
    
    internal init(partnerImage: UIImage, partnerName: String, partnerInfo: String) {
        self.partnerImage = partnerImage
        self.partnerName = partnerName
        self.partnerInfo = partnerInfo
    }
    
    override init() {
    }
}
