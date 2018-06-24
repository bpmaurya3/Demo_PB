//
//  RightMenuCustomCell.swift
//  PayBack
//
//  Created by Dinakaran M on 01/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class RightMenuCustomCell: UITableViewCell {

    @IBOutlet weak fileprivate var name: UILabel!
    @IBOutlet weak fileprivate var icon: UIImageView!
    
    var cellModel: RightMenuItem? {
        didSet {
            self.parseData(withItem: cellModel!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.name.textColor = ColorConstant.rightMenuTextColor
        self.name.font = FontBook.Arial.of(size: 12.0)
       
    }

    private func parseData(withItem item: RightMenuItem) {
        if let iconName = item.icon {
            self.icon.image = UIImage(named: iconName)
        }
        if let name = item.name {
            let percentage = UserProfileUtilities.userPercentage()
            
            if item.itemId == "MyAccountVC" && UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged), percentage < 100 {
                let attributeString = NSMutableAttributedString(string: name + " (Profile is \(percentage)% complete)")
                attributeString.addAttributes([NSAttributedStringKey.font: FontBook.Regular.of(size: 12.0) ], range: NSRange(location: 0, length: name.length))
                attributeString.addAttributes([NSAttributedStringKey.font: FontBook.Regular.of(size: 10.0) ], range: NSRange(location: name.length, length: attributeString.length - name.length))
                 self.name.attributedText = attributeString
            } else {
                self.name.text = name
            }
           
        }
        
    }
}
