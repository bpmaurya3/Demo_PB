//
//  String.swift
//  PayBack
//
//  Created by Dinakaran M on 31/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last ?? ""
    }
    
    func substring(_ from: Int) -> String {
        return String(self[index(startIndex, offsetBy: from)...])//.substring(from: self.index(self.startIndex, offsetBy: from))
    }
    func subString(upto offset: Int) -> String {
        guard self.count > offset else {
            return self
        }
        let start = self.startIndex
        let end = self.index(self.startIndex, offsetBy: offset)
        let range = start..<end
        return String(self[range])
    }
    
    var length: Int {
        return self.count
    }
    
    func isNotEmpty() -> Bool {
        return !self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
    
    func isValidEmailId() -> Bool {
        let emailCheck = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")
        return emailCheck.evaluate(with: self)
    }
    
    func isNumberFormat() -> Bool {
        let mobileCheck = NSPredicate(format: "SELF MATCHES %@", "^([+-]?)(?:|0|[0-9]\\d*)?$")
        return mobileCheck.evaluate(with: self)
    }
    
    func allowNumbersOnly() -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: self)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func allowAlphaNumSpecialChars() -> Bool {
        let notAllowedCharacters = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.,"
        let set = NSCharacterSet(charactersIn: notAllowedCharacters)
        let inverted = set.inverted
        let filtered = self.components(separatedBy: inverted).joined(separator: "")
        return filtered == self
    }
    
    func allowSmallCharsOnly() -> Bool {
        return !(self >= "A" && self <= "Z")
    }

    func setUpUrl() {
        if let url = (self.contains("http")) ? URL(string: self) : URL(string:  RequestFactory.getFinalImageURL(urlString: self)) {
            url.open()
        }
    }
    func getUrlLink() -> URL? {
        var urlString = self
        urlString = urlString.replacingOccurrences(of: " ", with: "")

        if let url = (urlString.contains("http")) ? URL(string: urlString) : URL(string:  RequestFactory.getFinalImageURL(urlString: urlString)) {
            return url
        } else {
            return nil
        }
    }
    
    func copyAction() {
        UIPasteboard.general.string = self
    }
    
    func toLengthOf(length: Int) -> String {
        if length <= 0 {
            return self
        } else if let to = self.index(self.startIndex, offsetBy: length, limitedBy: self.endIndex) {
            //return self.substring(from: to)
            return String(self[to...])
            
        } else {
            return ""
        }
    }
    func dateString(fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        let date = dateFormatter.date(from: self)
        
        dateFormatter.dateFormat = toFormat
        var dateString = ""
        if let date = date {
            dateString = dateFormatter.string(from: date)
        }
        return dateString
    }
    func dateFromString(format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date ?? Date()
    }
    
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedStringKey.font: font])
    }
}
