//
//  MyOrderTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/5/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class MyOrderTVCell: UITableViewCell {
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var orderIdLabel: UILabel!
    @IBOutlet weak private var orderDescBGView: UIView!
    
    @IBOutlet weak private var trackButton: UIButton!
    @IBOutlet weak private var statusLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var imgView: UIImageView!
    @IBOutlet weak private var deliveredDateLabel: UILabel!
    
    var trackActionHandler: ((Int) -> Void )?

    var cellModel: MyOrderTVCellModel? {
        didSet {
            guard let cellModel = cellModel else {
                return
            }
            parseData(cellModel: cellModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        
        self.dateLabel.text = ""
        self.orderIdLabel.text = ""
        self.statusLabel.text = ""
        self.priceLabel.text = ""
        self.titleLabel.text = ""
        self.deliveredDateLabel.text = ""
    }
    
    private func setFontColors() {
        dateLabel.font = FontBook.Regular.of(size: 12)
        orderIdLabel.font = FontBook.Regular.of(size: 12)
        titleLabel.font = FontBook.Bold.of(size: 15)
        priceLabel.font = FontBook.Bold.of(size: 15)
        statusLabel.font = FontBook.Regular.of(size: 12)
        deliveredDateLabel.font = statusLabel.font
        trackButton.titleLabel?.font = FontBook.Regular.of(size: 11)
    }
    
    func setTrackButtonTag(tag: Int) {
        trackButton.tag = tag
    }
    
    private func parseData(cellModel: MyOrderTVCellModel) {
        
        if let date = cellModel.orderDate {
            self.dateLabel.text = Utilities.getDayMonthYear(date: date)
        }
        if let orderID = cellModel.orderId {
            self.orderIdLabel.text = "Order id: \(orderID)"
        }
        if let image = cellModel.image {
            self.imgView.image = image
        } else {
            self.imgView.image = #imageLiteral(resourceName: "placeholder")
        }
        if let title = cellModel.title {
            self.titleLabel.text = title
        }
        if let price = cellModel.price {
            self.priceLabel.text = "\(StringConstant.pointsSymbol) \(price)"
        }
        if let status = cellModel.orderStatus {
            self.statusLabel.text = status
            self.setStatusTextColor(withStatus: status)
        }
        if  let deliveredDate = cellModel.orderStatusDate, !deliveredDate.isEmpty {
            self.deliveredDateLabel.text = deliveredDate
            self.trackButton.isHidden = true
        }
    }
    
    internal func addBorderToCellSubviews() {
        layoutIfNeeded()
        DispatchQueue.main.async { [weak self] in
            self?.orderDescBGView.layer.addBorder(edge: .bottom, color: .lightGray, thickness: 1.0)
        }
        
    }
    
    @IBAction func trackOrder(_ sender: UIButton) {
        trackActionHandler?(sender.tag)
    }
}
extension MyOrderTVCell {
    fileprivate func setStatusTextColor(withStatus status: String) {
        switch status {
        case OrderStatus.ORDER_APPROVED.rawValue:
            self.trackButton.isHidden = false
            self.statusLabel.textColor = ColorConstant.productDetailsbuttonTextColor
            break
        case OrderStatus.ORDER_PROCESSING_COMPLETED.rawValue:
            self.trackButton.isHidden = false
            self.statusLabel.textColor = ColorConstant.productDetailsbuttonTextColor
            break
        case OrderStatus.ORDER_SHIPPED.rawValue:
            self.trackButton.isHidden = false
            self.statusLabel.textColor = ColorConstant.productDetailsbuttonTextColor
            break
        case OrderStatus.ORDER_REQUEST_SENT_TO_VENDOR.rawValue:
            self.trackButton.isHidden = false
            self.statusLabel.textColor = ColorConstant.productDetailsbuttonTextColor
            break
        case OrderStatus.ORDER_CANCELLED_BY_MEMBER.rawValue:
            self.trackButton.isHidden = true
            self.statusLabel.textColor = ColorConstant.productDetailsbuttonTextColor
            break
        case OrderStatus.ORDER_DELIVERED.rawValue:
            self.trackButton.isHidden = true
            self.statusLabel.textColor = ColorConstant.myTranscationPointColorGreen
            break
        default:
            break
            
        }
    }
}
