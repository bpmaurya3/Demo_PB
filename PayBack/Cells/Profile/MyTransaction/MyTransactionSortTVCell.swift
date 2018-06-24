//
//  MyTransactionSortTVCell.swift
//  PayBack
//
//  Created by Dinakaran M on 26/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class MyTransactionSortTVCell: UITableViewCell {

    @IBOutlet weak private var name: UILabel!
    @IBOutlet weak private var partnerlist: UILabel!
    
    var sourceData: MyTransactionSortTVCellModel? {
        didSet {
            guard let sourceData = sourceData else {
                return
            }
            self.parseData(forSortListData: sourceData)
        }
    }
    func parseData(forSortListData data: MyTransactionSortTVCellModel) {
        if let name = data.name {
            self.name.text = name
        }
        if !data.partnerslist.isEmpty {
            let lists = data.partnerslist
            let selectedItems: [SearchFilterTVCellModel] = lists.filter({ (model) -> Bool in
                if model.state {
                    return true
                } else {
                    return false
                }
            })
            let arrayMap: Array = selectedItems.map {
                $0.partnerName!
            }
            let joinedString: String = arrayMap.joined(separator: ",")
            self.partnerlist.text = joinedString
        } else {
             self.partnerlist.text = ""
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.name.font = FontBook.Bold.ofTVCellTitleSize()
        self.name.textColor = ColorConstant.textColorBlack
        
        self.partnerlist.font = FontBook.Regular.ofTVCellTitleSize()
        self.partnerlist.textColor = ColorConstant.textColorPink
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    deinit {
        print("Denit - MyTransactionSortTVCell ")
    }
}

class MyTransactionSortTVCellModel: NSObject {
  
    var name: String?
    var partnerslist: [SearchFilterTVCellModel] = [SearchFilterTVCellModel]()
    
    internal init(name: String? = nil, partnerList: [SearchFilterTVCellModel]) {
        self.name = name
        self.partnerslist = partnerList
    }
    override init() {
        super.init()
    }
    
}
