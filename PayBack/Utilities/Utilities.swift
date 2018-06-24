//
//  Utilities.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/22/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class Utilities {
    static func rootViewController() -> UIViewController {
       
        //UserDefaults.standard.removeObject(forKey: "FirstLaunch")

        if UserDefaults.standard.string(forKey: "FirstLaunch") == nil {
            UserDefaults.standard.set("FirstLaunch", forKey: "FirstLaunch")
            UserDefaults.standard.synchronize()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as? LeftMenuViewController
            let rightMenuViewController = storyboard.instantiateViewController(withIdentifier: "RightMenuViewController") as? RightMenuViewController
            let onBoardVC = storyboard.instantiateViewController(withIdentifier: "OnBoardVC") as? OnBoardVC
            let nvc = UINavigationController(rootViewController: onBoardVC!)
           
            leftMenuViewController?.homeViewController = nvc
            let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftMenuViewController!, rightMenuViewController: rightMenuViewController!)
            slideMenuController.delegate = onBoardVC
            
            let vc = slideMenuController
            return vc
            
        } else {
            let homeViewController = ExtendedHomeVC.storyboardInstance(storyBoardName: "Main") as? ExtendedHomeVC
            let leftMenuViewController = LeftMenuViewController.storyboardInstance(storyBoardName: "Main") as? LeftMenuViewController
            let rightMenuViewController = RightMenuViewController.storyboardInstance(storyBoardName: "Main") as? RightMenuViewController
            let nvc = UINavigationController(rootViewController: homeViewController!)
            leftMenuViewController?.homeViewController = nvc
            
            let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftMenuViewController!, rightMenuViewController: rightMenuViewController!)
            slideMenuController.delegate = homeViewController
            
            return slideMenuController
        }
    }
}

// date to sting and string to date conversion

extension Utilities {
    static func stringToNSDate (string: String) -> NSDate {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateString = dateFormatter.date(from: string)! as NSDate
        return dateString
    }
    static func dateToString (date: NSDate) -> String {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateString = dateFormatter.string(from: date as Date) as String
        return dateString
    }
    static func getDayMonth(date: String) -> String {
        // 16 May
        if !date.isEmpty && date != "" {
        let datefromString = stringToNSDate(string: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        let createdDate = formatter.string(from: datefromString as Date)
            return createdDate
        } else {
            return ""
        }
    }
    static func getDayMonthYear(date: String) -> String {
        // 16 May 2017
        if !date.isEmpty && date != "" {
        let datefromString = stringToNSDate(string: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let createdDate = formatter.string(from: datefromString as Date)
        return createdDate
        } else {
            return ""
        }
    }
    
    static func isValidDateFormateYYMMDD(dateString: String) -> String {
        // if dd-MM-yyyy to 
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        
        let dateFormaterGet2 = DateFormatter()
        dateFormaterGet2.dateFormat = "yyyy-MM-dd"
        
        if dateFormatterGet.date(from: dateString) != nil {
            let yyMMDDdate = dateFormatterGet.date(from: dateString)
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            return  dateFormatterGet.string(from: yyMMDDdate!)
        } else if dateFormaterGet2.date(from: dateString) != nil {
            let ddMMYYYYdate = dateFormaterGet2.date(from: dateString)
            dateFormaterGet2.dateFormat = "dd-MM-yyyy"
            return  dateFormatterGet.string(from: ddMMYYYYdate!)
        } else {
            return dateString
        }
    }
}

// Text with Strick Line
extension Utilities {
    static func getTextWithStickLine(string: String) -> NSMutableAttributedString {
        // swiftlint:disable legacy_constructor
        let discountString: NSMutableAttributedString = NSMutableAttributedString(string: string)
        discountString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, discountString.length))
        return discountString
        // swiftlint:enable legacy_constructor
    }
    // Text with Under Line
    static func getTextWithUnderLine(string: String) -> NSMutableAttributedString {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    //Text with color
    static func getTextWithColor(color: UIColor, text: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
}

// Convert String to Int
extension Utilities {
    static func getIntegerValueFromString(stringValue: String) -> Int {
        return (stringValue as NSString).integerValue
    }
}

// Mobile Number with formate of - 99xxxx9898
extension Utilities {
    static func getHiddenMobileNumber(mobileNum: String) -> String {
        if mobileNum != "" {
            let string: String = mobileNum
            let index1 = string.index(string.startIndex, offsetBy: 2)
            let index2 = string.index(string.endIndex, offsetBy: -4)
            let changeStr = String(string[index1..<index2])
            let replaced = (string as NSString).replacingOccurrences(of: changeStr, with: "xxxx")
            return replaced
        } else { return ""
        }
    }
}

// MARK: Random Number
extension Utilities {
    static func generateRandom_FourteenDigits() -> String {
        let digitNumber = 14
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }
    
    static func generateRandom_FourDigits() -> String {
        let digitNumber = 4
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }
}

extension Utilities {
  static func getTheRedirectURLwithLCN(urlStrint: String) -> String {
        var url = urlStrint
        var stringtobeChange = ""
        if urlStrint.contains("pbdata=") {
            let stringArray = urlStrint.components(separatedBy: CharacterSet(charactersIn: "&"))
            for item in stringArray {
                if item.contains("pbdata=") {
                    stringtobeChange = item
                    break
                }
            }
            url = url.replacingOccurrences(of: stringtobeChange, with: "pbdata=\(UserProfileUtilities.getUserCardnumber())")
        }
        return url
    }
}
