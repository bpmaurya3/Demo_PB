//
//  PBNotificationTVCell.swift
//  PayBack
//
//  Created by valtechadmin on 01/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBNotificationTVCell: UITableViewCell {

    var notificationCellModel: NotificationCellModel? {
        didSet {
            guard let model = notificationCellModel else {
                return
            }
            self.parseData(forNotificationCellData: model)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        mNotificationTitle.font = FontBook.Bold.of(size: 15)
        mNotificationTitle.textColor = ColorConstant.textColorPointTitle
        
        mNotifiactionDetail.font = FontBook.Regular.of(size: 12.0)
        mNotifiactionDetail.textColor = ColorConstant.textColorGray
        
        mNotificationDate.font = FontBook.Regular.of(size: 10.5)
        mNotificationDate.textColor = ColorConstant.dateTextColor
        
    }
    @IBOutlet weak private var mNotifiactionDetail: UILabel!
    @IBOutlet weak private var mNotificationTitle: UILabel!
    @IBOutlet weak private var mNotificationDate: UILabel!
    @IBOutlet weak private var mNotificationImage: UIImageView!

    private func parseData(forNotificationCellData notificationCellData: NotificationCellModel) {
        if let notificationImage = notificationCellData.image {
            self.mNotificationImage.image = notificationImage
        }
        if let notificationtitle = notificationCellData.title {
            self.mNotificationTitle.text = notificationtitle
        }
        if let notificationDetail = notificationCellData.detail {
            self.mNotifiactionDetail.text = notificationDetail
        }
        if let notificationDate = notificationCellData.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
            let date = dateFormatter.date(from: notificationDate)
            self.mNotificationDate.text = date?.getElapsedInterval()
        }
        if let imagepath = notificationCellData.imagePath {
            self.mNotificationImage.downloadImageFromUrl(urlString: imagepath)
        }
    }
    
    deinit {
        print("PBNotificationTVCell: Called")
    }
}

internal class NotificationCellModel: NSObject {
    
    var image: UIImage?
    var detail: String?
    var title: String?
    var date: String?
    var imagePath: String?
    
    internal init(mNotificationImage: UIImage, mNotifiactionDetail: String, mNotificationTitle: String, mNotificationDate: String) {
        self.image = mNotificationImage
        self.detail = mNotifiactionDetail
        self.title = mNotificationTitle
        self.date = mNotificationDate
    }
    
    internal init(withNotification notification: Notifications.Notification) {
        self.imagePath = notification.imageUrl
        self.detail = notification.description
        self.title = notification.title
        self.date = notification.createdDate
    }
}
