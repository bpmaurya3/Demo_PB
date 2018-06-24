//
//  CustomSegmentView.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/7/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class CustomSegmentView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    fileprivate var selectedIndexPath: IndexPath?
    fileprivate let cellIdentifier = "SegmentCVCell"
    
    internal var configuration: SegmentCVConfiguration? {
        didSet {
            setupViews()
        }
    }
    
    fileprivate var currentSelectedCell = SegmentCVCell()

    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.clipsToBounds = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //setupViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setupViews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       // setupViews()
    }
    private func setupViews() {
        
         collectionView.register(UINib(nibName: "SegmentCVCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        self.addSubview(collectionView)
        self.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        self.addConstraintsWithFormat("V:|[v0]|", views: collectionView)
                
        let when = DispatchTime.now() + 0.05
        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
            if let strongSelf = self, let configuration = strongSelf.configuration {
                strongSelf.selectSegmentAtIndex(configuration.selectedIndex)
            }
        }
        
        collectionView.backgroundColor = self.configuration?.segmentViewDeviderColor
        addBorderToCollectionView()
    }
    
    fileprivate func addBorderToCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.layer.addBorderRect(color: ColorConstant.segmentDividerColor, thickness: 1)
        }
    }
    
     internal func selectSegmentAtIndex(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.scrollToItem(indexPath: indexPath, animated: false)
    }
}
extension CustomSegmentView {
    fileprivate func calculateStringLenght(indexPath: IndexPath) -> CGSize {
        var imageWidth: CGFloat = 0
        if configuration?.isImageIconHidden == false {
            imageWidth = 50
        }
        let title = configuration?.titles[indexPath.row].title
        if let title = title, let font = configuration?.titleFontandSize {
            let fontAttributes = [NSAttributedStringKey.font: font]
            var size = title.size(withAttributes: fontAttributes)
            size.width += imageWidth + 45
            return size
        }
        return .zero
    }
    
    fileprivate func updateCellSyleGuide(cell: SegmentCVCell, indexPath: IndexPath) {
        guard let configuration = configuration else {
            return
        }
        if indexPath.item == configuration.selectedIndex {
            cell
                .update(titleColor: configuration.seletedIndexTextColor)
                .update(bootomViewBGColor: configuration.selectedIndexBottomLineColor)
        } else {
            cell
                .update(titleColor: configuration.textColor)
                .update(bootomViewBGColor: configuration.normalBottomLineColor)
        }
    }
}
extension CustomSegmentView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let config = configuration else {
            return 0
        }
        return config.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? SegmentCVCell, let config = self.configuration, config.titles.count > indexPath.item else {
            return UICollectionViewCell()
        }
        cell.configuration = configuration
        cell.segmentModel = configuration?.titles[indexPath.item]
        
        updateCellSyleGuide(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let configuration = configuration else {
            return .zero
        }
         let size = calculateStringLenght(indexPath: indexPath)
//        if configuration.numberOfItemsPerScreen > 3 && UIDevice.current.userInterfaceIdiom == .phone {
//            return CGSize(width: size.width, height: collectionView.frame.size.height)
//        }
        var width = (collectionView.frame.size.width / configuration.numberOfItemsPerScreen) - 1
        width = width < size.width ? size.width : width
        return CGSize(width: width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let config = configuration else {
            return 0
        }
        return config.segmentItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndexPath = selectedIndexPath, selectedIndexPath == indexPath {
            return
        }
        self.scrollToItem(indexPath: indexPath, animated: true)
    }
    
    fileprivate func scrollToItem(indexPath: IndexPath, animated: Bool) {
        selectedIndexPath = indexPath
        if collectionView.numberOfItems(inSection: indexPath.section) > indexPath.item {
            collectionView.selectItem(at: indexPath, animated: animated, scrollPosition: .centeredHorizontally)
            configuration?.set(selectedIndex: indexPath.row)
        }
    }
}
