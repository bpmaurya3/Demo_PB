//
//  TopTrendTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/1/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

final internal class TopTrendTVCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var viewAllTapClosure: (() -> Void)?
    var toptrendTapClosure: ((String, String) -> Void)?
    var amplifiedItemIndexes = [Int]()
    
    var productType: ProductType = .none {
        didSet {
            switch productType {
            case .earnProduct:
                self.titleLabel.text = "Top Trends"
            case .burnProduct:
                self.titleLabel.text = "Recommended Deals"
            default:
                break
            }
        }
    }

    var cellModel: [TopTrendCVCellModel] = [] {
        didSet {
            self.titleLabel.isHidden = cellModel.isEmpty ? true : false
            self.underLineView.isHidden = cellModel.isEmpty ? true : false
            self.viewAllButton.isHidden = cellModel.isEmpty ? true : false
            guard !cellModel.isEmpty else {
                return
            }
            
            collectionView.backgroundColor = cellModel.isEmpty ? .clear : .lightGray
            collectionView.reloadData()
        }
    }
    
    fileprivate lazy var rewardsNWController: RewardCatalogueNetworkController = {
        return RewardCatalogueNetworkController()
    }()
    
    fileprivate lazy var shopOnlineNWController: ShopOnlineNetworkController = {
        return ShopOnlineNetworkController()
    }()
    
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Top Trends"
        label.textColor = ColorConstant.rewardScreenTitleColor
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontBook.Bold.of(size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    fileprivate var underLineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = ColorConstant.bottomLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate var viewAllButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.backgroundColor = ColorConstant.shopNowButtonBGColor
        button.setTitle("VIEW ALL", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellID")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: "PBTopTrendLargeCVCell", bundle: nil), forCellWithReuseIdentifier: "PBTopTrendLargeCVCell")
        collectionView.register(UINib(nibName: "PBTopTrendSmallCVCell", bundle: nil), forCellWithReuseIdentifier: "PBTopTrendSmallCVCell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        self.perform(.addCollectionViewLayerForTopTrend, with: nil, afterDelay: 0.05)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        amplifiedItemIndexes = TopProductCellPatternGenerater.oneByTwo(repeatingUpTo: 3)
        
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        
        addSubview(underLineView)
        underLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27).isActive = true
        underLineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        underLineView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        underLineView.heightAnchor.constraint(equalToConstant: 2.5).isActive = true
        
        addSubview(viewAllButton)
        viewAllButton.addTarget(self, action: .viewAllForTopTrendTVCell, for: .touchUpInside)
        viewAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        viewAllButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        viewAllButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: viewAllButton.leadingAnchor, constant: -5).isActive = true
        addSubview(collectionView)

        addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: underLineView.bottomAnchor, constant: 18).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    deinit {
        print("TopTrendTVCell: deinit called")
    }
}
extension TopTrendTVCell {
    @objc func viewAllClicked() {
        print("View all clicked")
        
        let productListRequestParams = productType == .earnProduct ? ("", "", ProductCategory.topTrend, productType, "Top Trend") : ("", "recommended-deals", ProductCategory.none, productType, "Recommended Deals")
        let parentController = self.parentViewController
        if let strongSelf = parentController, let vc = ProductListVC.storyboardInstance(storyBoardName: "Burn") as? ProductListVC {
            vc.productListRequestParams = productListRequestParams
            strongSelf.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addColectionViewLayer() {
        collectionView.layer.addBorder(edge: .top, color: .lightGray, thickness: 1)
        collectionView.layer.addBorder(edge: .bottom, color: .lightGray, thickness: 1)
        
    }
}

extension TopTrendTVCell {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch productType {
        case .earnProduct:
            let shouldAmplifyItem = amplifiedItemIndexes.contains(indexPath.item)
            if shouldAmplifyItem {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PBTopTrendLargeCVCell", for: indexPath) as? PBTopTrendLargeCVCell {
                    cell.backgroundColor = .white
                    cell.cellModel = cellModel[indexPath.item]
                    return cell
                }
            } else {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PBTopTrendSmallCVCell", for: indexPath) as? PBTopTrendSmallCVCell {
                    cell.backgroundColor = .white
                    cell.cellModel = cellModel[indexPath.item]
                    return cell
                }
            }
        case .burnProduct:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PBTopTrendLargeCVCell", for: indexPath) as? PBTopTrendLargeCVCell {
                cell.backgroundColor = .white
                cell.cellModel = cellModel[indexPath.item]
                return cell
            }
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let shouldAmplifyItem = amplifiedItemIndexes.contains(indexPath.item)
 
        let cellWidth = collectionView.frame.width / 2
        var cellHeight = (collectionView.frame.height - 1) / 2
        if shouldAmplifyItem {
            cellHeight += cellHeight
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let modelData = cellModel[indexPath.item]
        switch productType {
        case .earnProduct:
            guard modelData.itemType == "product" else {
                if let urlString = modelData.appDeepLink, let closure = toptrendTapClosure {
                    closure(urlString, modelData.partnerImage ?? "")
                }
                return
            }
            let parentController = self.parentViewController as? EarnOnlinePartnersVC
            if let strongSelf = parentController, let vc = EarnProductDetailsVC.storyboardInstance(storyBoardName: "Earn") as? EarnProductDetailsVC {
                guard let PID = modelData.productID, PID != "" else {
                    strongSelf.showErrorView(errorMsg: StringConstant.productDetailsMissing)
                    return
                }
                vc.productID = PID
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        case .burnProduct:
            let parentController = self.parentViewController as? RewardsCatalogueVC
            if let strongSelf = parentController, let vc = BurnProductDetailVC.storyboardInstance(storyBoardName: "Burn") as? BurnProductDetailVC {
                guard let PID = modelData.productID, PID != "" else {
                    strongSelf.showErrorView(errorMsg: StringConstant.productDetailsMissing)
                    return
                }
                vc.productID = PID
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
        
    }
}
