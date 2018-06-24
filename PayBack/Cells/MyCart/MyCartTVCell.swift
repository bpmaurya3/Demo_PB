//
//  MyCartTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/5/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class MyCartTVCell: UITableViewCell {
    @IBOutlet weak private var imgView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var pointsLabel: UILabel!
    @IBOutlet weak private var moveToWishListButton: UIButton!
    @IBOutlet weak private var quantityLabel: UILabel!

    var crossClosure: (MyCartTVCellModel) -> Void = { _ in }
    var moveToWishClosure: (MyCartTVCellModel) -> Void = { _ in }
    
    var cellModel: MyCartTVCellModel? {
        didSet {
            guard let cellModel = cellModel else {
                return
            }
            parseData(cellModel: cellModel)
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
    }
    
    private func setFontsColors() {
        titleLabel.font = FontBook.Bold.of(size: 15)
        pointsLabel.font = FontBook.Medium.of(size: 22)
        quantityLabel.font = FontBook.Medium.of(size: 14)
        moveToWishListButton.titleLabel?.font = FontBook.Regular.of(size: 12)
    }
    
    private func parseData(cellModel: MyCartTVCellModel) {
        if let image = cellModel.image {
            self.imgView.image = image
        }
        if let title = cellModel.title {
            self.titleLabel.text = title
        }
        if let points = cellModel.points {
            self.pointsLabel.text = "\(points) \(StringConstant.pointsSymbol)"
        }
        if let cartCount = cellModel.cartCount {
            self.quantityLabel.text = cartCount
        }
    }
    
    @IBAction func decreaseQuantity(_ sender: Any) {
        guard var cartCount = Int(self.quantityLabel.text ?? "") else {
            return
        }
        if cartCount > 1 {
            cartCount -= 1
        }
        self.quantityLabel.text = "\(cartCount)"
    }
    
    @IBAction func increaseQuantity(_ sender: Any) {
        guard var cartCount = Int(self.quantityLabel.text ?? "") else {
            return
        }
        cartCount += 1
        
        self.quantityLabel.text = "\(cartCount)"
    }
    
    internal func addBorderToCellSubviews() {
        DispatchQueue.main.async { [weak self] in
            self?.moveToWishListButton.layer.addBorder(edge: .top, color: .lightGray, thickness: 0.5)
        }
    }
    
    @IBAction func crossClicked(_ sender: Any) {
        if let cellModel = cellModel {
            self.crossClosure(cellModel)
        }
    }
    @IBAction func moveToWishList(_ sender: Any) {
        if let cellModel = cellModel {
            self.moveToWishClosure(cellModel)
        }
    }
}

extension MyCartTVCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

struct MyCartTVCellModel {
    let image: UIImage?
    let title: String?
    let points: String?
    let cartCount: String?
    
    init(image: UIImage, title: String, points: String, cartCount: String) {
        self.image = image
        self.title = title
        self.points = points
        self.cartCount = cartCount
    }
}
