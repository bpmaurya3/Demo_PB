//
//  PBReferCVCell.swift
//  PayBack
//
//  Created by valtechadmin on 17/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBReferCVCell: UICollectionViewCell {
    
    @IBOutlet weak private var mImageView: UIImageView!
    @IBOutlet weak private var mLabel: UILabel!
    
    deinit {
        print("PBReferCVCell deinit called")
    }
}
