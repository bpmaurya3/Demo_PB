//
//  MyCartVM.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/4/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

final internal class MyCartVM: NSObject {
    var cartNController: MyCartNetworkController
    @objc dynamic fileprivate(set) var dataSource: [Any] = [Any]()
    
    private var myCartObserver: NSKeyValueObservation?
    internal var bindToMyCartViewModels: (() -> Void) = { }

    fileprivate var tokenExpiredHandler: (() -> Void) = { }
    fileprivate var successHandler: (() -> Void) = { }
    fileprivate var errorHandler: (() -> Void) = { }

    internal let configuration: MyCartConfiguration = MyCartConfiguration()
    
    init(networkController: MyCartNetworkController) {
        self.cartNController = networkController
        super.init()
        
        myCartObserver = self.observe(\.dataSource, options: NSKeyValueObservingOptions.new, changeHandler: { [unowned self] (_, _) in
            self.bindToMyCartViewModels()
        })
    }
    
    func invalidateObservers() {
        self.myCartObserver?.invalidate()
    }
}
extension MyCartVM {
    func numberOFSection() -> Int {
        return dataSource.count
    }
    func cellModel(atSection section: Int) -> Any {
        return dataSource[section]
    }
    func deleteCellModel(model: MyCartTVCellModel) {
        if let data = dataSource as? [MyCartTVCellModel], let index = data.index(where: { $0.title == model.title }) {
            dataSource.remove(at: index)
        }
    }
}

extension MyCartVM {
    internal func fetchMyCart() {
        self.configuration.set(tabSelectionType: .myCartCell)
        self.dataSource.removeAll()
        cartNController
            .onMyCartSuccess(success: { [weak self] (myCarts) in
                self?.configuration.set(cellType: .myCartCell)
                self?.dataSource = myCarts
            })
            .onMyCartError(error: { [weak self] (error) in
                print("\(error)")
                self?.configuration.set(cellType: .noCartCell)
                self?.bindToMyCartViewModels()
            })
            .fetchMyCart()
    }
    
    internal func fetchMyOrder() {
        self.configuration.set(tabSelectionType: .myOrderCell)
        self.dataSource.removeAll()
        cartNController
            .onMyOrderSuccess { [weak self] (myOrders) in
                self?.configuration.set(cellType: .myOrderCell)
                self?.dataSource = myOrders
                self?.successHandler()
            }
            .onMyOrderError { [weak self] _ in
                self?.configuration.set(cellType: .noCartCell)
                self?.bindToMyCartViewModels()
                self?.errorHandler()
            }
            .onTokenExpired(tokenExpired: tokenExpiredHandler)
            .fetchMyOrder()
        
    }
}

extension MyCartVM {
    func onTokenExpired(tokenExpired: @escaping (() -> Void)) -> Self {
        self.tokenExpiredHandler = tokenExpired
        return self
    }
    func onSuccess(success: @escaping (() -> Void)) -> Self {
        self.successHandler = success
        return self
    }
    func onError(error: @escaping (() -> Void)) -> Self {
        self.errorHandler = error
        return self
    }
}

final internal class MyCartConfiguration {
    
    private(set) var cellType: MyCartCellType = MyCartCellType.none
    private(set) var tabSelectionType: MyCartCellType = MyCartCellType.none
    private(set) var cellHeight: CGFloat = 0
    
    @discardableResult
    func set(cellType: MyCartCellType) -> Self {
        self.cellType = cellType
        
        return self
    }
    
    @discardableResult
    func set(tabSelectionType: MyCartCellType) -> Self {
        self.tabSelectionType = tabSelectionType
        
        return self
    }
    
    @discardableResult
    func set(cellHeight: CGFloat) -> Self {
        self.cellHeight = cellHeight
        
        return self
    }
}
