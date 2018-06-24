//
//  SpecifyCell.swift
//  PaybackPopup
//
//  Created by Mohsin Surani on 23/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class SpecifyCell: UITableViewCell {

    @IBOutlet weak private var specifyDetailLabel: UILabel!
//    @IBOutlet weak private var specifyTitleButton: UIButton!
    @IBOutlet weak private var specifyTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        specifyTitleButton.titleLabel?.numberOfLines = 0
        specifyTitleLabel.sizeToFit()
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.separatorInset = UIEdgeInsets(top: 0, left: strongSelf.bounds.size.width, bottom: 0, right: 0)
        }
        
        self.specifyTitleLabel.font = FontBook.Bold.of(size: 12.0)
        self.specifyTitleLabel.textColor = ColorConstant.textColorPointTitle
        self.specifyDetailLabel.font = FontBook.Regular.of(size: 12.0)
        self.specifyDetailLabel.textColor = ColorConstant.textColorPointTitle
    }

    var cellViewModel: SpecificationCellModel? {
        didSet {
            self.configureCell()
        }
    }
    
    private func configureCell() {
        if let featureTitle = cellViewModel?.featureType {
//            specifyTitleButton.setTitle(featureTitle, for: .normal)
            specifyTitleLabel.text = featureTitle
        }
        if let featureDetail = cellViewModel?.featureDetail {
            specifyDetailLabel.text = featureDetail
            specifyDetailLabel.setLineSpacing(lineSpacing: 8)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        print(" SpecifyCell deinit called")

    }
}
extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else {
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

        self.attributedText = attributedString
    }
}
