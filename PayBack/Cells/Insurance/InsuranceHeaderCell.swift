//
//  InsuranceHeaderCell.swift
//  PayBack
//
//  Created by Valtech Macmini on 13/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class InsuranceHeaderCell: UITableViewCell {

    @IBOutlet weak private var segmentCollectionView: UICollectionView!
    
    let insuranceNwController = ExploreNWController()
    
    var collectionActionHandler: ((ShopClickCellViewModel, Int) -> Void )?
    
    var cellModel: [ShopClickCellViewModel] = [] {
        didSet {
            segmentCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.segmentCollectionView.register(UINib(nibName: "PBShopClickCVCell", bundle: nil), forCellWithReuseIdentifier: "PBShopClickCVCell")
        //mockInsuranceTypeClick()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    deinit {
        print(" InsuranceHeaderCell deinit called")
    }
}

extension InsuranceHeaderCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PBShopClickCVCell", for: indexPath) as? PBShopClickCVCell {
            cell.backgroundColor = .white
            cell.shopOrInsurance = .shop
            cell.shopClickCellViewModel = cellModel[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
}

extension InsuranceHeaderCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        var commonWidth = ScreenSize.SCREEN_WIDTH / 3
        let cellCount: CGFloat = CGFloat((cellModel.isEmpty) ? 1 : cellModel.count)
        if (commonWidth * cellCount) < ScreenSize.SCREEN_WIDTH {
            commonWidth = ScreenSize.SCREEN_WIDTH
        }
        return CGSize(width: commonWidth, height: collectionView.frame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionActionHandler?(cellModel[indexPath.item], indexPath.item)
    }
}
