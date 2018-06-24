//
//  NoDataFoundTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 3/21/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

class NoDataFoundTVCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        print("CarouselTVCell: deinit called")
    }
    private func setup() {
        textLabel?.text = StringConstant.No_Data_Found
        textLabel?.textAlignment = .center
        textLabel?.textColor = ColorConstant.navigationViewColor
        backgroundColor = .clear
        selectionStyle = .none
    }
}
