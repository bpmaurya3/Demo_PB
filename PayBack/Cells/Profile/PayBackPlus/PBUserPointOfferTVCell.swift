//
//  PBUserPointOfferTVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 22/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBUserPointOfferTVCell: UITableViewCell {
    
    lazy var userOfferTableView: PBUserOffersTableView = {
        let view = PBUserOffersTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupOfferView()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupOfferView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print(" PBUserPointOfferTVCell deinit called")
    }
    
    private func setupOfferView() {
        backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 250 / 255, alpha: 1.0)
        selectionStyle = .none
        
        self.addSubview(self.userOfferTableView)
        self.addConstraintsWithFormat("H:|[v0]|", views: self.userOfferTableView)
        self.addConstraintsWithFormat("V:|[v0]|", views: self.userOfferTableView)
    }
}
