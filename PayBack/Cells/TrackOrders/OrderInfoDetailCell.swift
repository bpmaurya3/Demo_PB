//
//  OrderInfoDetailCell.swift
//  PayBack
//
//  Created by Mohsin Surani on 07/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class OrderInfoDetailCell: UITableViewCell {

    private lazy var infoLabel: DesignableLabel = {
        let infoLabel = DesignableLabel()
        infoLabel.backgroundColor = .white
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.numberOfLines = 0
        
        let commonPadding: CGFloat = 25.0
        infoLabel.leftInset = commonPadding
        infoLabel.rightInset = commonPadding
        infoLabel.topInset = commonPadding
        infoLabel.bottomInset = commonPadding
        return infoLabel
    }()
    var sourceData: OrderInfoDetailCellModel? {
        didSet {
            guard let sourceData = sourceData else {
                return
            }
            self.parseData(withDetailInfo: sourceData)
        }
    }
    func parseData(withDetailInfo data: OrderInfoDetailCellModel) {
        if data.isShippingAddress {
            if let title = data.titleName, let value = data.value {
                infoLabel.attributedText = .getAttributedStringForShippingAddress(name: title, changingValues: value)
            }
        } else {
             if let title = data.titleName, let value = data.value {
                infoLabel.attributedText = .getAttributedStringForInfo(staticText: title, changingValues: (title == "Points earned") ? "\(value) \(StringConstant.pointsSymbol)" : "\(value)")
            }
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
        self.backgroundColor = UIColor(red: 244 / 255, green: 249 / 255, blue: 253 / 255, alpha: 1)
        self.selectionStyle = .none
        
        DispatchQueue.main.async { [weak self] in
            self?.infoLabel.layer.addBorder(edge: .left, color: .lightGray, thickness: 1)
            self?.infoLabel.layer.addBorder(edge: .right, color: .lightGray, thickness: 1)
            self?.infoLabel.layer.addBorder(edge: .bottom, color: .lightGray, thickness: 1)
        }
        
        self.addSubview(infoLabel)
        
        infoLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6).isActive = true
        infoLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        infoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        print(" TrackItemCellc deinit called")
    }
}

class OrderInfoDetailCellModel: NSObject {
        var titleName: String?
        var value: String?
        var isShippingAddress: Bool = false
        
    init?(titleName: String, value: String, isShippingAddress: Bool) {
            super.init()
            self.titleName = titleName
            self.value = value
            self.isShippingAddress = isShippingAddress
        }
}
