//
//  MyTransactionTVCell.swift
//  PayBack
//
//  Created by Dinakaran M on 21/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
class MyTransactionTVCell: UITableViewCell {
    @IBOutlet weak private var points: UILabel!
    @IBOutlet weak private var type: UILabel!
    @IBOutlet weak private var partner: UILabel!
    @IBOutlet weak private var date: UILabel!
    @IBOutlet weak private var transactionID: UILabel!
    @IBOutlet weak private var pointTitle: UILabel!
    @IBOutlet weak private var typeTitle: UILabel!
    @IBOutlet weak private var partnerTitle: UILabel!
    @IBOutlet weak private var dateTitle: UILabel!
    @IBOutlet weak private var transactionlabel: UILabel!
    @IBOutlet weak private var borderview: UIView!
    
    var sourceData: MyTransactionTVCellModel? {
        didSet {
            guard let sourceData = sourceData else {
                return
            }
            self.parseData(forMyTrasactionData: sourceData)
        }
    }
    func parseData(forMyTrasactionData data: MyTransactionTVCellModel) {
        if let tID = data.tID {
            self.transactionID.text = tID
        }
        if let date = data.date {
            self.date.text = date
        }
        if let partner = data.partner {
            self.partner.text = partner
        }
        if let type = data.type {
            self.type.text = type
        }
        if let points = data.points {
            self.points.text = "ºP \(points)"
            self.points.textColor = data.type == "BURN" ? ColorConstant.myTranscationPointColorRed : ColorConstant.myTranscationPointColorGreen
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.borderview.layer.borderWidth = 1
        self.borderview.layer.borderColor = UIColor.gray.cgColor
            //UIColor(red: 228 / 255, green: 248 / 255, blue: 253 / 255, alpha: 1.0).cgColor
        self.transactionlabel.font = FontBook.Bold.of(size: 12)
        self.transactionlabel.textColor = ColorConstant.textColorPointTitle
        self.transactionID.font = FontBook.Regular.of(size: 12)
        self.transactionID.textColor = ColorConstant.myTransactionIDTextColor
        
        self.points.font = FontBook.Bold.of(size: 12)
        self.points.textColor = ColorConstant.myTranscationPointColorGreen
        self.type.font = FontBook.Regular.of(size: 12)
        self.partner.font = FontBook.Regular.of(size: 12)
        self.date.font = FontBook.Bold.of(size: 12)
        self.date.textColor = ColorConstant.backgroudColorBlue
        self.type.textColor = ColorConstant.myTransactionIDTextColor
        self.partner.textColor = ColorConstant.myTransactionIDTextColor
        
        self.pointTitle.font = FontBook.Bold.of(size: 15)
        self.pointTitle.textColor = ColorConstant.textColorPointTitle
        self.dateTitle.font = FontBook.Bold.of(size: 15)
        self.dateTitle.textColor = ColorConstant.textColorPointTitle
        self.partnerTitle.font = FontBook.Bold.of(size: 15)
        self.partnerTitle.textColor = ColorConstant.textColorPointTitle
        self.typeTitle.font = FontBook.Bold.of(size: 15)
        self.typeTitle.textColor = ColorConstant.textColorPointTitle
        
    }
    
    func setBackgroundColor(atIndex index: Int) {
        if index % 2 == 0 {
            borderview?.backgroundColor = UIColor(red: 228 / 255, green: 248 / 255, blue: 253 / 255, alpha: 1.0)
        } else {
            borderview?.backgroundColor = .white
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    deinit {
        print("Denit - MyTransactionTVCell ")
    }
}

class MyTransactionTVCellModel: NSObject {
    var tID: String?
    var date: String?
    var partner: String?
    var points: String?
    var type: String?
    internal init(tID: String? = nil, date: String? = nil,
                  partner: String? = nil, points: String? = nil, type: String? = nil) {
        self.tID = tID
        self.date = date
        self.partner = partner
        self.points = points
        self.type = type
    }
    override init() {
        super.init()
    }
}
