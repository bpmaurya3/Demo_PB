//
//  PBHelpCentreFeedBackView.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 12/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBHelpCentreFeedBackView: UIView {
    
    var mTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .red
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    var mWarningLabel: UILabel = {
        let warningLabel = UILabel()
        warningLabel.backgroundColor = .blue
        warningLabel.textColor = .red
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        return warningLabel
    }()
    var mTextField: UITextField = {
        let textField = UITextField()
        textField.text = ""
        textField.borderStyle = UITextBorderStyle.line
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    var mTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = NSTextAlignment.justified
        textView.backgroundColor = .gray
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createCustomTextFieldView()
    }
    
    func createCustomTextFieldView() {
        self.addSubview(mTitleLabel)
        self.addSubview(mTextField)
        self.addSubview(mTextView)
        self.addSubview(mWarningLabel)
        
        addConstraintsWithFormat("H:|[v0]|", views: mTitleLabel, mTextField, mTextView, mWarningLabel)
        addConstraintsWithFormat("V:|[title(20)][textField(40)][textView(120)][warning(20)]|", views: mTitleLabel, mTextField, mTextView, mWarningLabel)
    }
}
