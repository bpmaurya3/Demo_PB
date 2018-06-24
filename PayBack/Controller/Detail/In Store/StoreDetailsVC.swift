//
//  StoreDetailsVC.swift
//  PayBack
//
//  Created by Dinakaran M on 13/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class StoreDetailsVC: BaseViewController {
    fileprivate let cellIdentifier = "StoreDetailsTVCell"
    
    @IBOutlet weak private var tableview: UITableView!
    @IBOutlet weak private var storeImage: UIImageView!
    @IBOutlet weak private var storeLogo: UIImageView!
    @IBOutlet weak private var mapIcon: UIImageView!
    @IBOutlet weak private var storeAddress: UILabel!
    @IBOutlet weak private var storeName: UILabel!
    @IBOutlet weak private var transperantView: UIView!
    @IBOutlet weak private var navView: DesignableNav!
    @IBOutlet weak private var shareofferbutton: UIButton!
    var sourceData : [Any] = []
    @IBAction func shareOfferButtonAction(_ sender: Any) {
        print("Clicked Share Offer Button")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.storeName.textColor = ColorConstant.textColorWhite
        self.storeName.font = FontBook.Bold.of(size: 17.5)
        
        self.storeAddress.textColor = ColorConstant.textColorWhite
        self.storeAddress.font = FontBook.Regular.of(size: 12.0)

        self.shareofferbutton.titleLabel?.textColor = ColorConstant.textColorWhite
        self.shareofferbutton.backgroundColor = ColorConstant.buttonBackgroundColorPink
        self.shareofferbutton.titleLabel?.font = FontBook.Regular.of(size: 17.5)

        let data1 = StoreDetailsTVCellModel(offerName: "PAYBACK Offer", offerMsg: "In the Indian market where there is more focus by individual companies to create their own loyalty programs, the multitude of partners and the wide categories that they operate ")
         let data2 = StoreDetailsTVCellModel(offerName: "Special Offer", offerMsg: "In the Indian market where there is more focus by individual companies to create their own loyalty.")
        sourceData.append(data1)
        sourceData.append(data2)
        
        self.storeName.text = "Chaayos"
        self.storeAddress.text = "Building No:5, DLF cuber city, Near Indian Oil Petrol Pump"
        self.storeLogo.image = #imageLiteral(resourceName: "camera")
        self.storeImage.image = #imageLiteral(resourceName: "demo2")
        self.mapIcon.image = UIImage(named: "locationwhite")
        navView.title = "Chaayos"
        
        transperantView.backgroundColor = UIColor(red: 15 / 255, green: 92 / 255, blue: 167 / 255, alpha: 1).withAlphaComponent(0.7)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        print("Deinit - StoreDetailsVC")
    }
}

extension StoreDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
extension StoreDetailsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StoreDetailsTVCell
        cell?.sourceData = sourceData[indexPath.row] as? StoreDetailsTVCellModel
        return cell!
    }
}
