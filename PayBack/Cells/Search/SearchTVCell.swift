//
//  SearchTVCell.swift
//  PayBack
//
//  Created by Dinakaran M on 21/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class SearchTVCell: UITableViewCell {

    @IBOutlet weak fileprivate var name: UILabel!
    @IBOutlet weak fileprivate var footerView: UIView!
    @IBOutlet weak fileprivate var dividerView: UIView!
    var sourceData: SearchTVCellModel? {
        didSet {
            guard let sourceData = sourceData else {
                return
            }
            self.parseData(forSearchData: sourceData)
        }
    }
    func parseData(forSearchData data: SearchTVCellModel) {
        if let name = data.itemName {
            self.name.text = name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.name.textColor = ColorConstant.textColorPointTitle
        self.name.font = FontBook.Regular.of(size: 15.0)
        
        self.dividerView.backgroundColor = ColorConstant.searchListDeviderColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    deinit {
        print("Denit - SearchTVCell ")
    }
}

extension SearchTVCell {
    @discardableResult
    func display(isFooterViewDisplay shouldDisplay: Bool) -> Self {
        self.footerView.isHidden = shouldDisplay
        
        return self
    }
    
    @discardableResult
    func display(isdividerViewDisplay shouldDisplay: Bool) -> Self {
        self.dividerView.isHidden = shouldDisplay
        
        return self
    }
}
