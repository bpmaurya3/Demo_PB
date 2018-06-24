//
//  PBHelpCentreTVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 15/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBHelpCentreTVCell: UITableViewCell {
   // let optionDataArray = ["f", "f", "f", "f"]//, "f", "f", "f"]
    var tapClouser: ((Int) -> Void) = { _ in }

    internal lazy var mHelpCentreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let mHelpCentreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mHelpCentreCollectionView.backgroundColor = UIColor.clear
        mHelpCentreCollectionView.delegate = self
        mHelpCentreCollectionView.dataSource = self
        mHelpCentreCollectionView.register(UINib(nibName: "PBHelpCentreCVCell", bundle: nil), forCellWithReuseIdentifier: "PBHelpCentreCVCell")
        mHelpCentreCollectionView.showsVerticalScrollIndicator = false
        return mHelpCentreCollectionView
    }()
    
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
    
    private func setupCategoryView() {
        self.selectionStyle = .none
        self.addSubview(mHelpCentreCollectionView)
        self.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: mHelpCentreCollectionView)
        self.addConstraintsWithFormat("V:|-10-[v0]|", views: mHelpCentreCollectionView)
        mHelpCentreCollectionView.isScrollEnabled = false
    }
    
    var optionDataArray = [PBHelpCentreTVCellModel]() {
        didSet {
            mHelpCentreCollectionView.reloadData()
        }
    }
}

extension PBHelpCentreTVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if optionDataArray.count % 3 == 1 {
            return optionDataArray.count + 1
        }
        return optionDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PBHelpCentreCVCell", for: indexPath) as? PBHelpCentreCVCell {
            configureCell(cell: cell, indexPath: indexPath)
            if optionDataArray.count % 3 == 1 && optionDataArray.count == indexPath.item {
                cell.cellModel = optionDataArray[indexPath.item - 1]
            } else {
                cell.cellModel = optionDataArray[indexPath.item]
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (mHelpCentreCollectionView.frame.size.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if optionDataArray.count % 3 == 1 && optionDataArray.count == indexPath.item {
             tapClouser(indexPath.item - 1)
        } else {
            tapClouser(indexPath.item)
        }
    }
}

extension PBHelpCentreTVCell {
    fileprivate func configureCell(cell: PBHelpCentreCVCell, indexPath: IndexPath) {
        if optionDataArray.count % 3 == 1 && optionDataArray.count == indexPath.item + 1 {
            let imageViewHidden = true
            let textLabelHidden = true
            cell.backgroundColor = ColorConstant.collectionViewBGColor
            cell.isUserInteractionEnabled = false
            cell.update(isImageViewHidden: imageViewHidden)
            cell.update(isTextLabelHidden: textLabelHidden)
        }
    }
}
