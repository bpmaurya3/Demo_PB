//
//  ExclusivBenefitsTVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 22/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ExclusivBenefitsTVCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak private var titlemessage: UILabel!
    @IBOutlet weak fileprivate var tringleView: UIView!
    @IBOutlet weak fileprivate var mBonusDetailLabel: UILabel!
    @IBOutlet weak fileprivate var mCollectionView: UICollectionView!
    var onlyOnce: Bool = true
    var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    let paybackPlusNwController = PaybackPlusNWController()
    
    var cellModel: [ExclusiveBenefitsCVCellModel] = [] {
        didSet {
            guard !cellModel.isEmpty else {
                return
            }
            self.mBonusDetailLabel.isHidden = false
            self.tringleView.isHidden = false
            mCollectionView.reloadData()
            let when = DispatchTime.now() + 0.2
            DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
                self?.selecteItem((self?.selectedIndexPath)!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        self.mBonusDetailLabel.textColor = ColorConstant.textColorWhite
        self.mBonusDetailLabel.font = FontBook.Regular.of(size: 12.0)
        self.mBonusDetailLabel.backgroundColor = ColorConstant.productTitleTextColor
       // self.tringleView.backgroundColor = ColorConstant.productTitleTextColor
        mCollectionView.allowsMultipleSelection = false
        titlemessage.textColor = ColorConstant.textColorPointRange
        titlemessage.font = FontBook.Regular.of(size: 15.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    deinit {
        print(" ExclusivBenefitsTVCell deinit called")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 250 / 255, alpha: 1.0)
        
        mCollectionView.register(UINib(nibName: Cells.exclusivBenefitsCVCellID, bundle: nil), forCellWithReuseIdentifier: Cells.exclusivBenefitsCVCellID)
        mCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        tringleView.layer.addTrianglePopOver(startingPoint: 0, color: ColorConstant.productTitleTextColor)
        mBonusDetailLabel.layer.masksToBounds = true
        mBonusDetailLabel.layer.cornerRadius = 5
        mBonusDetailLabel.isHidden = true
        tringleView.isHidden = true
        
    }
}
// MARK: Collection view Menthods
extension ExclusivBenefitsTVCell {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModel.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.exclusivBenefitsCVCellID, for: indexPath) as? ExclusiveBenefitsCVCell {
            
            configureCell(cell: cell, indexPath: indexPath)
            cell.cellModel = cellModel[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (ScreenSize.SCREEN_WIDTH - 80) / 2, height: mCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: (((ScreenSize.SCREEN_WIDTH) / 2) / 2) + 10, bottom: 0, right: (((ScreenSize.SCREEN_WIDTH + 100) / 2) / 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        selectedIndexPath = indexPath
        addTipText(indexPath)
    }
    
    fileprivate func addTipText(_ visibleIndexPath: IndexPath) {
        mBonusDetailLabel.text = cellModel[visibleIndexPath.item].description
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let center = self.convert(self.mCollectionView.center, to: self.mCollectionView)
        guard let visibleIndexPath: IndexPath = mCollectionView.indexPathForItem(at: center) else {
            return
        }
        selecteItem(visibleIndexPath)
        selectedIndexPath = visibleIndexPath
        addTipText(visibleIndexPath)
    }
}

extension ExclusivBenefitsTVCell {
    
    fileprivate func configureCell(cell: ExclusiveBenefitsCVCell, indexPath: IndexPath ) {
        if onlyOnce {
            onlyOnce = false
            addTipText(indexPath)
        }
    }
    
    private func selecteItem(_ indexPath: IndexPath) {
        self.mCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        self.mCollectionView.delegate?.collectionView!((self.mCollectionView)!, didSelectItemAt: indexPath)
    }
    
}
