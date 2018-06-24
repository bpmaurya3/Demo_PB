//
//  OfferCategoryCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 05/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class GridTVCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    internal lazy var mCategoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let mCategoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mCategoryCollectionView.backgroundColor = UIColor.clear
        mCategoryCollectionView.delegate = self
        mCategoryCollectionView.dataSource = self
        mCategoryCollectionView.register(UINib(nibName: "GridViewCell", bundle: nil), forCellWithReuseIdentifier: "GridViewCell")
        mCategoryCollectionView.showsVerticalScrollIndicator = false
        return mCategoryCollectionView
    }()
    
    var categoryTapClouser: ((Int) -> Void) = { _ in }
    var categoryDataArray = [LandingTilesGridCellModel]() {
        didSet {
            mCategoryCollectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCategoryView()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCategoryView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCategoryView()
    }
    
    deinit {
        print("GridTVCell deinit called")
    }
    
    private func setupCategoryView() {
        self.selectionStyle = .none
        self.addSubview(mCategoryCollectionView)
        self.addConstraintsWithFormat("H:|-6-[v0]-6-|", views: mCategoryCollectionView)
        self.addConstraintsWithFormat("V:|-8-[v0]|", views: mCategoryCollectionView)
    }

}

extension GridTVCell {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridViewCell", for: indexPath) as? GridViewCell {
            cell.categoryDataArray = categoryDataArray[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = mCategoryCollectionView.frame.size.width / 2 - 4
        return CGSize(width: width, height: width / OfferTiles_HeightRatio)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryTapClouser(indexPath.item)
    }
}
