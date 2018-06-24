//
//  SegmentCVConfiguration.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/7/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
import UIKit

class SegmentCVConfiguration {
    
    var selectedCompletion: (SegmentCollectionViewCellModel, Int) -> Void = { _, _  in }

    fileprivate(set) var numberOfItemsPerScreen: CGFloat = 1
    fileprivate(set) var selectedIndex = 0
    fileprivate(set) var titles = [SegmentCollectionViewCellModel]()
    fileprivate(set) var seletedIndexTextColor = ColorConstant.segmentSelectedColor
    fileprivate(set) var textColor = ColorConstant.segmentNormalTextColor
    fileprivate(set) var selectedIndexBottomLineColor = ColorConstant.segmentSelectedBottomLineColor
    fileprivate(set) var normalBottomLineColor = UIColor.clear
    fileprivate(set) var isImageIconHidden = true
    fileprivate(set) var isSelectedImageIconHidden = true
    fileprivate(set) var titleFontandSize = FontBook.Regular.of(size: 14)
    fileprivate(set) var segmentViewDeviderColor = ColorConstant.segmentDividerColor
    fileprivate(set) var segmentItemSpacing: CGFloat = 0

    @discardableResult
    func set(fontandsize: UIFont) -> Self {
        self.titleFontandSize = fontandsize
        return self
    }
    
    @discardableResult
    func set(isImageIconHidden: Bool) -> Self {
        self.isImageIconHidden = isImageIconHidden
        return self
    }
    @discardableResult
    func set(isSelectedImageIconHidden: Bool) -> Self {
        self.isSelectedImageIconHidden = isSelectedImageIconHidden
        return self
    }
    
    @discardableResult
    func set(numberOfItemsPerScreen: CGFloat) -> Self {
        self.numberOfItemsPerScreen = numberOfItemsPerScreen
        return self
    }
    
    @discardableResult
    func set(title: [SegmentCollectionViewCellModel]) -> Self {
        self.titles = title
        return self
    }
    @discardableResult
    func set(textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }
    @discardableResult
    func set(selectedIndexTextColor: UIColor) -> Self {
        self.seletedIndexTextColor = selectedIndexTextColor
        return self
    }
    @discardableResult
    func set(selectedIndexBottomLineColor: UIColor) -> Self {
        self.selectedIndexBottomLineColor = selectedIndexBottomLineColor
        return self
    }
    @discardableResult
    func set(normalBottomLineColor: UIColor) -> Self {
        self.normalBottomLineColor = normalBottomLineColor
        return self
    }
    
    @discardableResult
    func set(selectedIndex: Int) -> Self {
           self.selectedIndex = selectedIndex
        guard titles.count > selectedIndex else {
            return self
        }
        selectedCompletion(titles[selectedIndex], selectedIndex)
        return self
    }
    
    @discardableResult
    func set(deviderColor: UIColor) -> Self {
        self.segmentViewDeviderColor = deviderColor
        return self
    }
    
    @discardableResult
    func set(segmentItemSpacing: CGFloat) -> Self {
        self.segmentItemSpacing = segmentItemSpacing
        return self
    }
}
