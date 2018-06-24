//
//  TrackDeliveryCell.swift
//  PayBack
//
//  Created by Mohsin Surani on 06/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
class TrackDeliveryCell: UITableViewCell {

    @IBOutlet weak private var approvedImageView: UIImageView!
    @IBOutlet weak private var processImageView: UIImageView!
    @IBOutlet weak private var shipImageView: UIImageView!
    @IBOutlet weak private var deliverImageView: UIImageView!
    
    @IBOutlet weak private var processView: UIView!
    @IBOutlet weak private var shipView: UIView!
    @IBOutlet weak private var deliverView: UIView!
    let selectedBGColor = ColorConstant.primaryColorPink

    var sourceData: TrackDeliveryCellModel? {
        didSet {
            if let data = sourceData {
                 self.parseData(withStatus: data)
            }
        }
    }
    
    private func parseData(withStatus data: TrackDeliveryCellModel) {
        switch data.orderStatus {
        case OrderStatus.ORDER_APPROVED.rawValue?:
            self.progressStatus(isApproved: true, isProcessed: false, isShipped: false, isDelivered: false)
        case OrderStatus.ORDER_PROCESSING_COMPLETED.rawValue?:
            self.progressStatus(isApproved: true, isProcessed: true, isShipped: false, isDelivered: false)
        case OrderStatus.ORDER_SHIPPED.rawValue?:
            self.progressStatus(isApproved: true, isProcessed: true, isShipped: true, isDelivered: false)
        case OrderStatus.ORDER_DELIVERED.rawValue?:
            self.progressStatus(isApproved: true, isProcessed: true, isShipped: true, isDelivered: true)
        default:
            break
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        DispatchQueue.main.async { [weak self] in
//            if let strongSelf = self {
//                strongSelf.approvedImageView.layer.cornerRadius = strongSelf.approvedImageView.frame.height / 2
//                strongSelf.processImageView.layer.cornerRadius = strongSelf.approvedImageView.layer.cornerRadius
//                strongSelf.deliverImageView.layer.cornerRadius = strongSelf.approvedImageView.layer.cornerRadius
//                strongSelf.shipImageView.layer.cornerRadius = strongSelf.approvedImageView.layer.cornerRadius
//            }
//        }
    }

    private func progressStatus(isApproved: Bool, isProcessed: Bool, isShipped: Bool, isDelivered: Bool) {
        if isApproved {
            approvedImageView.image = #imageLiteral(resourceName: "trackorderselect")
        }
        
        if isProcessed {
            processView.backgroundColor = selectedBGColor
            processImageView.image = #imageLiteral(resourceName: "trackorderselect")
        }
        
        if isShipped {
            shipView.backgroundColor = selectedBGColor
            shipImageView.image = #imageLiteral(resourceName: "trackorderselect")
        }
        
        if isDelivered {
            deliverView.backgroundColor = selectedBGColor
            deliverImageView.image = #imageLiteral(resourceName: "trackorderselect")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        print(" TrackDeliveryCell deinit called")
    }
}

class TrackDeliveryCellModel: NSObject {
    var orderStatus: String?
    init?(statusMsg: String) {
        super.init()
          self.orderStatus = statusMsg
    }
}
