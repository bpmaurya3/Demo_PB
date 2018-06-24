//
//  OrderPlacedInfoCell.swift
//  PayBack
//
//  Created by Mohsin Surani on 07/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class OrderPlacedInfoCell: UITableViewCell {
    
    private lazy var orderPlacedLabel: UILabel = {
        let orderPlacedLabel = UILabel()
        orderPlacedLabel.textColor = UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
        orderPlacedLabel.textAlignment = .left
        orderPlacedLabel.translatesAutoresizingMaskIntoConstraints = false
        orderPlacedLabel.text = "Order placed"
        return orderPlacedLabel
    }()
    
    private lazy var orderPlacedDate: UILabel = {
        let orderPlacedDate = UILabel()
        orderPlacedDate.textColor = UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
        orderPlacedDate.text = ""
        orderPlacedDate.textAlignment = .left
        orderPlacedDate.translatesAutoresizingMaskIntoConstraints = false
        return orderPlacedDate
    }()
    
    private lazy var itemCodeLabel: UILabel = {
        let itemCodeLabel = UILabel()
        itemCodeLabel.textColor = UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
        itemCodeLabel.text = ""
        itemCodeLabel.textAlignment = .right
        itemCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        return itemCodeLabel
    }()
    
    private lazy var itemQtyLabel: UILabel = {
        let itemQtyLabel = UILabel()
        itemQtyLabel.textColor = UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
        itemQtyLabel.text = ""
        itemQtyLabel.textAlignment = .right
        itemQtyLabel.translatesAutoresizingMaskIntoConstraints = false
        return itemQtyLabel
    }()
    
    var cellViewModel: TrackItemInfoCellModel? {
        didSet {
            self.configureCell()
        }
    }
    
    private func configureCell() {
        if let itemDate = cellViewModel?.itemDate {
            orderPlacedDate.text = Utilities.getDayMonthYear(date: itemDate)
        }
        if let code = cellViewModel?.itemCode {
            itemCodeLabel.text = "Item Code: \(code)"
        }
        if let qty = cellViewModel?.itemQty {
            itemQtyLabel.text = "Qty: \(qty)"
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        self.selectionStyle = .none
        
        self.addSubview(orderPlacedLabel)
        self.addSubview(orderPlacedDate)
        self.addSubview(itemCodeLabel)
        self.addSubview(itemQtyLabel)
        
        let commonSpace: CGFloat = 20.0
        
        orderPlacedLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: commonSpace).isActive = true
        orderPlacedLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: commonSpace).isActive = true
        
        orderPlacedDate.leftAnchor.constraint(equalTo: self.leftAnchor, constant: commonSpace).isActive = true
        orderPlacedDate.topAnchor.constraint(equalTo: orderPlacedLabel.bottomAnchor, constant: 5).isActive = true
        orderPlacedDate.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -commonSpace).isActive = true
        
        itemCodeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -commonSpace).isActive = true
        itemCodeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: commonSpace).isActive = true
        
        itemQtyLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -commonSpace).isActive = true
        itemQtyLabel.topAnchor.constraint(equalTo: itemCodeLabel.bottomAnchor, constant: 5).isActive = true
        itemQtyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -commonSpace).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    deinit {
        print("OrderPlacedInfoCell deinit called")
    }
}

class TrackItemInfoCellModel: NSObject {
    var itemDate: String?
    var itemCode: String?
    var itemQty: String?
    
    init?(itemDate: String, itemCode: String, itemQty: String) {
        super.init()
        
        self.itemDate = itemDate
        self.itemCode = itemCode
        self.itemQty = itemQty
    }
}
