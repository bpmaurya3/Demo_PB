//
//  SegmentCVCell.swift
//  customCollection
//
//  Created by Dinakaran M on 29/08/17.
//  Copyright © 2017 Dinakaran M. All rights reserved.
//

import UIKit

class SegmentCVCell: UICollectionViewCell {
    @IBOutlet weak fileprivate var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak fileprivate var stackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak fileprivate var title: UILabel!
    @IBOutlet weak fileprivate var icon: UIImageView!
    @IBOutlet weak fileprivate var bottomView: UIView!
    
    var configuration: SegmentCVConfiguration? {
        didSet {
            guard let configuration = configuration else {
                return
            }
            setupCell(configuration: configuration)
        }
    }
    
    var segmentModel: SegmentCollectionViewCellModel? {
        didSet {
            guard let segmentModel = segmentModel else {
                return
            }
            parseData(model: segmentModel)
        }
    }
    
    private func setupCell(configuration: SegmentCVConfiguration) {
        self
            .update(font: configuration.titleFontandSize)
            .update(titleColor: configuration.textColor)
            .update(bootomViewBGColor: configuration.normalBottomLineColor)
            .update(isIconHidden: configuration.isImageIconHidden)
    }
    
    private func parseData(model: SegmentCollectionViewCellModel) {
        if let title = model.title {
            self.title.text = title.capitalized
        } else {
            self.title.text = ""
        }
        if let icon = model.image {
            self.icon.image = icon
            self.icon.isHidden = false
        }
        if let imagePath = model.imagePath {
            self.icon.downloadImageFromUrl(urlString: imagePath)
            self.icon.isHidden = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
        self.title.sizeToFit()
        self.icon.isHidden = true
    }
    
    private func setFontsColors() {
        self.title.font = FontBook.Regular.of(size: 13)
        
    }
    override var isSelected: Bool {
        didSet {
            if let configuration = configuration {
                let textColor = isSelected ? configuration.seletedIndexTextColor : configuration.textColor
                let bottomLineColor = isSelected ? configuration.selectedIndexBottomLineColor : configuration.normalBottomLineColor
                var selectedImage: UIImage?
                if !configuration.isSelectedImageIconHidden &&  !configuration.isImageIconHidden {
                      selectedImage = isSelected ? self.segmentModel?.selectedImage : self.segmentModel?.image
                } else {
                       selectedImage = self.segmentModel?.image
                }
               
                self
                    .update(titleColor: textColor)
                    .update(bootomViewBGColor: bottomLineColor)
                    .update(icon: selectedImage)
            }
        }
    }
}

extension SegmentCVCell {
    @discardableResult
    func update(font: UIFont) -> Self {
        self.title.font = font
        return self
    }
    
    @discardableResult
    func update(title: String) -> Self {
        self.title.text = title
        return self
    }
    
    @discardableResult
    func update(titleColor: UIColor) -> Self {
        self.title.textColor = titleColor
        return self
    }
    
    @discardableResult
    func update(bootomViewBGColor: UIColor) -> Self {
        self.bottomView.backgroundColor = bootomViewBGColor
        return self
    }
    
    @discardableResult
    func update(icon: UIImage?) -> Self {
        if let img = icon {
             self.icon.image = img
        }
        return self
    }
    
    @discardableResult
    func update(isIconHidden: Bool) -> Self {
        self.icon.isHidden = isIconHidden
        if isIconHidden {
            self.stackViewLeadingConstraint.constant = 10
            self.stackViewTrailingConstraint.constant = 10
        } else {
            self.stackViewLeadingConstraint.isActive = false
            self.stackViewTrailingConstraint.isActive = false
        }
        return self
    }
    
}
