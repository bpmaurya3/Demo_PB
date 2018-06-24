//
//  HotDealsTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/14/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

final internal class HotDealsTVCell: UITableViewCell {
    fileprivate var dataSource: CollectionViewDataSource<PBTopTrendLargeCVCell, TopTrendCVCellModel>!

    var cellModel: [TopTrendCVCellModel] = [] {
        didSet {
            self.titleLabel.isHidden = cellModel.isEmpty ? true : false
            self.underLineView.isHidden = cellModel.isEmpty ? true : false
            self.viewAllButton.isHidden = cellModel.isEmpty ? true : false
            
            self.dataSource = CollectionViewDataSource(cellIdentifier: Cells.topTrendLargeCVCell, items: cellModel) { [unowned self] cell, vm in
                self.addColectionViewCellLayer(cell: cell)
                cell.cellModel = vm
            }
            self.collectionView.dataSource = self.dataSource
            self.collectionView.reloadData()
        }
    }
    
    fileprivate lazy var rewardsNWController: RewardCatalogueNetworkController = {
        return RewardCatalogueNetworkController()
    }()
    
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hot Deals"
        label.font = FontBook.Bold.of(size: 18)
        label.textColor = ColorConstant.rewardScreenTitleColor
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
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
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.register(UINib(nibName: Cells.topTrendLargeCVCell, bundle: nil), forCellWithReuseIdentifier: Cells.topTrendLargeCVCell)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("HotDealsTVCell: deinit called")
    }
    
    private func setupViews() {
        self.selectionStyle = .none

        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        
        addSubview(underLineView)
        underLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        underLineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13).isActive = true
        underLineView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        underLineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        addSubview(viewAllButton)
        viewAllButton.addTarget(self, action: #selector(viewAllClicked), for: .touchUpInside)
        viewAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        viewAllButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        viewAllButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: viewAllButton.leadingAnchor, constant: -5).isActive = true
        addSubview(collectionView)
        
        addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: viewAllButton.bottomAnchor, constant: 26).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
}
extension HotDealsTVCell {
    @objc func viewAllClicked() {
        print("View all clicked")
        if let strongSelf = self.parentViewController as? RewardsCatalogueVC, let vc = ProductListVC.storyboardInstance(storyBoardName: "Burn") as? ProductListVC {
            vc.productListRequestParams = ("", "gifts", ProductCategory.none, ProductType.burnProduct, "Hot Deals")
            strongSelf.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func addColectionViewCellLayer(cell: UICollectionViewCell) {
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1.0
    }
}

extension HotDealsTVCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height - 25, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = cellModel[indexPath.item]
        if let strongSelf = self.parentViewController as? RewardsCatalogueVC, let vc = BurnProductDetailVC.storyboardInstance(storyBoardName: "Burn") as? BurnProductDetailVC {
            guard let productID = model.productID, productID != "" else {
                strongSelf.showErrorView(errorMsg: StringConstant.productDetailsMissing)
                return
            }
            vc.productID = productID
            strongSelf.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
