//
//  SixthCartReviewTVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 28/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class SixthCartReviewTVCell: UITableViewCell {

    @IBOutlet weak private var mProductPrice: UILabel!
    @IBOutlet weak private var mProductName: UILabel!
    @IBOutlet weak private var mProductImage: UIImageView!
    @IBOutlet weak private var mProductView: UIView!

    @IBOutlet weak private var mTotalPointLabel: UILabel!
    @IBOutlet weak private var mRedeemedPointLabel: UILabel!
    @IBOutlet weak private var mBalancePointLabel: UILabel!
    
    @IBOutlet weak private var mTotalPointTextLabel: UILabel!
    @IBOutlet weak private var mRedeemedPointTextLabel: UILabel!
    @IBOutlet weak private var mBalancePointTextLabel: UILabel!
    
    @IBOutlet weak private var mViewContent: UIView!
    
    var cellModel: SixthCartReviewTVCellModel? {
        didSet {
            guard let model = cellModel else {
                return
            }
            parseData(withCellModel: model)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        mProductView.layer.addBorderRect(color: ColorConstant.grayBorderDelivery, thickness: 0.5)

        DispatchQueue.main.async { [weak self] in
            self?.mViewContent.layer.addBorder(edge: .top, color: ColorConstant.grayBorderDeliveryCart, thickness: 0.5)
            self?.mViewContent.layer.addBorder(edge: .bottom, color: ColorConstant.grayBorderDeliveryCart, thickness: 0.5)
        }
        
        setFontsColors()
    }
    
    private func setFontsColors() {
        mProductName.font = FontBook.Bold.of(size: 12)
        mProductPrice.font = FontBook.Medium.of(size: 18)
        
        mTotalPointLabel.font = FontBook.Medium.of(size: 12)
        mRedeemedPointLabel.font = FontBook.Medium.of(size: 12)
        mBalancePointLabel.font = FontBook.Bold.of(size: 12)
        
        mProductPrice.font = FontBook.Medium.of(size: 18)
        mProductPrice.font = FontBook.Medium.of(size: 18)
        
        mTotalPointTextLabel.font = FontBook.Regular.of(size: 12)
        mRedeemedPointTextLabel.font = FontBook.Regular.of(size: 12)
        mBalancePointTextLabel.font = FontBook.Bold.of(size: 12)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    deinit {
        print("SixthCartReviewTVCell deinit called")
    }
    
    private func parseData(withCellModel model: SixthCartReviewTVCellModel) {
        if let imagePath = model.productImagePath {
            mProductImage.downloadImageFromUrl(urlString: imagePath)
        }
        if let name = model.productName {
            mProductName.text = name
        }
        if let points = model.productPoints {
            mProductPrice.text = "\(points) \(StringConstant.pointsSymbol)"
            mRedeemedPointLabel.text = "\(StringConstant.pointsSymbol)   \(points)"
        }
        
        if let totalPoints = model.totalUserPoints {
            mTotalPointLabel.text = "\(StringConstant.pointsSymbol)   \(totalPoints)"
        }
        
        if let points = model.productPoints, let totalPoints = model.totalUserPoints {
            mBalancePointLabel.text = "\(StringConstant.pointsSymbol)   \(totalPoints - points)"
        }
    }
}

struct SixthCartReviewTVCellModel {
    let productPoints: Int?
    let productName: String?
    let productImagePath: String?
    let totalUserPoints: Int?
    
    init(productPoints: Int, productName: String, productImagePath: String, totalUserPoints: Int) {
        self.productPoints = productPoints
        self.productName = productName
        self.productImagePath = productImagePath
        self.totalUserPoints = totalUserPoints
    }
}
