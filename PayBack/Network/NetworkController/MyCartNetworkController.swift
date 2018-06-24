//
//  MyCartNetworkController.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class MyCartNetworkController {
    
    let myOrderFetcher = MyOrderFetcher()
    var myOrderSuccessHandler: (([MyOrderTVCellModel]) -> Void) = { _ in }
    var myOrderErrorHandler: ((String) -> Void) = { _ in }
    
    var myCartSuccessHandler: (([MyCartTVCellModel]) -> Void) = { _ in }
    var myCartErrorHandler: ((String) -> Void) = { _ in }
    
    var tokenExpiredHandler: (() -> Void) = { }

    internal func fetchMyCart() {
        self.myCartSuccessHandler(mockMyCart())
        
//        self.myCartErrorHandler("Internal error - Please try again")
    }
    
    internal func fetchMyOrder() {
        myOrderFetcher
            .onSuccess(success: { (myOrders) in
                var orderList = [MyOrderTVCellModel]()
                guard let batchList = myOrders.extintGetOrderBatchList else {
                    return
                }
                for extintGetOrderBatch in batchList {
                    orderList.append(MyOrderTVCellModel(withMyOrder: extintGetOrderBatch))
                }
                self.myOrderSuccessHandler(orderList)
            })
            .onTokenExpired(tokenExpired: tokenExpiredHandler)
            .onError(error: myOrderErrorHandler)
            .fetchMyOrder()
    }
}

extension MyCartNetworkController {
    @discardableResult
    func onMyOrderSuccess(success: @escaping (([MyOrderTVCellModel]) -> Void)) -> Self {
        self.myOrderSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onMyOrderError(error: @escaping ((String) -> Void)) -> Self {
        self.myOrderErrorHandler = error
        
        return self
    }
    @discardableResult
    func onMyCartSuccess(success: @escaping (([MyCartTVCellModel]) -> Void)) -> Self {
        self.myCartSuccessHandler = success
        
        return self
    }
    @discardableResult
    func onMyCartError(error: @escaping ((String) -> Void)) -> Self {
        self.myCartErrorHandler = error
        
        return self
    }
    func onTokenExpired(tokenExpired: @escaping (() -> Void)) -> Self {
        self.tokenExpiredHandler = tokenExpired
        return self
    }
}

extension MyCartNetworkController {
    fileprivate func mockMyCart() -> [MyCartTVCellModel] {
        let data1 = MyCartTVCellModel(image: #imageLiteral(resourceName: "camera"), title: "Sony Cybershot DSC-HX400V DSC-HX400V Point and Shoot Digital Camera", points: "219500", cartCount: "1")
        let data2 = MyCartTVCellModel(image: UIImage(named: "shoppingcart")!, title: "Samsung Galaxy A516GB", points: "219500", cartCount: "3")
        
        return [data1, data2, data2, data1, data2]
    }
    
    fileprivate func mockMyOrder() -> [MyOrderTVCellModel] {
        let data1 = MyOrderTVCellModel(orderDate: "8 Sep 2017", orderId: "Order id: RWN45234", image: UIImage(named: "shoppingcart")!, title: "Sony Cybershot DSC-HX400V DSC-HX400V Point and Shoot Digital Camera", price: "Rs. 13390", orderStatus: "In Progress")
        let data2 = MyOrderTVCellModel(orderDate: "8 Sep 2017", orderId: "Order id: RWN45234", image: UIImage(named: "shoppingcart")!, title: "Sony Cybershot DSC-HX400V DSC-HX400V Point and Shoot Digital Camera", price: "Rs. 13390", orderStatus: "In Progress")
        let data3 = MyOrderTVCellModel(orderDate: "8 Sep 2017", orderId: "Order id: RWN45234", image: UIImage(named: "shoppingcart")!, title: "Sony Cybershot DSC-HX400V DSC-HX400V Point and Shoot Digital Camera", price: "Rs. 13390", orderStatus: "In Progress")
        let data4 = MyOrderTVCellModel(orderDate: "6 Sep 2017", orderId: "Order id: RWN000003", image: #imageLiteral(resourceName: "camera"), title: "Samsung Galaxy A516GB", price: " Rs. 219500", orderStatus: "Deleverd", orderStatusDate: "10 Sep 2017")
        
        return [data1, data4, data3, data2]
    }
}
