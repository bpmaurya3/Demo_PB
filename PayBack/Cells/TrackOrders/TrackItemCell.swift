//
//  TrackItemCell.swift
//  PayBack
//
//  Created by Mohsin Surani on 07/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class TrackItemCell: UITableViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var itemImageView: UIImageView!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var viewContent: UIView!

    var cellViewModel: TrackItemCellModel? {
        didSet {
            self.configureCell()
        }
    }
    
    private func configureCell() {
        if let title = cellViewModel?.title {
            titleLabel.text = title
        }
        if let price = cellViewModel?.price {
            priceLabel.text = "\(StringConstant.rsSymbol) \(price)"
        }
        if let image = cellViewModel?.image {
            itemImageView.image = image
        } else {
            itemImageView.image = #imageLiteral(resourceName: "placeholder")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
        priceLabel.text = ""
        // Initialization code
        viewContent.layer.addBorderRect(color: .lightGray, thickness: 1)
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.backgroundColor = .clear
        itemImageView.layer.addBorderRect(color: .lightGray, thickness: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        print(" TrackItemCellc deinit called")
    }
}

class TrackItemCellModel: NSObject {
    var title: String?
    var image: UIImage?
    var price: String?
    
    init?(title: String, image: UIImage?, price: String) {
        super.init()
        
        self.title = title
        self.image = image
        self.price = price
    }
}
