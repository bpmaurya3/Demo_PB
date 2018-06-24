//
//  Float.swift
//  PayBack
//
//  Created by Valtech Macmini on 06/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

extension Float {
    var removeZeroDecimal: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Double {
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
