//
//  ScondCartReviewTVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 13/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ScondCartReviewTVCell: UITableViewCell {
    
    @IBOutlet weak private var mAddressLabel: UILabel!
    @IBOutlet weak private var editButton: UIButton!
    @IBOutlet weak private var borderView: UIView!

    var editActionHandler: ((Int) -> Void )?

    var cellViewModel: AddressSplitCellModel? {
        didSet {
            self.configureCell()
        }
    }
    
    func setEditButtonTag(tag: Int) {
        self.editButton.tag = tag
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func editClicked(_ sender: UIButton) {
        editActionHandler?(sender.tag)
    }
    
    private func configureCell() {
        guard let cellViewModel = cellViewModel else {
            return
        }
        if cellViewModel.id == UserProfileUtilities.getUserID() {
            self.editButton.isHidden = true
        } else {
            self.editButton.isHidden = false
        }
        
        var integratedText = ""
        if let address1 = cellViewModel.address1 {
            integratedText.append(address1)
            integratedText.append(", ")
        }
        if let address2 = cellViewModel.address2 {
            integratedText.append(address2)
            integratedText.append(",\n")
        }
        if let city = cellViewModel.city {
            integratedText.append(city)
            integratedText.append(" - ")
        }
        if let pincode = cellViewModel.pin {
            integratedText.append(pincode)
            integratedText.append(",\n")
        }
        if let state = cellViewModel.state {
            integratedText.append(state)
            integratedText.append("\n")
        }
        if let mobile = cellViewModel.mobile {
            integratedText.append("Mobile: ")
            integratedText.append(mobile)
            integratedText.append("\n")
        }
        if let email = cellViewModel.emailid {
            integratedText.append("Email ID: ")
            integratedText.append(email)
        }
        
        if let defaultAddress = cellViewModel.tempDefaultaddress {
            let isDefault = NSString(string: defaultAddress).boolValue
            self.addBorderToSelectedAddress(isDefault: isDefault)
        }
        mAddressLabel.attributedText = .getAttributedStringForAddress(name: cellViewModel.name ?? "", changingValues: integratedText)
    }
    func addBorderToSelectedAddress(isDefault: Bool) {
        DispatchQueue.main.async {
            self.borderView.layer.addBorderRect(color: isDefault ? ColorConstant.primaryColorPink : .gray, thickness: 1)
        }
    }
    deinit {
        print("ScondCartReviewTVCell deinit called")
    }
}
