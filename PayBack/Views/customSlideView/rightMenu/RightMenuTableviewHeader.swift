//
//  RightMenuTableviewHeader.swift
//  PayBack
//
//  Created by Dinakaran M on 01/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class RightMenuTableviewHeader: UITableViewHeaderFooterView {
    let dividerView = UIView()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = ColorConstant.leftRightMenuBgColor

        let marginGuide = contentView.layoutMarginsGuide
        // Divider View
        contentView.addSubview(dividerView)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        dividerView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerView.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor).isActive = true
        dividerView.backgroundColor = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha:1)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
