//
//  PBNotificationVM.swift
//  PayBack
//
//  Created by valtechadmin on 01/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBNotificationVM: NSObject {
    @objc dynamic fileprivate(set) var dataSource: [NotificationCellModel] = [NotificationCellModel]()
    
    fileprivate var networkFetcher: NotificationFetcher
    
    private var notificationObserver: NSKeyValueObservation?
    internal var bindNotificationViewModels: (() -> Void) = { }
    fileprivate var successHandler: (() -> Void) = { }
    fileprivate var errorHandler: (() -> Void) = { }
    
    init(fetcher: NotificationFetcher) {
        self.networkFetcher = fetcher
        super.init()
        
        notificationObserver = self.observe(\.dataSource, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindNotificationViewModels()
        })
        DispatchQueue.global().async {
            self.notificationsData()
        }
    }
    
    func invalidateObservers() {
        self.notificationObserver?.invalidate()
    }
    deinit {
        print("PBNotificationVM: deinit called")
    }
}

extension PBNotificationVM {
    func cellModel(at index: Int) -> NotificationCellModel {
        return dataSource[index]
    }
}
extension PBNotificationVM {
    @discardableResult
    func onSuccess(success: @escaping (() -> Void)) -> Self {
        self.successHandler = success
        return self
    }
    @discardableResult
    func onError(error: @escaping (() -> Void)) -> Self {
        self.errorHandler = error
        return self
    }
}

extension PBNotificationVM {
    fileprivate func notificationsData() {
        let userId = UserProfileUtilities.getUserID()

        self.networkFetcher
            .onSuccess { [weak self] (notification) in
                var cellModelArray = [NotificationCellModel]()
                guard let notifications = notification.notifications else {
                    self?.dataSource = []
                    self?.successHandler()
                    return
                }
                for notification in notifications {
                    cellModelArray.append(NotificationCellModel(withNotification: notification))
                }
                self?.dataSource = cellModelArray
                self?.successHandler()
            }
            .onError {[weak self] (error) in
                print("\(error)")
                self?.dataSource = []
                self?.errorHandler()
            }
            .fetchNotification(withUserid: userId)
    }
    fileprivate func mock() {
        let data1 = NotificationCellModel(mNotificationImage: #imageLiteral(resourceName: "Sample_1"), mNotifiactionDetail: "The PAYBACK Member agrees that by using the PAYBACK Card or by entering his/her PAYBACK number at www.payback.in or at any PAYBACK Partner online or offline, he/she is deemed to have read and understood the these terms and conditions of the Program and agrees to be contacted by the PAYBACK call-centre or its telemarketer for the purpose of its insurance business and confirms that he/she is bound by these terms and conditions and any changes to it from time to time and such other terms as specified from LSRPL from time to time.", mNotificationTitle: "Review Received", mNotificationDate: "an hour ago")
        
        let data2 = NotificationCellModel(mNotificationImage: #imageLiteral(resourceName: "Sample_4"), mNotifiactionDetail: "The PAYBACK Member agrees that by using the PAYBACK Card or by entering his/her PAYBACK number at www.payback.in or at any PAYBACK Partner online or offline, he/she is deemed to have read and understood the these terms and conditions of the Program and agrees to be contacted by the PAYBACK call-centre", mNotificationTitle: "Product Delivered", mNotificationDate: "one hour ago")

        let data3 = NotificationCellModel(mNotificationImage: #imageLiteral(resourceName: "Sample_1"), mNotifiactionDetail: "The PAYBACK Member agrees that by using the PAYBACK Card or by entering his/her PAYBACK number at www.payback.in or at any PAYBACK Partner online or offline, he/she is deemed to have read and understood the these terms and conditions of the Program and agrees to be contacted by the PAYBACK call-centre or its telemarketer for the purpose of its insurance business and confirms that he/she is bound by these terms and conditions and any changes to it from time to time and such other terms as specified from LSRPL from time to time.", mNotificationTitle: "Review Received", mNotificationDate: "an hour ago")
        
        let data4 = NotificationCellModel(mNotificationImage: #imageLiteral(resourceName: "Sample_4"), mNotifiactionDetail: "The PAYBACK Member agrees that by using the PAYBACK Card or by entering his/her PAYBACK number at www.payback.in or at any PAYBACK Partner online or offline, he/she is deemed to have read and understood the these terms and conditions of the Program and agrees to be contacted by the PAYBACK call-centre", mNotificationTitle: "Product Delivered", mNotificationDate: "one hour ago")
        
        let data5 = NotificationCellModel(mNotificationImage: #imageLiteral(resourceName: "Sample_1"), mNotifiactionDetail: "The PAYBACK Member agrees that by using the PAYBACK Card or by entering his/her PAYBACK number at www.payback.in or at any PAYBACK Partner online or offline, he/she is deemed to have read and understood the these terms and conditions of the Program and agrees to be contacted by the PAYBACK call-centre or its telemarketer for the purpose of its insurance business and confirms that he/she is bound by these terms and conditions and any changes to it from time to time and such other terms as specified from LSRPL from time to time.", mNotificationTitle: "Review Received", mNotificationDate: "an hour ago")
        
        let data6 = NotificationCellModel(mNotificationImage: #imageLiteral(resourceName: "Sample_4"), mNotifiactionDetail: "The PAYBACK Member agrees that by using the PAYBACK Card or by entering his/her PAYBACK number at www.payback.in or at any PAYBACK Partner online or offline, he/she is deemed to have read and understood the these terms and conditions of the Program and agrees to be contacted by the PAYBACK call-centre", mNotificationTitle: "Product Delivered", mNotificationDate: "one hour ago")
        
        dataSource = [data1, data2, data3, data4, data5, data6]
    }
}
