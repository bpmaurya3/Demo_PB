//
//  LeftMenuCustomCell.swift
//  PayBack
//
//  Created by Dinakaran M on 31/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class LeftMenuCustomCell: UITableViewCell {
    @IBOutlet weak fileprivate var leadingContainerCell: NSLayoutConstraint!
    @IBOutlet weak fileprivate var icon: UIImageView!
    @IBOutlet weak fileprivate var name: UILabel!
    
    var cellModel: Item? {
        didSet {
            self.parseData(withItem: cellModel!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.name.textColor = ColorConstant.leftMenuSubTitleTextColor
        self.name.font = FontBook.Regular.of(size: 12.0)
    }
    
    private func parseData(withItem item: Item) {
        if let iconName = item.icon {
            self.icon.image = UIImage(named: iconName)
        }
        if let name = item.name {
            self.name.text = name
        }
    }
}

extension LeftMenuCustomCell {
    @discardableResult
    func update(leadingConstraint constant: CGFloat) -> Self {
        self.leadingContainerCell.constant = constant
        
        return self
    }
}
