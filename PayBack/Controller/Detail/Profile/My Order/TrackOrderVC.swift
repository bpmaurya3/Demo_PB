//
//  TrackOrderVC.swift
//  PayBack
//
//  Created by Mohsin Surani on 06/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class TrackOrderVC: BaseViewController {
    
    @IBOutlet weak fileprivate var tableView: UITableView!
    @IBOutlet weak fileprivate var cancelButton: UIButton!
    @IBOutlet weak fileprivate var helpButton: UIButton!
    @IBOutlet weak fileprivate var bottomView: UIView!

    fileprivate let orderCellIdenitifier = "CellOrder"
    fileprivate let trackCellIdenitifier = "TrackDeliveryCell"
    fileprivate let trackItemCellIdenitifier = "TrackItemCell"
    fileprivate let trackInfoCellIdenitifier = "TrackInfoCell"

    fileprivate var userInfoDataSource = [TrackItemCellModel]()
    var orderBatchID: String = ""
    var orderID: String = ""
    var trackItemCellInfo: TrackItemInfoCellModel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var trackItemCellmodel: TrackItemCellModel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var trackItemDetailsModel: [OrderInfoDetailCellModel]? = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var trackOrderStatus: TrackDeliveryCellModel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    let orderDetailNWController = MyOrderDetailsNWController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        addShadow()
        
        if self.checkConnection() {
           connectionSuccess()
        }
    }
    
    override func connectionSuccess() {
        self.fetchOrderDetails()
        self.fetchOrderStatus()
    }
    
    func fetchOrderDetails() {
        self.startActivityIndicator()
        orderDetailNWController
            .onTokenExpired { [weak self] in
                self?.updateSignInPopUp(typeCodeMsg: "Invalid Token")
                self?.stopActivityIndicator()
            }
            .onSuccess { [weak self] ( successMsg ) in
                print(successMsg)
                self?.stopActivityIndicator()
            }
            .onError { [weak self] (error) in
                self?.showErrorView(errorMsg: error)
                self?.stopActivityIndicator()
            }.onTrackItemInfo(trackItem: { [weak self] (infoCellModel) in
                self?.trackItemCellInfo = infoCellModel
                self?.stopActivityIndicator()
            }).onTrackItem(trackItem: { [weak self] (trackItemModel) in
                self?.trackItemCellmodel = trackItemModel
                self?.stopActivityIndicator()
            }).onItemDetails(trackDetailItem: { [weak self] (detailsArrayModel) in
                self?.trackItemDetailsModel = detailsArrayModel
                self?.stopActivityIndicator()
            })
            .getMyOrderDetails(orderBatchId: orderBatchID, orderId: orderID)
    }
    func fetchOrderStatus() {
        self.startActivityIndicator()
        orderDetailNWController
            .onTokenExpired(tokenExpired: { [weak self] in
                self?.updateSignInPopUp(typeCodeMsg: "Invalid Token")
                self?.parent?.stopActivityIndicator()
            })
            .onSuccess { [weak self] ( successMsg ) in
                print(successMsg)
                self?.parent?.stopActivityIndicator()
            }.onError { [weak self] (error) in
                self?.showErrorView(errorMsg: error)
                self?.parent?.stopActivityIndicator()
            } .onOrderStatus(trackOrderStatus: { [weak self] (statusModel) in
                self?.trackOrderStatus = statusModel
                self?.parent?.stopActivityIndicator()
            })
            .getMyOrderStatus(orderBatchId: orderBatchID, orderId: orderID)
    }
    
    func updateSignInPopUp(typeCodeMsg: String) {
        self.showErrorView(errorMsg: "\(typeCodeMsg) - please try to SignIn")
        self.signInPopUp()
    }
    override func userLogedIn(status: Bool) {
        print("From My Order Details & Status - User Loged In Success")
        if status {
            self.fetchOrderDetails()
            self.fetchOrderStatus()
        }
    }
    private func addShadow() {
        bottomView.layer.masksToBounds = false
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOpacity = 2
        bottomView.layer.shadowOffset = CGSize(width: 1, height: 1)
        bottomView.layer.shadowRadius = 2
    }
    
    private func registerCells() {
        tableView.register(OrderPlacedInfoCell.self, forCellReuseIdentifier: orderCellIdenitifier)
        tableView.register(UINib(nibName: trackCellIdenitifier, bundle: nil), forCellReuseIdentifier: trackCellIdenitifier)
        tableView.register(UINib(nibName: trackItemCellIdenitifier, bundle: nil), forCellReuseIdentifier: trackItemCellIdenitifier)
        tableView.register(OrderInfoDetailCell.self, forCellReuseIdentifier: trackInfoCellIdenitifier)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        UIChangesOfAction(sender: sender)
        openAlertPopForCancelAction()
    }
    
    private func openAlertPopForCancelAction() {
        guard let popUpView = Bundle.main.loadNibNamed(alertPopUpID, owner: self, options: nil)?.first as? AlertPopUp else {
            return
        }
        popUpView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(popUpView)
        
        let config = PopUpConfiguration()
            .set(hideConfirmButton: true)
            .set(hideOkButton: false)
            .set(hideCancelButton: true)
            .set(titleText: NSLocalizedString("CANCEL ORDER", comment: "CANCEL ORDER"))
            .set(desText: NSLocalizedString("Please call our Customer Care number 1860-258-5000 to cancel the order.", comment: "Please call our Customer Care number 1860-258-5000 to cancel the order."))
        
        popUpView.initWithConfiguration(configuration: config)
        popUpView.OkActionHandler = {
            print("ok clicked")
        }
    }
    
    @IBAction func helpAction(_ sender: UIButton) {
        UIChangesOfAction(sender: sender)
    }
    
    private func UIChangesOfAction(sender: UIButton) {
        
        sender.backgroudColorWithTitleColor(color: UIColor(red: 228 / 255, green: 27 / 255, blue: 110 / 255, alpha: 1), titleColor: UIColor.white)
        
        switch sender {
        case cancelButton:
            helpButton.backgroudColorWithTitleColor(color: UIColor.white, titleColor: UIColor.black)
        default:
            cancelButton.backgroudColorWithTitleColor(color: UIColor.white, titleColor: UIColor.black)
            let vc = PBHelpCentreViewController.storyboardInstance(storyBoardName: "Profile") as? PBHelpCentreViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print(" Track Ordervc deinit called")
    }
}

