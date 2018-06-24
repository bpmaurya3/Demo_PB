//
//  CartReviewVC.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 13/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class CartReviewVC: BaseViewController {
    @IBOutlet weak private var navigationView: DesignableNav!
    @IBOutlet weak private var headerHeight: NSLayoutConstraint!
    @IBOutlet weak fileprivate var mDetailTableView: UITableView!
    @IBOutlet weak fileprivate var redeemNowbutton: UIButton!
    
    fileprivate var userAddressDataSource = [AddressSplitCellModel]()
    fileprivate let sixthCellIdentifier = "SixthCartReviewTVCell"
    
    fileprivate var isEditAddress: Bool = false
    fileprivate var isAddAddess: Bool = false
    fileprivate var stockCheckFetcher: StockCheckFetcher!
    fileprivate let cartReviewNWController = CartReviewNWController()
    
    var productInfo: CreateOrderProductInfoModel?
    fileprivate var loggedInUserAddress: AddressSplitCellModel?
    fileprivate var selectedAddress: AddressSplitCellModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stockCheckFetcher = StockCheckFetcher()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    deinit {
        print("CartReviewVC: Deinit called")
    }
    override func userLogedIn(status: Bool) {
        if status {
            self.createOrderRequest()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDeliveryAddress" {
            let delivery = segue.destination as? DeliveryAddressVC
            delivery?.addNewAddressHandler = { [weak self] in
                self?.getDeliveryAddress()
            }
            delivery?.updateAddressHandler = { [weak self] Data in
                self?.getDeliveryAddress()
            }
            guard let selectedIndex = sender as? Int else {
                return
            }
            delivery?.cellViewModel = userAddressDataSource[selectedIndex]
        }
    }
}
extension CartReviewVC {
    @IBAction func redeemNowButtonAction(_ sender: UIButton) {
        
        guard selectedAddress != nil else {
            self.showErrorView(errorMsg: "Please Select Shipping Address")
            return
        }
        var totalPoints = 0
        if let totalPoint = UserProfileUtilities.getUserDetails()?.TotalPoints, let totalPointInInt = Int(totalPoint) {
            totalPoints = totalPointInInt
        }
        var redeemablePoints = 0
        if let actualPoints = productInfo?.UnitPrice {
            redeemablePoints = actualPoints * (productInfo?.Quantity)!
        }
        guard totalPoints > redeemablePoints else {
            self.showErrorView(errorMsg: "You don't have enough point to redeem")
            return
        }
        //self.checkStockQuantity()
        self.createOrderRequest()
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension CartReviewVC {
    fileprivate func setup() {
        mDetailTableView.estimatedRowHeight = 50
        mDetailTableView.rowHeight = UITableViewAutomaticDimension
        redeemNowbutton.titleLabel?.font = FontBook.Regular.of(size: 15)
        registerCells()
        navigationView.titleLabel.textAlignment = .left
        
        if let userDetails = UserProfileUtilities.getUserDetails() {
            loggedInUserAddress = AddressSplitCellModel(name: userDetails.FirstName, address1: userDetails.Address1, address2: userDetails.Address2, city: userDetails.City, state: userDetails.Region, pin: userDetails.PinCode, mobile: userDetails.MobileNumber, emailid: userDetails.EmailAddress, defaultaddress: "", id: userDetails.UserID)
        }
        
        if BaseViewController().checkConnection() {
            getDeliveryAddress()
        } else {
            let connectionView = Bundle.main.loadNibNamed("ConnectionErrorView", owner: self, options: nil)?.first as? ConnectionErrorView
            connectionView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(connectionView!)
            connectionView?.connectionSuccess = { [weak self] in
                self?.getDeliveryAddress()
            }
        }
        
    }
    private func reloadSectionForAddress() {
        //mDetailTableView.reloadSections([0], with: .none)
        mDetailTableView.reloadData()
    }
    private func registerCells() {
        mDetailTableView.register(UINib(nibName: sixthCellIdentifier, bundle: nil), forCellReuseIdentifier: sixthCellIdentifier)
    }
    fileprivate func setLoaderAndRedeemButttonState(state: Bool) {
        if state {
            self.stopActivityIndicator()
        } else {
            self.startActivityIndicator()
        }
        self.redeemNowbutton.isEnabled(state: state)
    }
}

extension CartReviewVC {
    private func getDeliveryAddress() {
        self.startActivityIndicator()
        cartReviewNWController
            .onError { [weak self] _ in
                self?.stopActivityIndicator()
                self?.setdataInAddress(data: nil)
            }.onSuccess { [weak self] Data in
                self?.stopActivityIndicator()
                self?.setdataInAddress(data: Data)
            }.getAddresss()
    }
    
    fileprivate func deleteDeliveryAddress(addressId: String) {
        cartReviewNWController
            .onError { [weak self] (error) in
                self?.stopActivityIndicator()
                self?.showErrorView(errorMsg: error)
            }.onDeleteSuccess { [weak self] in
                self?.stopActivityIndicator()
                self?.getDeliveryAddress()
            }.deleteAddresss(addressId: addressId)
    }
    private func setdataInAddress(data: [AddressSplitCellModel]?) {
        userAddressDataSource.removeAll()
        var fetchedData = [AddressSplitCellModel]()
        if let loggedInUserAddress = loggedInUserAddress {
            if let data1 = data, !data1.isEmpty {
                fetchedData.append(loggedInUserAddress)
                fetchedData += data1
            } else {
                fetchedData.append(loggedInUserAddress)
            }
        } else if let data1 = data, !data1.isEmpty {
            fetchedData = data1
        }
        userAddressDataSource = fetchedData
        if let index = userAddressDataSource.index(where: { $0.defaultaddress == "1" }) {
            selectedAddress = userAddressDataSource[index]
            if selectedAddress?.id != loggedInUserAddress?.id, let index = userAddressDataSource.index(where: { $0.id == loggedInUserAddress?.id }) {
                var userAdd = userAddressDataSource[index]
                userAdd.defaultaddress = "0"
                userAdd.tempDefaultaddress = "0"
                userAddressDataSource[index] = userAdd
            }
        } else if !userAddressDataSource.isEmpty {
            var userAdd = userAddressDataSource[0]
            userAdd.defaultaddress = "1"
            userAdd.tempDefaultaddress = "1"
            userAddressDataSource[0] = userAdd
            selectedAddress = userAddressDataSource[0]
        } else {
            selectedAddress = nil
        }
        reloadSectionForAddress()
    }
    fileprivate func checkStockQuantity() {
        guard let productId = productInfo?.ItemId else {
            self.showErrorView(errorMsg: "Product info is missing")
            return
        }
        self.setLoaderAndRedeemButttonState(state: false)
        stockCheckFetcher
            .onError { [weak self] (error) in
                self?.setLoaderAndRedeemButttonState(state: true)
                self?.showErrorView(errorMsg: error)
            }
            .onSuccess { [weak self] (availaleProduct) in
                self?.comparedwithStockCount(avalProductCount: availaleProduct)
            }.stockCheck(productId: productId)
    }
    
    fileprivate func comparedwithStockCount(avalProductCount: String) {
        let stockCount = Utilities.getIntegerValueFromString(stringValue: avalProductCount)
        if stockCount >= (productInfo?.Quantity)! {
            createOrderRequest()
        } else {
            self.setLoaderAndRedeemButttonState(state: true)
            let msg = "Only \(stockCount) in Stock"
            self.showErrorView(errorMsg: msg)
        }
    }
    
    fileprivate func createOrderRequest() {
        guard let productInfo = productInfo, !userAddressDataSource.isEmpty  else {
            self.setLoaderAndRedeemButttonState(state: true)
            return
        }
        guard let deliveryAdd = self.selectedAddress else {
            self.setLoaderAndRedeemButttonState(state: true)
            self.showErrorView(errorMsg: "Please add delivery address")
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        cartReviewNWController
            .onCreateOrderSuccess { [weak self] _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self?.performSegue(withIdentifier: "toTransactionSucc", sender: self)
            }
            .onCreateOrderError {[weak self] (error) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print(error)
                self?.setLoaderAndRedeemButttonState(state: true)
                self?.showErrorView(errorMsg: error)
            }
            .onTokenExpired {[weak self] in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self?.setLoaderAndRedeemButttonState(state: true)
                self?.signInPopUp()
                self?.showErrorView(errorMsg: "Invalid Token")
            }
            .createOrder(shipmentInfo: deliveryAdd, productInfo: productInfo)
    }
}

extension CartReviewVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return userAddressDataSource.count + 2
        case 2:
            return (productInfo == nil) ? 0 : 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: "FirstCartReviewTVCell", for: indexPath) as? FirstCartReviewTVCell
                
            case userAddressDataSource.count + 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "FourthCartReviewTVCell", for: indexPath) as? FourthCartReviewTVCell
                configureFourthCell(cell: cell as? FourthCartReviewTVCell)
                
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: "ScondCartReviewTVCell", for: indexPath) as? ScondCartReviewTVCell
                configureAddressCell(cell: cell as? ScondCartReviewTVCell, index: indexPath.row - 1)
            }
        } else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "FifthCartReviewTVCell", for: indexPath) as? FifthCartReviewTVCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: sixthCellIdentifier, for: indexPath) as? SixthCartReviewTVCell
            congigureSixthCell(cell: cell!)
            return cell!
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let addressData = userAddressDataSource[indexPath.row - 1]
            guard let addressid = addressData.id else {
                return
            }
            self.deleteDeliveryAddress(addressId: addressid)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            if indexPath.row == 0 || indexPath.row == userAddressDataSource.count + 1 {
                return false
            } else if userAddressDataSource[indexPath.row - 1].id == loggedInUserAddress?.id {
                return false
            }
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
extension CartReviewVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == userAddressDataSource.count + 1 {
            return
        }
        
        if selectedAddress == nil {
            if let index = userAddressDataSource.index(where: { $0.defaultaddress == "1" }) {
                let toBeUnSelectIndexPath = IndexPath(row: index + 1, section: indexPath.section)
                if let cell = self.mDetailTableView.cellForRow(at: toBeUnSelectIndexPath) as? ScondCartReviewTVCell {
                        cell.addBorderToSelectedAddress(isDefault: indexPath == toBeUnSelectIndexPath ? true : false)
                }
            }
        } else {
            if userAddressDataSource[indexPath.row - 1].id != selectedAddress?.id, let index = userAddressDataSource.index(where: { $0.id == selectedAddress?.id }) {
                let toBeUnSelectIndexPath = IndexPath(row: index + 1, section: indexPath.section)
                self.updateUserAddressDataSource(isDefault: false, at: toBeUnSelectIndexPath.row)
                if let cell = self.mDetailTableView.cellForRow(at: toBeUnSelectIndexPath) as? ScondCartReviewTVCell {
                    cell.addBorderToSelectedAddress(isDefault: false)
                }
            }
        }
        self.selectedAddress = userAddressDataSource[indexPath.row - 1]
        self.updateUserAddressDataSource(isDefault: true, at: indexPath.row)
        if let cell = self.mDetailTableView.cellForRow(at: indexPath) as? ScondCartReviewTVCell {
           cell.addBorderToSelectedAddress(isDefault: true)
        }
    }
}
extension CartReviewVC {
    fileprivate func updateUserAddressDataSource(isDefault: Bool, at index: Int) {
        self.selectedAddress?.tempDefaultaddress = isDefault ? "1" : "0"
        userAddressDataSource[index - 1] = selectedAddress!
    }
}
extension CartReviewVC {
    
