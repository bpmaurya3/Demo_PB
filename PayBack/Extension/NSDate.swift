//
//  NSDate.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 3/1/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
extension Date {
    func getElapsedInterval() -> String {
        var interval = Calendar.current.dateComponents([.year], from: self, to: Date()).year!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " year ago" : "\(interval)" + " years ago"
        }
        
        interval = Calendar.current.dateComponents([.month], from: self, to: Date()).month!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " month ago" : "\(interval)" + " months ago"
        }
        
        interval = Calendar.current.dateComponents([.day], from: self, to: Date()).day!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " day ago" : "\(interval)" + " days ago"
        }
        
        interval = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
        if interval > 0 {
            return interval == 1 ? "an hour ago" : "\(interval)" + " hours ago"
        }
        
        interval = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " minute ago" : "\(interval)" + " minutes ago"
        }
        
        interval = Calendar.current.dateComponents([.second], from: self, to: Date()).minute!
        if interval >= 3 {
            return "\(interval) seconds ago"
        }
        
        return "Just now"
    }
    func getDateString(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
