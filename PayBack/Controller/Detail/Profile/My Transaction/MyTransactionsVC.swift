//
//  MyTransactionsVC.swift
//  PayBack
//
//  Created by Dinakaran M on 18/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class MyTransactionsVC: BaseViewController {
    @IBOutlet weak private var pointSummabryLbl: UILabel!
    @IBOutlet weak fileprivate var tableview: UITableView!
    @IBOutlet weak private var pointsTxtField: UITextField!
    @IBOutlet weak private var processTxtField: UITextField!
    @IBOutlet weak private var redeemableTxtField: UITextField!
    @IBOutlet weak private var expiringTxtField: UITextField!
    @IBOutlet weak private var paybackplus: UILabel!
    @IBOutlet weak private var pointredeem: UILabel!
    @IBOutlet weak private var pointsInDetails: UILabel!
    @IBOutlet weak private var pointsExpiring: UILabel!
    @IBOutlet weak private var redeemnowbutton: DesignableButton!
    @IBOutlet weak private var sortbutton: DesignableButton!
    @IBOutlet weak private var transactionDetailsTitleLbl: UILabel!

    fileprivate var myTransactionFetcher: MyTransactionFetcher!
    fileprivate var myTransactionRedeemNavFetcher: MyTransactionRedeemNavFetcher!
    fileprivate var redeemNavDetails: (TransactionsRedeemNavDetails.NavPageDetail)? {
        didSet {
            self.redeemnowbutton.setTitle(redeemNavDetails?.ctaButtonTxt, for: .normal)
        }
    }
    
    fileprivate var emptyCellText: String!
    var totalCount = 0
    fileprivate var lastId = 0
    fileprivate var filterData: [String: String] = [:]
    
    fileprivate var sourceData: [MyTransactionTVCellModel] = [] {
        didSet {
            self.lastId = sourceData.count
            if sourceData.isEmpty {
                emptyCellText = StringConstant.No_Data_Found
            }
            self.tableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupTextFields()
        myTransactionRedeemNavFetcher = MyTransactionRedeemNavFetcher()
        myTransactionFetcher = MyTransactionFetcher()
        emptyCellText = ""
        if self.checkConnection() {
            self.getTransactionDetails()
        }
    }
    override func connectionSuccess() {
        self.getTransactionDetails()
    }
    override func userLogedIn(status: Bool) {
        print("From My transaction - User Loged In Success")
        if status {
             self.getTransactionDetails()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        print("Deinit - MyTransactionsVC")
    }
}
extension MyTransactionsVC {
    fileprivate func setupTableView() {
        tableview.register(UINib(nibName: Cells.myTransactionVTVCell, bundle: nil), forCellReuseIdentifier: Cells.myTransactionVTVCell)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "EmptyCell")
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.tableFooterView = UIView(frame: .zero)
    }
    fileprivate func setupTextFields() {
        self.pointSummabryLbl.textColor = ColorConstant.textColorPointTitle
        self.pointSummabryLbl.font = FontBook.Bold.of(size: 15)
        
        self.paybackplus.textColor = ColorConstant.textColorPointTitle
        self.paybackplus.font = FontBook.Regular.of(size: 11.0)
        
        self.pointredeem.textColor = ColorConstant.textColorPointTitle
        self.pointredeem.font = FontBook.Regular.of(size: 11.0)
        
        self.pointsExpiring.textColor = ColorConstant.textColorPointTitle
        self.pointsExpiring.font = FontBook.Regular.of(size: 11.0)
        
        self.pointsInDetails.textColor = ColorConstant.textColorPointTitle
        self.pointsInDetails.font = FontBook.Regular.of(size: 11.0)
        
        pointsTxtField.textColor = ColorConstant.textColorPointTitle
        pointsTxtField.backgroundColor = ColorConstant.mytransactionPointsBGColor
        pointsTxtField.layer.addBorder(edge: .all, color: ColorConstant.mytransactionPointsBorderColor, thickness: 1)
        
        processTxtField.textColor = ColorConstant.textColorPointTitle
        processTxtField.backgroundColor = ColorConstant.mytransactionPointsBGColor
        processTxtField.layer.addBorder(edge: .all, color: ColorConstant.mytransactionPointsBorderColor, thickness: 1)
        
        redeemableTxtField.textColor = ColorConstant.textColorPointTitle
        redeemableTxtField.backgroundColor = ColorConstant.mytransactionPointsBGColor
        redeemableTxtField.layer.addBorder(edge: .all, color: ColorConstant.mytransactionPointsBorderColor, thickness: 1)
        
        expiringTxtField.textColor = ColorConstant.textColorPointTitle
        expiringTxtField.backgroundColor = ColorConstant.mytransactionPointsBGColor
        expiringTxtField.layer.addBorder(edge: .all, color: ColorConstant.mytransactionPointsBorderColor, thickness: 1)
        
        self.redeemnowbutton.titleLabel?.textColor = ColorConstant.textColorWhite
        self.redeemnowbutton.backgroundColor = ColorConstant.primaryColorPink
        self.redeemnowbutton.titleLabel?.font = FontBook.Regular.ofButtonTitleSize()
        self.sortbutton.backgroundColor = ColorConstant.primaryColorPink
        self.sortbutton.titleLabel?.font = FontBook.Regular.of(size: 13)
        self.sortbutton.borderColor = ColorConstant.primaryColorPink
        //self.sortbutton.isEnabled(state: false)
        self.transactionDetailsTitleLbl.textColor = ColorConstant.textColorPointTitle
        self.transactionDetailsTitleLbl.font = FontBook.Bold.of(size: 15)
    }
}
extension MyTransactionsVC: UIPopoverPresentationControllerDelegate {
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func paybackPointsInfo(_ sender: Any) {
        guard let view = sender as? UIView else {
            return
        }
        showPopover(withInfo: TransactionPointsInfo.totalPoints.rawValue, fromView: view)
    }
    @IBAction func redeemableInfo(_ sender: Any) {
        guard let view = sender as? UIView else {
            return
        }
        showPopover(withInfo: TransactionPointsInfo.redeemablePoints.rawValue, fromView: view)
    }
    @IBAction func processInfo(_ sender: Any) {
        guard let view = sender as? UIView else {
            return
        }
        showPopover(withInfo: TransactionPointsInfo.pointsInProcess.rawValue, fromView: view)
    }
    
