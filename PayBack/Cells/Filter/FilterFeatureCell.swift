//
//  FilterFeatureCell.swift
//  PayBack
//
//  Created by Valtech Macmini on 10/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

final internal class FilterFeatureCell: UITableViewCell {

    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontBook.Regular.ofTVCellTitleSize()
        label.textColor = ColorConstant.textColorBlack
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate var arrowImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = #imageLiteral(resourceName: "arrow")
        imageview.frame.size.width = 15
        imageview.frame.size.height = 15
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    var cellViewModel: OtherFilterCellModel? {
        didSet {
            self.configureCell()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        addSubview(arrowImageView)
        arrowImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        arrowImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true
      
        DispatchQueue.main.async { [weak self] in
            self?.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        }
    }
    
    private func configureCell() {
        if let title = cellViewModel?.title {
            titleLabel.text = title
        }
    }
    
    deinit {
        print("Deinit - FilterFeatureCell")
    }
}

class OtherFilterCellModel: NSObject {
    var title: String?
    var values: [Value]?
    
    init(title: String, values: [Value]) {
        super.init()
        self.title = title
        self.values = values
    }
    class Value {
        var isSelected: Bool
        var valueName: String
        var valueId: String
        
        init(isSelected: Bool = false, valueName: String, valueId: String) {
            self.isSelected = isSelected
            self.valueName = valueName
            self.valueId = valueId
        }
    }
}