extension TrackOrderVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3, let model = self.trackItemDetailsModel {
            return model.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return configureCellForOrderPlaced(indexPath: indexPath)
        case 1:
            return configureDeliveryProgress(indexPath: indexPath)
        case 2:
            return configureItemCell(indexPath: indexPath)
        case 3:
            return configureDetailcell(indexPath: indexPath)
        default:
            break
        }
        return UITableViewCell()
     }
}

extension TrackOrderVC {
    fileprivate func configureCellForOrderPlaced(indexPath: IndexPath) -> OrderPlacedInfoCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: orderCellIdenitifier, for: indexPath) as? OrderPlacedInfoCell {
            cell.cellViewModel = trackItemCellInfo
            return cell
        }
        return OrderPlacedInfoCell()
    }
    
    fileprivate func configureDeliveryProgress(indexPath: IndexPath) -> TrackDeliveryCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: trackCellIdenitifier, for: indexPath) as? TrackDeliveryCell {
            cell.sourceData = self.trackOrderStatus
            return cell
        }
        return TrackDeliveryCell()
    }
    
    fileprivate func configureItemCell(indexPath: IndexPath) -> TrackItemCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: trackItemCellIdenitifier, for: indexPath) as? TrackItemCell {
            cell.cellViewModel = self.trackItemCellmodel
            return cell
        }
        return TrackItemCell()
    }
    
    fileprivate func configureDetailcell(indexPath: IndexPath) -> OrderInfoDetailCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: trackInfoCellIdenitifier, for: indexPath) as? OrderInfoDetailCell {
            cell.sourceData = self.trackItemDetailsModel?[indexPath.row]
            return cell
        }
        return OrderInfoDetailCell()
    }
}
