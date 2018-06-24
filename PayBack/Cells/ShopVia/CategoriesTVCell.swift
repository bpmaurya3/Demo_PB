//
//  CategoriesTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/1/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

final internal class CategoriesTVCell: UITableViewCell {
    fileprivate var dataSource: CollectionViewDataSource<PBShopClickCVCell, ShopClickCellViewModel>!
    fileprivate var UpdatePartnerSiteClosure: ((Int) -> Void) = { _ in }
    @discardableResult
    func selectedPartnerSite(closure: @escaping ((Int) -> Void)) -> Self {
        self.UpdatePartnerSiteClosure = closure
        return self
    }
    
    var cellModel: [ShopClickCellViewModel] = [] {
        didSet {
            self.titleLabel.isHidden = cellModel.isEmpty ? true : false
            self.underLineView.isHidden = cellModel.isEmpty ? true : false
            guard !cellModel.isEmpty else {
                return
            }
            
            self.dataSource = CollectionViewDataSource(cellIdentifier: Cells.shopClickCVCell, items: cellModel) { [unowned self] cell, vm in
                cell.shopOrInsurance = self.categoryOrInsurance
                cell.shopClickCellViewModel = vm
            }
            self.collectionView.dataSource = self.dataSource
            collectionView.reloadData()
        }
    }
    
    var categoryOrInsurance: ShopOrInsuranceType = .shop {
        didSet {
            setupViews()
        }
    }
    
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = ColorConstant.rewardScreenTitleColor
        label.font = UIFont.boldSystemFont(ofSize: 20)
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
        collectionView.register(UINib(nibName: "PBShopClickCVCell", bundle: nil), forCellWithReuseIdentifier: "PBShopClickCVCell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private func setupViews() {
        selectionStyle = .none
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 29.5).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true

        addSubview(underLineView)
        underLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 29.5).isActive = true
        underLineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.5).isActive = true
        underLineView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        underLineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -1).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 1).isActive = true
        collectionView.topAnchor.constraint(equalTo: underLineView.bottomAnchor, constant: 15.5).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        addBorderToCollectionView()
        
        switch categoryOrInsurance {
        case .insurance:
            titleLabel.text = "Our Partners"
            titleLabel.font = FontBook.Regular.of(size: 17.5)
            titleLabel.textColor = ColorConstant.insurancePartnerTitleColor
        default:
            titleLabel.text = "Categories"
        }
    }
    
    deinit {
        print("CategoriesTVCell: deinit called")
    }
}
extension CategoriesTVCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var commonWidth: CGFloat = collectionView.frame.height + 40
        let cellCount: CGFloat = CGFloat(cellModel.isEmpty ? 1 : cellModel.count)
        if (commonWidth * cellCount) < ScreenSize.SCREEN_WIDTH {
            commonWidth = ScreenSize.SCREEN_WIDTH / cellCount
        }
        
        return CGSize(width: commonWidth, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if categoryOrInsurance == .insurance {
            self.UpdatePartnerSiteClosure(indexPath.item)
        } else {
            let parantController = self.parentViewController
            if let strongSelf = parantController, let vc = ProductListVC.storyboardInstance(storyBoardName: "Burn") as? ProductListVC {
                let modelData = cellModel[indexPath.item]
                vc.productListRequestParams = ("", modelData.id ?? "", ProductCategory.shopOnlineCategory, ProductType.earnProduct, modelData.title ?? "")
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension CategoriesTVCell {
    
    fileprivate func addBorderToCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.layer.addBorderRect(color: ColorConstant.collectionViewBorderColor, thickness: 1)
        }
    }
}
