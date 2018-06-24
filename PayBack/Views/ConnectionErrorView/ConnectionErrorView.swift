//
//  ConnectionErrorView.swift
//  PayBack
//
//  Created by Mohsin Surani on 11/12/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ConnectionErrorView: UIView {

    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var detailLabel: UILabel!
    @IBOutlet weak fileprivate var retryButton: UIButton!
    @IBOutlet weak fileprivate var customNav: DesignableNav!
    
    var connectionSuccess: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = FontBook.Bold.ofSubHeaderSize()
        detailLabel.font = FontBook.Regular.ofTitleSize()
        retryButton.titleLabel?.font = FontBook.Regular.ofButtonTitleSize()
        customNav.backButton.isHidden = true
    }

    @IBAction func retryAction(_ sender: Any) {
        if BaseViewController().checkConnection() {
            connectionSuccess?()
           self.removeFromSuperview()
        }
    }
}
extension ConnectionErrorView {
    @discardableResult
    func setTitle(tile: String) -> Self {
        self.titleLabel.text = tile
        
        return self
    }
    @discardableResult
    func setDetail(detail: String) -> Self {
        self.detailLabel.text = detail
        
        return self
    }
}
