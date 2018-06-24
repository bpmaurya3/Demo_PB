//
//  PBProductSortPopupView.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 04/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBProductSortPopupView: UIView {

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var popupViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak private var popularitylabel: UILabel!
    @IBOutlet weak private var hightolowlabel: UILabel!
    @IBOutlet weak private var lowtohighlabel: UILabel!
    @IBOutlet weak private var sortLabel: UILabel!
    @IBOutlet weak private var popularity: UIButton!
    @IBOutlet weak private var hightolow: UIButton!
    @IBOutlet weak private var lowtohigh: UIButton!
    
    fileprivate var productType: ProductType = .none
    
    var closeButtonClouser: (() -> Void ) = {  }
    var sortClouser: ((SortBy) -> Void ) = { _ in }
    var sortByClouser: ((String) -> Void ) = { _ in }
    
    var cellModel = [SortByTVCellModel]() {
        didSet {
            self.tableView.isHidden = false
            self.tableView.register(SortByTVCell.self, forCellReuseIdentifier: "Cell")
            self.tableView.allowsSelection = false
            self.tableView.reloadData()
        }
    }

    override func awakeFromNib() {
       super.awakeFromNib()
        self.sortLabel.backgroundColor = ColorConstant.primaryColorPink
        self.sortLabel.textColor = ColorConstant.textColorWhite
        self.sortLabel.font = FontBook.Bold.ofPopUpHeaderTitleSize()
        self.lowtohighlabel.font = FontBook.Regular.ofPopUpSubTitleSize()
        self.hightolowlabel.font = FontBook.Regular.ofPopUpSubTitleSize()
        self.popularitylabel.font = FontBook.Regular.ofPopUpSubTitleSize()
        self.tableView.isHidden = true
    }
    
    @IBAction func popularButtonAction(_ sender: UIButton) {
        sender.isSelected = true
        hightolow.isSelected = false
        lowtohigh.isSelected = false
        sortClouser(productType == .earnProduct ? .Earn_Popularity : .Burn_Popularity)
        self.closePopup()
    }
    
    @IBAction func hightoLowButtonAction(_ sender: UIButton) {
        sender.isSelected = true
        popularity.isSelected = false
        lowtohigh.isSelected = false
        sortClouser(productType == .earnProduct ? .Earn_HighToLow : .Burn_HighToLow)
        self.closePopup()
    }
    
    @IBAction func lowToHighButtonAction(_ sender: UIButton) {
        sender.isSelected = true
        popularity.isSelected = false
        hightolow.isSelected = false
        sortClouser(productType == .earnProduct ? .Earn_LowTOHigh : .Burn_LowTOHigh)
        self.closePopup()
    }
    private func closePopup() {
        closeButtonClouser()
    }
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.closePopup()
    }
    
    @discardableResult
    func setHeight(height: Int) -> Self {
        self.popupViewHeightContraint.constant = CGFloat(height)
        
        return self
    }
    
    @discardableResult
    func set(sortOption optionType: SortBy, moduleType: ProductType) -> Self {
        self.productType = moduleType

        switch optionType {
        case .Earn_LowTOHigh, .Burn_LowTOHigh:
            lowtohigh.isSelected = true
        case .Earn_HighToLow, .Burn_HighToLow:
            hightolow.isSelected = true
        case .Earn_Popularity, .Burn_Popularity:
            popularity.isSelected = true
        default:
            break
        }
        return self
    }
}

extension PBProductSortPopupView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SortByTVCell else {
            return UITableViewCell()
        }
        cell.cellModel = cellModel[indexPath.row]
        cell.setCheckButtonTag(tag: indexPath.row)
        cell.checkButtonClosure = { [weak self] (index, isSelected) in
            guard let strongSelf = self else {
                return
            }
            let model = strongSelf.cellModel[index]
            strongSelf.cellModel.forEach({ (sortModel) in
                sortModel.isSelected = sortModel.sortKeyword == model.sortKeyword ? true : false
            })
            strongSelf.tableView.reloadData()
            strongSelf.sortByClouser(model.sortKeyword ?? "")
            strongSelf.closePopup()
        }
        return cell
    }
}
extension PBProductSortPopupView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
}

class SortByTVCell: UITableViewCell {
    var checkButtonClosure: (Int, Bool) -> Void = { _, _  in }
    
    var checkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "uncheckradio"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var textlabel: UILabel = {
       let label = UILabel()
        label.text = "Bhuvanendra"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var cellModel: SortByTVCellModel? {
        didSet {
            guard let model = cellModel else {
                return
            }
            self.parseData(withModel: model)
        }
    }
    
    fileprivate func setup() {
        self.contentView.addSubview(checkButton)
        checkButton.addTarget(self, action: .checkUncheckForForSortByTVCell, for: .touchUpInside)
        checkButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        checkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(textlabel)
        textlabel.leadingAnchor.constraint(equalTo: self.checkButton.leadingAnchor, constant: checkButton.frame.size.width + 30).isActive = true
        textlabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        self.addConstraintsWithFormat("V:|[v0]|", views: self.textlabel)
    }
    
    @objc func checkUncheck(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        checkButtonClosure(sender.tag, sender.isSelected)
        print("C")
    }
    
    fileprivate func parseData(withModel model: SortByTVCellModel) {
        if let name = model.sortName {
            self.textlabel.text = name
        }
        if let isSelected = model.isSelected {
            let image = isSelected ? #imageLiteral(resourceName: "checkradio") : #imageLiteral(resourceName: "uncheckradio")
            checkButton.setImage(image, for: .normal)
        }
    }
    
    @discardableResult
    func setCheckButtonTag(tag: Int) -> Self {
        self.checkButton.tag = tag
        return self
    }
}
class SortByTVCellModel {
    var sortName: String?
    var sortKeyword: String?
    var isSelected: Bool?
    
    init(withSortByModel model: SortByModel, isSelected: Bool) {
        self.sortName = model.label
        self.sortKeyword = model.keyword
        self.isSelected = isSelected
    }
}
