//
//  PBHelpCentreDetailTVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 15/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//
import UIKit

class PBHelpCentreDetailTVCell: UITableViewCell {
    
    @IBOutlet weak private var ansTextView: UITextView!
//    @IBOutlet weak private var ansLabel: UILabel!
    var collabsState: Bool? = false
    var sourceData: PBHelpCentreDetailTVCellModel? {
        didSet {
            guard let sourceData = sourceData else {
                return
            }
            self.parseData(forHelpCentreData: sourceData)
        }
    }
    func parseData(forHelpCentreData data: PBHelpCentreDetailTVCellModel) {
        setupUI()
        if let answer = data.ans {
            self.ansTextView.attributedText = htmlStringToAttributeLink(htmlString: answer)
        }
        if let state = data.isCollabsHidden {
            self.collabsState = state
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    func setupUI() {
        self.selectionStyle = .none
        self.ansTextView.contentInset = UIEdgeInsetsMake(-7.0, 0.0, 0.0, 0.0)
        self.ansTextView.font = DeviceType.IS_IPAD ? FontBook.Regular.of(size: 12.0) : FontBook.Regular.of(size: 10.0)
        self.ansTextView.textColor = ColorConstant.textColorPointTitle
        self.ansTextView.dataDetectorTypes = UIDataDetectorTypes.all
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    deinit {
        print(" PBHelpCentreDetailTVCell deinit called")
    }
    
    func htmlStringToAttributeLink(htmlString: String) -> NSMutableAttributedString {
        var attributeString = NSMutableAttributedString()
        
        do {
            guard let htmlData = htmlString.data(using: String.Encoding.unicode) else {
                return attributeString
            }
            try attributeString = NSMutableAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            attributeString.addAttributes([NSAttributedStringKey.font: DeviceType.IS_IPAD ? FontBook.Regular.of(size: 12.0) : FontBook.Regular.of(size: 10.0)], range: NSRange(location: 0, length: attributeString.length))
            
        } catch let e as NSError {
            print("Couldn't translate: \(e.localizedDescription) ")
        }
        return attributeString
    }
}
class PBHelpCentreDetailTVCellModel: NSObject {
    var ques: String?
    var ans: String?
    var isCollabsHidden: Bool?
    var indexID: Int?
    internal init(question: String? = nil, answer: String? = nil, isCollabsHidden: Bool? = false, index: Int) {
        self.ques = question
        self.ans = answer
        self.isCollabsHidden = isCollabsHidden
        self.indexID = index
    }
    override init() {
        super.init()
    }
}
