//
//  UIButton.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/13/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
import  UIKit

extension UIButton {
    func backgroudColorWithTitleColor(color: UIColor, titleColor: UIColor) {
        self.backgroundColor = color
        self.setTitleColor(titleColor, for: .normal)
    }
    
    func isEnabled(state: Bool) {
        DispatchQueue.main.async {
            self.isEnabled = state
            self.alpha = state ? 1 : 0.3
        }
    }
    func downloadImageFromUrl(urlString: String, imageType: ImageType = .none) {
        let imageUrl = RequestFactory.getFullURL(urlString: urlString)
        
        guard let url = URL(string: imageUrl) else {
            return
        }
        //print("\(url)")
        self.sd_setBackgroundImage(with: url, for: .normal, placeholderImage: #imageLiteral(resourceName: "placeholder"), completed: nil)
        self.sd_setBackgroundImage(with: url, for: .highlighted, placeholderImage: #imageLiteral(resourceName: "placeholder"), completed: nil)
        self.sd_setBackgroundImage(with: url, for: .selected, placeholderImage: #imageLiteral(resourceName: "placeholder"), completed: nil)
    }
}