    fileprivate func configureAddressCell(cell: ScondCartReviewTVCell?, index: Int) {
        print("Unselected Index: \(index)")
        cell?.cellViewModel = userAddressDataSource[index]
        DispatchQueue.main.async { [weak cell] in
            cell?.setEditButtonTag(tag: index + 1)
        }
        cell?.editActionHandler = { [weak self] Data in
            self?.performSegue(withIdentifier: "toDeliveryAddress", sender: Data - 1)
        }
    }
    fileprivate func configureFourthCell(cell: FourthCartReviewTVCell?) {
        if let aCell = cell {
            aCell.addAddressClouser = { [weak self] in
                self?.performSegue(withIdentifier: "toDeliveryAddress", sender: self)
            }
        }
    }
    
    fileprivate func congigureSixthCell(cell: SixthCartReviewTVCell) {
        var totalPoints = 0
        if let totalPoint = UserProfileUtilities.getUserDetails()?.TotalPoints, let totalPointInInt = Int(totalPoint) {
            totalPoints = totalPointInInt
        }
        var redeemablePoints = 0
        if let actualPoints = productInfo?.points {
            redeemablePoints = actualPoints * (productInfo?.Quantity)!
        }
        var productName = ""
        if let name = productInfo?.ItemName {
            productName = name
        }
        var imagePath = ""
        if let path = productInfo?.imagePath {
            imagePath = path
        }
        
        cell.cellModel = SixthCartReviewTVCellModel(productPoints: redeemablePoints, productName: productName, productImagePath: imagePath, totalUserPoints: totalPoints)
    }
}