    @IBAction func expiringInfo(_ sender: Any) {
        guard let view = sender as? UIView else {
            return
        }
        showPopover(withInfo: TransactionPointsInfo.expiringPoints.rawValue, fromView: view)
    }
    
    private func showPopover(withInfo info: String, fromView view: UIView) {
        print("Info button: \(info)")
        guard let vc = PopOverVC.storyboardInstance(storyBoardName: "Profile") as? PopOverVC else {
            return
        }
        vc.modalPresentationStyle = .popover
        let stringSize = info.size(OfFont: UIFont.systemFont(ofSize: 16))
        vc.preferredContentSize = CGSize(width: stringSize.width + 30, height: stringSize.height + 25)
        let popover = vc.popoverPresentationController
        popover?.delegate = self
        popover?.backgroundColor = UIColor(red: 231.0 / 255.0, green: 16.0 / 255.0, blue: 108.0 / 255.0, alpha: 1)
        popover?.permittedArrowDirections = .down
        popover?.sourceView = view
        popover?.sourceRect = CGRect(x: view.frame.width / 2, y: 0, width: 0, height: 0)
        present(vc, animated: true, completion: nil)
        vc.setPopoverInfo(info)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @IBAction func redeemNowAction(_ sender: Any) {
        guard let detail = self.redeemNavDetails else {
            return
        }
        if let navigateTo = detail.navigateTo {
            switch navigateTo {
            case TransactionRedeemNavType.RewardsCatalogue.rawValue:
                self.pushToRewardCatelogueVC()
            case TransactionRedeemNavType.VoucherWorld.rawValue:
                self.pushToVoucherWorldVC()
            default:
                break
            }
        }
    }
    
    @IBAction func sortAction(_ sender: Any) {
        print("Sort Clicked")
        guard let sortVC = MyTransactionSortVC.storyboardInstance(storyBoardName: "Profile") as? MyTransactionSortVC else {
            return
        }
        sortVC.filterData = self.filterData
        sortVC.applyTransactionFilter = { [weak self] filterData in
            print("\(filterData)")
            self?.startActivityIndicator()
            self?.filterData = filterData
            self?.fetchTransaction(isLoadMore: false)
        }
        self.navigationController?.pushViewController(sortVC, animated: true)
    }
}
extension MyTransactionsVC {
    fileprivate func getTransactionDetails() {
        self.startActivityIndicator()
        self.fetchRedeemNavDetails()
        self.updateTransactionDetails()
        self.fetchTransaction(isLoadMore: false, isFilter: false)
    }
    fileprivate func updateTransactionDetails() {
        let  userDetails = UserProfileUtilities.getUserDetails()
        
        if let totalPoints = userDetails?.TotalPoints {
            self.pointsTxtField.text = totalPoints
        } else {
            self.pointsTxtField.text = ""
        }
        
        if let availabelPoints = userDetails?.AvailablePoints {
            self.redeemableTxtField.text = availabelPoints
        } else {
            self.redeemableTxtField.text = ""
        }
        
        if let blockedPoints = userDetails?.BlockedPoints {
            self.processTxtField.text = blockedPoints
        } else {
            self.processTxtField.text = ""
        }
        
        if let expiringPoints = userDetails?.PointsToExpireAmount {
            self.expiringTxtField.text = expiringPoints
        } else {
            self.expiringTxtField.text = ""
        }
    }
    fileprivate func updateSignInPopUp(typeCodeMsg: String) {
        self.onLoginSuccess { [weak self] in
            self?.updateTransactionDetails()
            }
            .onLoginError(error: {  [weak self] (error) in
                self?.showErrorView(errorMsg: "\(error) - please try to SignIn")
            })
            .signInPopUp()
    }
    fileprivate func setSourceData(transactionData: GetMyTransactions?, isLoadMore: Bool) {
        if isLoadMore == false {
            self.sourceData.removeAll()
        }
        guard let transactionData = transactionData else {
            return
        }
        var transactionArray: [MyTransactionTVCellModel] = [MyTransactionTVCellModel]()
        self.totalCount = Int(transactionData.extintTotalResultSize ?? "") ?? 0
        self.totalCount = self.totalCount > 30 ? 30 : self.totalCount
        guard let transactionEvents = transactionData.extintAccountTransactionEvent  else {
            return
        }
        for dataModel in transactionEvents {
            let dateInString = Utilities.getDayMonthYear(date: dataModel.typesActivityDate ?? "")
            let data = MyTransactionTVCellModel(tID: dataModel.typesReceiptNumber, date: dateInString, partner: dataModel.typesPartner?.typesPartnerDisplayName, points: dataModel.typesAccountTransactionDetails?.typesValue?.typesLoyaltyAmount, type: dataModel.typesAccountTransactionDetails?.typesDescription)
            transactionArray.append(data)
        }
        self.sourceData += transactionArray
    }
}
extension MyTransactionsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceData.isEmpty ? 1 : sourceData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if sourceData.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
            cell.textLabel?.text = emptyCellText
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = ColorConstant.navigationViewColor
            return cell
        }
       // let data = MyTransactionTVCellModel(tID: "123456678886", date: "15 Aug", partner: "Amazon", points: "1987", type: "BURN")
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.myTransactionVTVCell, for: indexPath) as? MyTransactionTVCell
        cell?.setBackgroundColor(atIndex: indexPath.item)
        cell?.sourceData = sourceData[indexPath.row] //data//
        return cell!
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == lastId - 3, lastId < self.totalCount {
            self.fetchTransaction(isLoadMore: true)
        }
    }
}
extension MyTransactionsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
extension MyTransactionsVC {
    fileprivate func fetchTransaction(isLoadMore: Bool, isFilter: Bool = true) {
        let filter: TransactionFilerTuple = (brand: filterData["Partners"] ?? "", type: filterData["Transaction Type"] ?? "", fromDate: filterData["FromDate"] ?? "", toDate: filterData["ToDate"] ?? "")
        if UserProfileUtilities.getAuthenticationToken() != "" {
            let page = lastId / 10 + 1
            myTransactionFetcher
                .onSuccess { [weak self] (modelData) in
                    if !isFilter && modelData.extintTotalResultSize == nil {
                        self?.sortbutton.isEnabled(state: false)
                    }
                    self?.setSourceData(transactionData: modelData, isLoadMore: isLoadMore)
                    self?.stopActivityIndicator()
                }
                .onTokenExpired { [weak self] in
                    self?.updateSignInPopUp(typeCodeMsg: "Invalid Token")
                    self?.stopActivityIndicator()
                }
                .onError { [weak self] (error) in
                    if !isFilter {
                        self?.sortbutton.isEnabled(state: false)
                    }
                    self?.setSourceData(transactionData: nil, isLoadMore: isLoadMore)
                    self?.showErrorView(errorMsg: error)
                    self?.stopActivityIndicator()
                }
                .getTransactionDetails(page: "\(page)", pageSize: "10", filter: filter)
        }
    }
    
    fileprivate func fetchRedeemNavDetails() {
        myTransactionRedeemNavFetcher
            .onSuccess {[weak self] (redeemNavDetails) in
                if let strongSelf = self {
                    strongSelf.redeemNavDetails = redeemNavDetails.navPageDetails
                }
            }
            .onError { (error) in
                print(error)
            }
            .getTransactionRedeemNavDetails()
    }
}

extension MyTransactionsVC {
    private func pushToRewardCatelogueVC() {
        let storyBoard = UIStoryboard(name: "Burn", bundle: nil)
        let rewardsCatalogueVC = storyBoard.instantiateViewController(withIdentifier: "RewardsCatalogueVC") as? RewardsCatalogueVC
        self.navigationController?.pushViewController(rewardsCatalogueVC!, animated: true)
    }
    
    private func pushToVoucherWorldVC() {
        let burn_VoucherWorld = PoliciesVC.storyboardInstance(storyBoardName: "Profile") as? PoliciesVC
        burn_VoucherWorld?.type = .voucherWorld
        self.navigationController?.pushViewController(burn_VoucherWorld!, animated: true)
    }
}
