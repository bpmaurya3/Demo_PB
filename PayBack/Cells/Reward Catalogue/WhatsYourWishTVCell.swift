//
//  WhatsYourWishTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/14/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
import UIKit

final internal class WhatsYourWishTVCell: UITableViewCell {
    fileprivate var dataSource: CollectionViewDataSource<PBShopClickCVCell, ShopClickCellViewModel>!
    
    var cellModel: [ShopClickCellViewModel] = [] {
        didSet {
            self.titleLabel.isHidden = cellModel.isEmpty ? true : false
            self.underLineView.isHidden = cellModel.isEmpty ? true : false
            
            self.dataSource = CollectionViewDataSource(cellIdentifier: Cells.shopClickCVCell, items: cellModel) { cell, vm in
                cell.backgroundColor = .white
                cell.shopClickCellViewModel = vm
            }
            self.collectionView.dataSource = self.dataSource
            self.dataSource.borderNeed = false
            collectionView.reloadData()
        }
    }
    
    fileprivate lazy var rewardsNWController: RewardCatalogueNetworkController = {
        return RewardCatalogueNetworkController()
    }()
    
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What's your wish?"
        label.textColor = ColorConstant.rewardScreenTitleColor
        label.font = FontBook.Bold.of(size: 18)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose from the rewards listed below and we will help you fulfill it."
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = FontBook.Regular.of(size: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var underLineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = ColorConstant.bottomLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: Cells.shopClickCVCell, bundle: nil), forCellWithReuseIdentifier: Cells.shopClickCVCell)
        collectionView.showsHorizontalScrollIndicator = false
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
        print("WhatsYourWishTVCell: deinit called")
    }
    
    private func setupViews() {
        
        self.selectionStyle = .none
        addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true//15
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        
        addSubview(underLineView)
        underLineView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true//15
        underLineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3).isActive = true
        underLineView.widthAnchor.constraint(equalToConstant: 38).isActive = true
        underLineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: underLineView.bottomAnchor, constant: 11).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -1).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 1).isActive = true
        collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 11).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        addBorderToCollectionView()
    }
}
extension WhatsYourWishTVCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var commonWidth: CGFloat = collectionView.frame.height + 40
        let cellCount: CGFloat = CGFloat(cellModel.isEmpty ? 1 : cellModel.count)
        if (commonWidth * cellCount) < ScreenSize.SCREEN_WIDTH {
            commonWidth = ScreenSize.SCREEN_WIDTH / cellCount
        }
        
        return CGSize(width: commonWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = cellModel[indexPath.item]
        if let categoryPath = model.id, let strongSelf = self.parentViewController, let vc = ProductListVC.storyboardInstance(storyBoardName: "Burn") as? ProductListVC {
            vc.productListRequestParams = ("", categoryPath, ProductCategory.none, .burnProduct, model.title ?? "")
            strongSelf.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension WhatsYourWishTVCell {
    
    fileprivate func addBorderToCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.layer.addBorderRect(color: .lightGray, thickness: 1)
        }
    }
}
