//
//  NearBuyOffersHeader.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 5/15/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit

class NearBuyOffersHeader: UIView {
    
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nearby"
        label.font = FontBook.Bold.of(size: 18)
        label.textColor = ColorConstant.rewardScreenTitleColor
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var underLineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = ColorConstant.bottomLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    deinit {
        print("NearBuyOffersHeader: deinit called")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = ColorConstant.vcBGColor
        
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        
        addSubview(underLineView)
        underLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        underLineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        underLineView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        underLineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
}
