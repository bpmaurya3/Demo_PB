//
//  PBUserOffersTableView.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 22/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBUserOffersTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    var sourceData: [PBUserOffersTVCellModel] = [] {
        didSet {
            self.mOfferTableView.reloadData()
        }
    }
    internal lazy var mOfferTableView: UITableView = {
        let mOfferTableView = UITableView(frame: .zero, style: .plain)
        mOfferTableView.backgroundColor = UIColor.clear
        mOfferTableView.delegate = self
        mOfferTableView.dataSource = self
        mOfferTableView.separatorStyle = .none
        mOfferTableView.register(UINib(nibName: Cells.userOfferTVCellID, bundle: nil), forCellReuseIdentifier: Cells.userOfferTVCellID)
        mOfferTableView.showsVerticalScrollIndicator = false
        mOfferTableView.backgroundColor = .clear
        mOfferTableView.isScrollEnabled = false
        return mOfferTableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("PBUserOffersTableView deinit called")
    }
    
    private func setup() {
        self.addSubview(mOfferTableView)
        
        let data1 = PBUserOffersTVCellModel(icon: UIImage(named: "bonuspoints")!, title: "Bonus Points", descreption: "2 Monthly transaction above Rs. 500 required to unlock 3000 Bonus Points", progresImg: UIImage(named: "bonuspoints")!)
         let data2 = PBUserOffersTVCellModel(icon: UIImage(named: "offeractivated")!, title: "Offer Activated", descreption: "Offers activated by you", progresImg: UIImage(named: "offeractivated")!)
         let data3 = PBUserOffersTVCellModel(icon: UIImage(named: "bonusbonaza")!, title: "Bonus Bonaza", descreption: "4 Monthly transaction above Rs. 500 required to quality for the Bonus Points.", progresImg: UIImage(named: "bonusbonaza")!)
        self.sourceData.append(data1)
        self.sourceData.append(data2)
        self.sourceData.append(data3)
        self.addConstraintsWithFormat("H:|[v0]|", views: mOfferTableView)
        self.addConstraintsWithFormat("V:|[v0]|", views: mOfferTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.userOfferTVCellID, for: indexPath) as? PBUserOffersTVCell {
            cell.sourceData = self.sourceData[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
