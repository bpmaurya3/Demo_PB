//
//  LeftMenuTableviewHeader.swift
//  PayBack
//
//  Created by Dinakaran M on 31/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
protocol CollapsibleTableViewHeaderDelegate: AnyObject {
    func toggleSection(_ header: LeftMenuTableviewHeader, section: Int)
    func headerTitleScection(_ header: LeftMenuTableviewHeader, section: Int)
}
class LeftMenuTableviewHeader: UITableViewHeaderFooterView {
    weak var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    let titleLabel = UILabel()
    let arrowLabel = UILabel()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        // Content View
        contentView.backgroundColor = UIColor.white //UIColor(hex: 0x2E3944)
        let marginGuide = contentView.layoutMarginsGuide
        
        // Title label
        contentView.addSubview(titleLabel)
        titleLabel.textColor = ColorConstant.leftMenuTitleTextColor
        titleLabel.font = FontBook.Regular.of(size: 12.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
//        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.isUserInteractionEnabled = true
        let tapHeaderView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LeftMenuTableviewHeader.tapTitleHeaderView(_:)))
        titleLabel.addGestureRecognizer(tapHeaderView)
        tapHeaderView.delegate = self as? UIGestureRecognizerDelegate
        
        // Arrow label
        contentView.addSubview(arrowLabel)
        arrowLabel.textColor = ColorConstant.rightMenuHeaderColorBlue
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.backgroundColor = UIColor.clear
        arrowLabel.textAlignment = .center
        arrowLabel.widthAnchor.constraint(equalToConstant: 21).isActive = true
        arrowLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        arrowLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        arrowLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        arrowLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        arrowLabel.isUserInteractionEnabled = true
        // Call tapHeader when tapping on this + or -
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LeftMenuTableviewHeader.tapExpandCollabs(_: )))
        arrowLabel.addGestureRecognizer(tap)
        tap.delegate = self as? UIGestureRecognizerDelegate
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Trigger toggle section when tapping on the header
    @objc func tapTitleHeaderView(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let label = gestureRecognizer.view as? UILabel else {
            return
        }
        delegate?.headerTitleScection(self, section: label.tag)
    }
    @objc func tapExpandCollabs(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let label = gestureRecognizer.view as? UILabel else {
            return
        }
        delegate?.toggleSection(self, section: label.tag)
    }
    func setCollapsed(_ collapsed: Bool) {
        let texts = collapsed ? "+" : "-"
        arrowLabel.text = texts
    }
}
