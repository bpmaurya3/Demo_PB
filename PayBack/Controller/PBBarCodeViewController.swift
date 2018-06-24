//
//  PBBarCodeViewController.swift
//  PayBack
//
//  Created by valtechadmin on 5/11/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit

class PBBarCodeViewController: BaseViewController {

    @IBOutlet fileprivate weak var mobileNumberView: UIView!
    @IBOutlet fileprivate weak var barCodeContainerView: UIView!
    @IBOutlet fileprivate weak var barCodeImageView: UIImageView!
    @IBOutlet weak private var navigationView: DesignableNav!

    var mobileNumString = ""
    var mobileNumArray = [Character]()
    
    override func viewDidLoad() {
        navigationView.title = "Earn & Redeem Points instantly with PAYBACK"
        
        super.viewDidLoad()
        barCodeContainerView.layer.borderWidth = 1.0
        barCodeContainerView.layer.borderColor = UIColor.lightGray.cgColor
        barCodeContainerView.layer.cornerRadius = 5
        
        mobileNumberView.layer.cornerRadius = 5
        mobileNumberView.layer.borderWidth = 1
        mobileNumberView.layer.borderColor = UIColor.lightGray.cgColor
        let lcn = UserProfileUtilities.getUserCardnumber()
        barCodeImageView.image = generateBarcode(from: lcn)
        showMobileNumber()
    }

    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    func showMobileNumber() {
        for character in mobileNumString {
            mobileNumArray.append(character)
        }

        let labelWidth = ((ScreenSize.SCREEN_WIDTH - 70) / CGFloat(mobileNumString.count))
        for (index, item) in mobileNumArray.enumerated() {
            let labelXPosition = labelWidth * CGFloat(index)
            let mobileLabel = UILabel(frame: CGRect(x: labelXPosition, y: 0, width: labelWidth - 1, height: 50))
            mobileLabel.textAlignment = .center
            mobileLabel.backgroundColor = .white
            mobileLabel.text = String(item)
            mobileNumberView.addSubview(mobileLabel)
        }
    }
}
