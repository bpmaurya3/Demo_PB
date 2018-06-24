//
//  URL.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/8/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

extension URL {
    func open() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(self, options: [:])
        } else {
            UIApplication.shared.openURL(self)
        }
    }
}
