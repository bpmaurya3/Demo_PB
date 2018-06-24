//
//  HelpCentreTVHeaderFooterView.swift
//  PayBack
//
//  Created by Dinakaran M on 28/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
protocol HelpCentreHeaderDelegate: AnyObject {
    func toggleSection(_ header: HelpCentreTVHeaderFooterView, section: Int)
    func headerTitleScection(_ header: HelpCentreTVHeaderFooterView, section: Int)
}
class HelpCentreTVHeaderFooterView: UITableViewHeaderFooterView {
    weak var delegate: HelpCentreHeaderDelegate?
    var section: Int = 0
    let titleLabel = UILabel()
    let arrowLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        // Content View
        contentView.backgroundColor = UIColor.white
        
        // Title label
        self.addSubview(titleLabel)
        self.addSubview(arrowLabel)
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = FontBook.Bold.of(size: 11.0)
        titleLabel.textColor = ColorConstant.textColorPointTitle
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.isUserInteractionEnabled = true
        let tapHeaderView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HelpCentreTVHeaderFooterView.tapTitleHeaderView(_:)))
        titleLabel.addGestureRecognizer(tapHeaderView)
        tapHeaderView.delegate = self as? UIGestureRecognizerDelegate
        
        arrowLabel.textColor = UIColor.black
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.textAlignment = .center
        arrowLabel.font = FontBook.Bold.of(size: 20.0)
        arrowLabel.textColor = ColorConstant.textColorPointTitle
        arrowLabel.isUserInteractionEnabled = true
        arrowLabel.backgroundColor = UIColor.clear
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HelpCentreTVHeaderFooterView.tapExpandCollabs(_: )))
        arrowLabel.addGestureRecognizer(tap)
        tap.delegate = self as? UIGestureRecognizerDelegate
        
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: arrowLabel.leadingAnchor, constant: -10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        
        arrowLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        arrowLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        arrowLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        arrowLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        arrowLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print(" HelpCentreTVHeaderFooterView deinit called")
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
