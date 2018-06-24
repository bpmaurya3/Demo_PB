//
//  OtherPartnerCell.swift
//  PayBack
//
//  Created by Dinakaran M on 07/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class OtherPartnerTVCell: UITableViewCell {
    fileprivate let CellSpacing = 10
    fileprivate var cellIdentifierID = "OtherPartnerCollectionCell"
    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var collectionView: UICollectionView!
    var sourceData: [OtherPartnerCollectionCellModal] = [OtherPartnerCollectionCellModal]()
    
    var tapOtherPartnerClosure: (Int) -> Void = { _ in }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        title.font = FontBook.Bold.of(size: 20)
    }
    deinit {
        print(" OtherPartnerTVCell deinit called")
    }
}

extension OtherPartnerTVCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sourceData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifierID, for: indexPath) as? OtherPartnerCVCell, sourceData.count > indexPath.item else {
            return UICollectionViewCell()
        }
        cell.partnerCollectionCell = sourceData[indexPath.item]
        return cell
    }
}
extension OtherPartnerTVCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height + 3, height: collectionView.frame.size.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(CellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(CellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let CellWidth: Int = Int(collectionView.frame.size.height + 3)
        let CellCount = sourceData.count
        let collectionViewWidth = self.frame.size.width
        
        let totalCellWidth = CellWidth * CellCount
        let totalSpacingWidth = CellSpacing * (CellCount - 1)
        
        let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        if leftInset > 0 {
            return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
        }
        return UIEdgeInsets(top: 0, left: CGFloat(CellSpacing), bottom: 0, right: CGFloat(CellSpacing))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tapOtherPartnerClosure(indexPath.item)
    }
}
    
class OtherPartnerCellModel: NSObject {
    var otherSourceData: [Any] = []
    internal init(sourceData: [Any]) {
        self.otherSourceData = sourceData
    }
    override init() {
        super.init()
    }
}
