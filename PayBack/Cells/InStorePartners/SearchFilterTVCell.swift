//
//  SearchFilterTVCell.swift
//  PayBack
//
//  Created by Dinakaran M on 15/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class SearchFilterTVCell: UITableViewCell {
    typealias UpdateStatusClosure = ((Int, Bool) -> Void)
    var updateSelectedState: UpdateStatusClosure = { _, _  in }
    @IBAction func optionButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
            updateSelectedState(sender.tag, sender.isSelected)
    }
    @IBOutlet weak fileprivate var optionButton: UIButton!
    @IBOutlet weak private var itemName: UILabel!
    
    var subFilterItems: SearchFilterTVCellModel? {
        didSet {
            guard let subFilterItems = subFilterItems else {
                return
            }
            self.parseData(forSubFilterdata: subFilterItems)
        }
    }
    func parseData(forSubFilterdata data: SearchFilterTVCellModel) {
        if let itemName = data.partnerName {
            self.itemName.text = itemName
        }
        self.optionButton.isSelected = data.state
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.itemName.textColor = ColorConstant.textColorPointTitle
        self.itemName.font = FontBook.Bold.of(size: 12.0)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    deinit {
        print("Deint - SearchFilterTVCell")
    }
}

extension SearchFilterTVCell {
    @discardableResult
    func updateSeletedState(closure: @escaping UpdateStatusClosure) -> Self {
        updateSelectedState = closure
        return self
    }
    
    @discardableResult
    func set(optionButtonTag tag: Int) -> Self {
        self.optionButton.tag = tag
        
        return self
    }
}

class SearchFilterTVCellModel: NSObject {
    var partnerName: String?
    var partnerId: String?
    var state: Bool = false
    var id: Int = 0
    internal init(partnerName: String? = nil, partnerId: String? = nil, isEnabled: Bool, id: Int) {
        self.partnerName = partnerName
        self.partnerId = partnerId
        self.state = isEnabled
        self.id = id
    }
    override init() {
        super.init()
    }
}
