//
//  ShowCaseCategoryTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/1/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

final internal class ShowCaseCategoryTVCell: UITableViewCell {
    fileprivate var dataSource: CollectionViewDataSource<ShowCaseCategoryCVCell, ShowCaseCategoryCellVM>!   

    var cellModel: [ShowCaseCategoryCellVM] = [] {
        didSet {
            self.titleLabel.isHidden = cellModel.isEmpty ? true : false
            self.underLineView.isHidden = cellModel.isEmpty ? true : false
            self.viewAllButton.isHidden = cellModel.isEmpty ? true : false
            guard !cellModel.isEmpty else {
                return
            }
            
            self.dataSource = CollectionViewDataSource(cellIdentifier: Cells.showCaseCategoryCVCell, items: cellModel) { [unowned self] cell, vm in
                self.addColectionViewCellLayer(cell: cell)
                cell.bestFashionCellViewModel = vm
            }
            self.collectionView.dataSource = self.dataSource
            self.collectionView.reloadData()
        }
    }
    
    var showCaseCategory: ShowCaseCategory.ShowCaseCategories? {
        didSet {
            titleLabel.text = showCaseCategory?.categoryName
        }
    }
    
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Electronics and Appliances"
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
        collectionView.register(UINib(nibName: Cells.showCaseCategoryCVCell, bundle: nil), forCellWithReuseIdentifier: Cells.showCaseCategoryCVCell)
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
        viewAllButton.addTarget(self, action: .viewAllForShowCaseCategoryTVCell, for: .touchUpInside)
        viewAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        viewAllButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        viewAllButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: viewAllButton.leadingAnchor, constant: -5).isActive = true
        
        addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: viewAllButton.bottomAnchor, constant: 20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
    deinit {
        print("ShowCaseCategoryTVCell: deinit called")
    }
}
extension ShowCaseCategoryTVCell {
    @objc func viewAllClicked() {
        print("View all clicked")
        let parentController = self.parentViewController
        if let strongSelf = parentController, let vc = ProductListVC.storyboardInstance(storyBoardName: "Burn") as? ProductListVC {
                vc.productListRequestParams = ("", showCaseCategory?.categoryID ?? "", ProductCategory.bestFashion, ProductType.earnProduct, titleLabel.text!)
                strongSelf.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func addColectionViewCellLayer(cell: UICollectionViewCell) {
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1.0
    }
}

extension ShowCaseCategoryTVCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        let modelData = cellModel[indexPath.item]
        let parentController = self.parentViewController as? EarnOnlinePartnersVC
        if let strongSelf = parentController, let vc = EarnProductDetailsVC.storyboardInstance(storyBoardName: "Earn") as? EarnProductDetailsVC {
            if let PID = modelData.productID, PID != "" {
                    vc.productID = PID
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
            } else {
                strongSelf.showErrorView(errorMsg: StringConstant.productDetailsMissing)
            }
        }
    }
}
