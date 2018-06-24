//
//  SignUpCell.swift
//  PayBack
//
//  Created by Mohsin Surani on 09/01/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit

class SignUpCell: UITableViewCell {

    fileprivate var dataSource: CollectionViewDataSource<PBShopClickCVCell, ShopClickCellViewModel>!
    
    fileprivate var UpdatePartnerSiteClosure: ((String, String) -> Void) = { _, _  in }
    @discardableResult
    func selectedPartnerSite(closure: @escaping ((String, String) -> Void)) -> Self {
        self.UpdatePartnerSiteClosure = closure
        return self
    }
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
    
    var cellModel: [ShopClickCellViewModel] = [] {
        didSet {
            self.dataSource = CollectionViewDataSource(cellIdentifier: Cells.shopClickCVCell, items: cellModel) { cell, vm in
                cell.shopOrInsurance = .insurance
                cell.shopClickCellViewModel = vm
            }
            self.collectionView.dataSource = self.dataSource
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: ScreenSize.SCREEN_WIDTH / 3).isActive = true
        addBorderToCollectionView()
    }
    
    deinit {
        print("CategoriesTVCell: deinit called")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension SignUpCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var commonWidth: CGFloat = ScreenSize.SCREEN_WIDTH / 3 - 10
        let cellCount: CGFloat = CGFloat(cellModel.isEmpty ? 1 : cellModel.count)
        if (commonWidth * cellCount) < ScreenSize.SCREEN_WIDTH {
            commonWidth = ScreenSize.SCREEN_WIDTH / cellCount
        }
        
        return CGSize(width: commonWidth, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let cellData = cellModel[indexPath.row]
        if let redirectUrl = cellData.redirectionURL {
            self.UpdatePartnerSiteClosure(redirectUrl, cellData.imagePath ?? "")
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension SignUpCell {
    
    fileprivate func addBorderToCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.layer.addBorderRect(color: .lightGray, thickness: 1)
        }
    }
}
