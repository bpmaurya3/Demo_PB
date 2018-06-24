//
//  NotificationVC.swift
//  PayBack
//
//  Created by Dinakaran M on 18/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class NotificationVC: BaseViewController {
    
    @IBOutlet weak private var emptylabeltext: UILabel!
    @IBOutlet weak private var navigationView: DesignableNav!
    @IBOutlet weak private var mTableView: UITableView!
   
    fileprivate var notificationFetcher: NotificationFetcher!
    fileprivate var notificationViewModel: PBNotificationVM!
    private var dataSource: TableViewDataSource<PBNotificationTVCell, NotificationCellModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView.register(UINib(nibName: Cells.notificationTVCell, bundle: nil), forCellReuseIdentifier: Cells.notificationTVCell)
        mTableView.estimatedRowHeight = 50.0
        mTableView.rowHeight = UITableViewAutomaticDimension
        if self.checkConnection() {
            configureVM()
        }
        
        emptylabeltext.font = FontBook.Regular.of(size: 12.0)
        emptylabeltext.textColor = ColorConstant.emptyNotificationMsg
    }
    
    override func connectionSuccess() {
        configureVM()
    }

    deinit {
        if self.notificationViewModel != nil {
            self.notificationViewModel.invalidateObservers()
        }
        print("NotificationVC: deinit called")
    }
    private func configureVM() {
        notificationFetcher = NotificationFetcher()
        notificationViewModel = PBNotificationVM(fetcher: notificationFetcher)
        self.startActivityIndicator()
        notificationViewModel.bindNotificationViewModels = { [unowned self] in
            self.dataSource = TableViewDataSource(cellIdentifier: Cells.notificationTVCell, items: self.notificationViewModel.dataSource) { cell, vm in
                cell.notificationCellModel = vm
            }
            DispatchQueue.main.async {
                self.mTableView.dataSource = self.dataSource
                self.mTableView.reloadData()
                if self.notificationViewModel.dataSource.isEmpty {
                    self.mTableView.isHidden = true
                } else {
                    self.mTableView.isHidden = false
                    self.view.bringSubview(toFront: self.mTableView)
                }
            }
        }
        
        self.notificationViewModel
            .onSuccess { [weak self] in
                self?.stopActivityIndicator()
            }
            .onError { [weak self] in
                self?.stopActivityIndicator()
            }
        
    }
}
