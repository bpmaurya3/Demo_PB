//
//  ShopClickTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/31/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

final internal class ShopClickTVCell: UITableViewCell {
    
    var cellTapClosure: (Int) -> Void = { _ in }

    fileprivate var dataSource: CollectionViewDataSource<PBShopClickCVCell, ShopClickCellViewModel>!

    var cellModel: [ShopClickCellViewModel] = [] {
        didSet {
            self.titleLabel.isHidden = cellModel.isEmpty ? true : false
            self.underLineView.isHidden = cellModel.isEmpty ? true : false
            self.viewAllButton.isHidden = cellModel.isEmpty ? true : false
            guard !cellModel.isEmpty else {
                return
            }
            
            self.dataSource = CollectionViewDataSource(cellIdentifier: Cells.shopClickCVCell, items: cellModel) {[unowned self] cell, vm in
                cell.shopClickCellViewModel = vm
                self.addCellLayer(cell: cell)
            }
            self.collectionView.dataSource = self.dataSource
            self.collectionView.reloadData()
        }
    }
    
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shop.Click.Earn"
        label.backgroundColor = .clear
        label.textColor = ColorConstant.rewardScreenTitleColor
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    fileprivate var underLineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .red
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: "PBShopClickCVCell", bundle: nil), forCellWithReuseIdentifier: "PBShopClickCVCell")
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
    
    private func setupViews() {
        selectionStyle = .none
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true

        addSubview(underLineView)
        underLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        underLineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        underLineView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        underLineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        addSubview(viewAllButton)
        viewAllButton.addTarget(self, action: .viewAllForShopClickTVCell, for: .touchUpInside)
        viewAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        viewAllButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        viewAllButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: viewAllButton.leadingAnchor, constant: -5).isActive = true
        addSubview(collectionView)
        
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -1).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 1).isActive = true

        collectionView.topAnchor.constraint(equalTo: viewAllButton.bottomAnchor, constant: 20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        addBorderToCollectionView()
    }
    deinit {
        print("ShopClickTVCell: deinit called")
    }
}

extension ShopClickTVCell {
    @objc func viewAllClicked() {
        print("View all clicked")
        let parantController = self.parentViewController as? EarnOnlinePartnersVC
        if let strongSelf = parantController, let vc = OnlinePartnersVC.storyboardInstance(storyBoardName: "Burn") as? OnlinePartnersVC {
            vc.landingType = .earnProduct
            strongSelf.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func addBorderToCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.layer.addBorderRect(color: .lightGray, thickness: 1)
        }
    }
    
    fileprivate func addCellLayer(cell: UICollectionViewCell) {
        cell.layer.addBorder(edge: .left, color: .lightGray, thickness: 1)
    }
}

extension ShopClickTVCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var commonWidth: CGFloat = collectionView.frame.height + 40
        let cellCount: CGFloat = CGFloat(cellModel.isEmpty ? 1 : cellModel.count)
        if (commonWidth * cellCount) < ScreenSize.SCREEN_WIDTH {
            commonWidth = ScreenSize.SCREEN_WIDTH / cellCount
        }
        
        return CGSize(width: commonWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cellTapClosure(indexPath.item)
    }
}
