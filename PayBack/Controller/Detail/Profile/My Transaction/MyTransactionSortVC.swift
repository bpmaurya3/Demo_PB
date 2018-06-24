//
//  MyTransactionSortVC.swift
//  PayBack
//
//  Created by Dinakaran M on 22/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class MyTransactionSortVC: UIViewController {

    fileprivate var sourceData: [MyTransactionSortTVCellModel] = [MyTransactionSortTVCellModel]()
   // fileprivate var subItemsArray: [SearchFilterTVCellModel] = [SearchFilterTVCellModel]()
    
    @IBOutlet weak private var navView: UIView!
    fileprivate var cellIdentifier = "MyTransactionSortTVCell"
    @IBOutlet weak private var todateborderView: UIView!
    @IBOutlet weak private var dateBorderView: UIView!
    @IBOutlet weak fileprivate var tableview: UITableView!
    @IBOutlet weak private var fromDateTxtField: UITextField!
    @IBOutlet weak private var toDateTextField: UITextField!
    @IBOutlet weak private var applybutton: UIButton!
    fileprivate var shouldApplyButtonEnableDisable = true
    var filterData: [String: String] = [:]
    fileprivate var minimumDate: Date?
    fileprivate var maximumDate: Date?
    fileprivate var fromStartDate: Date?
    fileprivate var toStartDate: Date?
    
    var applyTransactionFilter: ([String: String]) -> Void = { _ in }
    
    @IBOutlet weak private var tolabel: UILabel!
    @IBOutlet weak private var fromlabel: UILabel!
    @IBOutlet weak private var navClear: UIButton!
    @IBOutlet weak private var navTitle: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navView.backgroundColor = ColorConstant.backgroudColorBlue
        self.navClear.titleLabel?.font = FontBook.Bold.ofNavigationBarTitleSize()
        self.navTitle.font = FontBook.Bold.ofNavigationBarTitleSize()
        self.tolabel.font = FontBook.Regular.of(size: 15.0)
        self.fromlabel.font = FontBook.Regular.of(size: 15.0)
        self.applybutton.titleLabel?.font = FontBook.Bold.ofButtonTitleSize()
        self.applybutton.titleLabel?.textColor = ColorConstant.textColorWhite
        self.applybutton.backgroundColor = ColorConstant.primaryColorPink
        dateBorderView.layer.borderWidth = 1
        dateBorderView.layer.borderColor = UIColor(red: 233 / 255, green: 233 / 255, blue: 233 / 255, alpha: 1.0).cgColor
        
        todateborderView.layer.borderWidth = 1
        todateborderView.layer.borderColor = UIColor(red: 233 / 255, green: 233 / 255, blue: 233 / 255, alpha: 1.0).cgColor
        
        tableview.estimatedRowHeight = 120
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.tableFooterView = UIView(frame: .zero)
        
        fromDateTxtField.text = filterData["FromDate"]?.dateString(fromFormat: "yyyy-MM-dd", toFormat: "dd/MM/yyyy")
        toDateTextField.text = filterData["ToDate"]?.dateString(fromFormat: "yyyy-MM-dd", toFormat: "dd/MM/yyyy")
        self.enableApplyButton()
        if filterData["FromDate"] != nil || filterData["ToDate"] != nil {
            shouldApplyButtonEnableDisable = false
        }
        fromStartDate = filterData["FromDate"]?.dateFromString(format: "yyyy-MM-dd")
        toStartDate = filterData["ToDate"]?.dateFromString(format: "yyyy-MM-dd")
        maximumDate = toStartDate
        minimumDate = fromStartDate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    deinit {
        print("Deinit - MyTransactionSortVC")
    }
}
extension MyTransactionSortVC {
    @IBAction func applyAction(_ sender: Any) {
        print("Apply Action")
        if toDateTextField.text != "" && fromDateTxtField.text == "" {
            self.showErrorView(errorMsg: "Please enter start date")
            return
        }
        
        if let fromDateString = fromDateTxtField.text, fromDateString != "" {
            filterData["FromDate"] = fromDateString.dateString(fromFormat: "dd/MM/yyyy", toFormat: "yyyy-MM-dd")
        }
        if let toDateString = toDateTextField.text, toDateString != "" {
            filterData["ToDate"] = toDateString.dateString(fromFormat: "dd/MM/yyyy", toFormat: "yyyy-MM-dd")
        }
        applyTransactionFilter(filterData)
        self.backAction(self)
    }
    @IBAction func clearAction(_ sender: UIButton) {
        self.toDateTextField.text = ""
        self.fromDateTxtField.text = ""
        if shouldApplyButtonEnableDisable {
            enableApplyButton()
        }
        filterData.removeAll()
        fromStartDate = filterData["FromDate"]?.dateFromString(format: "yyyy-MM-dd")
        toStartDate = filterData["ToDate"]?.dateFromString(format: "yyyy-MM-dd")
        maximumDate = toStartDate
        minimumDate = fromStartDate
        for source in sourceData {
            for partner in source.partnerslist {
                let tempPartner = partner
                tempPartner.state = false
            }
        }
        self.tableview.reloadData()
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func calenderAction(_ sender: Any) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.addTarget(self, action: #selector(self.fromDatePickerValueChanged), for: UIControlEvents.valueChanged)
        datePickerView.maximumDate = Date()
        if let max = maximumDate {
            datePickerView.maximumDate = max
        }
        if let startDate = fromStartDate {
             datePickerView.date = startDate
        }
        let popoverView = UIView()
        popoverView.backgroundColor = UIColor.clear
        popoverView.addSubview(datePickerView)
        
        let controller = UIViewController()
        controller.modalPresentationStyle = UIModalPresentationStyle.popover
        controller.view = popoverView
        controller.preferredContentSize = CGSize(width: 320, height: 216)
        
        let popController = controller.popoverPresentationController
        popController?.permittedArrowDirections = .any
        popController?.delegate = self
        popController?.sourceRect = self.fromDateTxtField.bounds
        popController?.sourceView = self.fromDateTxtField
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func toCalenderAction(_ sender: UIButton) {
        
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.addTarget(self, action: #selector(self.toDatePickerValueChanged), for: UIControlEvents.valueChanged)
        datePickerView.maximumDate = Date()
        if let min = minimumDate {
            datePickerView.minimumDate = min
        }
        if let startDate = toStartDate {
            datePickerView.date = startDate
        }
        let popoverView = UIView()
        popoverView.backgroundColor = UIColor.clear
        popoverView.addSubview(datePickerView)
        
        let controller = UIViewController()
        controller.modalPresentationStyle = UIModalPresentationStyle.popover
        controller.view = popoverView
        controller.preferredContentSize = CGSize(width: 320, height: 216)
        
        let popController = controller.popoverPresentationController
        popController?.permittedArrowDirections = .any
        popController?.delegate = self
        popController?.sourceRect = self.toDateTextField.bounds
        popController?.sourceView = self.toDateTextField
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func todateTextFieldAction(_ sender: Any) {
    }
    @IBAction func fromDtateTextFieldAction(_ sender: Any) {
    }
}
extension MyTransactionSortVC {
    @objc func fromDatePickerValueChanged(sender: UIDatePicker) {
        fromDateTxtField.text = sender.date.getDateString(withFormat: "dd/MM/yyyy")
        minimumDate = sender.date
        self.enableApplyButton()
    }
    @objc func toDatePickerValueChanged(sender: UIDatePicker) {
        toDateTextField.text = sender.date.getDateString(withFormat: "dd/MM/yyyy")
        maximumDate = sender.date
        self.enableApplyButton()
    }
    fileprivate func enableApplyButton() {
        if fromDateTxtField.text != "" || toDateTextField.text != "" || !filterData.isEmpty {
            self.applybutton.isEnabled(state: true)
        } else {
            self.applybutton.isEnabled(state: false)
        }
    }
}
extension MyTransactionSortVC {
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        if popoverPresentationController.sourceView == fromDateTxtField, fromDateTxtField.text == "" {
           self.fromDatePickerValueChanged(sender: UIDatePicker())
        } else if popoverPresentationController.sourceView == toDateTextField, toDateTextField.text == "" {
            self.toDatePickerValueChanged(sender: UIDatePicker())
        }
    }
}
extension MyTransactionSortVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MyTransactionSortTVCell
        cell?.sourceData = sourceData[indexPath.row]
        return cell!
    }
}
extension MyTransactionSortVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchFilterVC = SearchFilterVC.storyboardInstance(storyBoardName: "InStore") as? SearchFilterVC {
            let dataModel = sourceData[indexPath.row]
            guard let title = dataModel.name else {
                return
            }
            searchFilterVC.titleText = title
            searchFilterVC.searchBarHeight = 0
            searchFilterVC.tableviewTopSpace = 0
            searchFilterVC.subSourceData = dataModel.partnerslist
            self.navigationController?.pushViewController(searchFilterVC, animated: true)
            searchFilterVC.onDonePress(closure: {[weak self] selectedData in
                self?.filterData[title] = selectedData
                self?.tableview.reloadData()
                self?.enableApplyButton()
            })
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
extension MyTransactionSortVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
