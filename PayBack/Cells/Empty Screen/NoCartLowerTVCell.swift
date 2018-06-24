//
//  NoCartLowerTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/4/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class NoCartLowerTVCell: UITableViewCell {
    let cellID = "NoCartLowerCVCell"
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var showRecommendedButton: UIButton!
    
    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    fileprivate lazy var rewardsNWController: RewardCatalogueNetworkController = {
        return RewardCatalogueNetworkController()
    }()
    
    fileprivate var cellModel: [TopTrendCVCellModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = ColorConstant.collectionViewBGColor
        collectionView.register(UINib(nibName: "NoCartLowerCVCell", bundle: nil), forCellWithReuseIdentifier: cellID)
        showRecommendedButton.backgroundColor = ColorConstant.shopNowButtonBGColor
        showRecommendedButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)

        fetchRecommendedDeals()
    }
    
    @IBAction func showRecommendations(_ sender: Any) {
        if let vc = ProductListVC.storyboardInstance(storyBoardName: "Burn") as? ProductListVC {
            vc.productListRequestParams = ("", "recommended-deals", ProductCategory.none, .burnProduct, "Show Recommendations")
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension NoCartLowerTVCell {
    fileprivate func fetchRecommendedDeals() {
        rewardsNWController
            .onRecommendedDealSuccess(success: { [unowned self] (recommendedItems) in
                self.cellModel = recommendedItems
            })
            .onError(error: { (error) in
                print("\(error)")
            })
            .fetchRecommendedDeals(limit: "20")
    }
}

extension NoCartLowerTVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? NoCartLowerCVCell {
            cell.cellModel = cellModel[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
}

extension NoCartLowerTVCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2) - 30, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = BurnProductDetailVC.storyboardInstance(storyBoardName: "Burn") as? BurnProductDetailVC, let productID = cellModel[indexPath.row].productID, productID != "" {
                vc.productID = productID
                self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.parentViewController?.showErrorView(errorMsg: StringConstant.productDetailsMissing)
        }
    }
}
