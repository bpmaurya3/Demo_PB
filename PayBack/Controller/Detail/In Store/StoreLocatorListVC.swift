//
//  StoreLocatorListVC.swift
//  PayBack
//
//  Created by Dinakaran M on 12/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
import MapKit

class StoreLocatorListVC: BaseViewController {

    var sourceData: [Any] = []
    
    fileprivate var sortPopUpView: StoreLocaterSortPopupView?
  
    @IBOutlet weak private var sortLabel: UILabel!
    @IBOutlet weak private var filterLabel: UILabel!
    @IBOutlet weak private var filteredCountLabel: UILabel!
    private var sortBy: StoreLocaterSortBy = .None
    var viewModel: InStoreListVM!
    fileprivate var currentLocation: CLLocation?
    var filterCount = 0
    fileprivate var filteredData: [String: String] = [:]
    fileprivate var noDataText = ""
    
    fileprivate func fetchData() {
        if let loc = LocationManager.sharedLocationManager.currectUserLocation {
            currentLocation = loc
        }
        let filter = getFilter()
        if let currentLoc = currentLocation {
            fetchData(atLocation: currentLoc, filter: filter)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel.getStoreList().isEmpty {
            fetchData()
        }
        self.sortLabel.textColor = ColorConstant.textColorBlack
        self.sortLabel.font = FontBook.Regular.ofSegmentTapTitleSize()
        self.filterLabel.textColor = ColorConstant.textColorBlack
        self.filterLabel.font = FontBook.Regular.ofSegmentTapTitleSize()
        self.filteredCountLabel.textColor = ColorConstant.textColorWhite
        self.filteredCountLabel.backgroundColor = ColorConstant.primaryColorPink
        
        updateFilterBadge()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: Cells.instoreListTVCell, bundle: nil), forCellReuseIdentifier: Cells.instoreListTVCell)
        tableView.register(NoDataFoundTVCell.self, forCellReuseIdentifier: Cells.noDataFoundTVCell)
        
    }
    
    private func updateFilterBadge() {
        filterCount = viewModel.filterCount
        filteredCountLabel.text = "\(filterCount)"
        self.filteredCountLabel.isHidden = self.filterCount == 0 ? true : false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFilterBadge()
        self.navigationController?.isNavigationBarHidden = false
        noDataText = ""
        self.reloadTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadList), name: Notification.Name(LocationFound), object: nil)
    }
    @objc private func reloadList() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(LocationFound), object: nil)
        fetchData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        cell?.textLabel?.text = ""
        NotificationCenter.default.removeObserver(self, name: Notification.Name(LocationFound), object: nil)
    }
    
    @IBOutlet weak private var tableView: UITableView!
    @IBAction func sortListAction(_ sender: Any) {
        print("Sorted List")
        openSortPopUP()
    }
    
    @IBAction func filterdListAction(_ sender: Any) {
        print("Fltered List")
        guard let filterVC = StoreLocatorFilterVC.storyboardInstance(storyBoardName: "InStore") as? StoreLocatorFilterVC else {
            return
        }
        filterVC.filterDataSource = self.viewModel.getFilterModel()
        filterVC.filteredData = self.filteredData
        filterVC.selectedPartners = {[weak self](filterDict) in
            self?.filteredData = filterDict
            self?.viewModel.filteredData = filterDict
            print(filterDict)
            self?.applyFilter()
        }
        self.navigationController?.pushViewController(filterVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(LocationFound), object: nil)
        print("Deinit - StoreLocatorListVC")
    }
    override func userLogedIn(status: Bool) {
        guard status else {
            return
        }
        if status, let link = redirectUrl, link != "" {
            self.redirectVC(redirectLink: link, redirectLogoUrl: self.partnerlogoUrl)
        } else {
            self.redirectUrl = ""
            self.partnerlogoUrl = ""
        }
    }
    private func reloadTableView() {
        self.tableView.reloadData()
    }
    private func fetchData(atLocation location: CLLocation, filter params: StoreLocaterFilterParameters) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        viewModel.onSuccess { [weak self] in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            DispatchQueue.main.async {
                self?.noDataText = self?.viewModel.getStoreListCount() == 0 ? StringConstant.No_Data_Found : ""
                self?.relodAndScrollToTop()
                self?.filteredCountLabel.text = "\(self?.filterCount ?? 0)"
                self?.filteredCountLabel.isHidden = self?.filterCount == 0 ? true : false
            }
            }
            .onError { (error) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print(error)
            }
            .fetchInStoreListNear(currentLocation: location.coordinate, filterParameters: params)
    }
    
    private func applyFilter() {
        let filter = getFilter()
        if let currentLoc = currentLocation {
            fetchData(atLocation: currentLoc, filter: filter)
        }
    }
    
    private func getFilter() -> StoreLocaterFilterParameters {
        let filteredData = self.viewModel.getSelectedFilterDataModel()
        let category = filteredData[StoreLocaterFilterKey.category.rawValue]
        let city = filteredData[StoreLocaterFilterKey.city.rawValue]
        let partner = filteredData[StoreLocaterFilterKey.partner.rawValue]
        let filter = StoreLocaterFilterParameters(category: category, city: city, partner: partner)
        if let catcount = category?.components(separatedBy: ",").count, let parcount = partner?.components(separatedBy: ",").count, let cicount = city?.components(separatedBy: ",").count {
            let a = (city?.isEmpty)! ? 0 :cicount
            let b = (category?.isEmpty)! ? 0 :catcount
            let c = (partner?.isEmpty)! ? 0 :parcount
            filterCount = a + b + c
            viewModel.filterCount = filterCount
        }
        return filter
    }
}
extension StoreLocatorListVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getStoreListCount() == 0 ? 1 : viewModel.getStoreListCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let data = viewModel.getCellModel(atIndex: indexPath.row) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.instoreListTVCell, for: indexPath) as? InstoreListTVCell else {
                return UITableViewCell()
            }
            cell.sourceData = data
            cell.set(distanceButtonTag: indexPath.row)
            cell.distanceActionClosure = { [weak self] (sender) in
                if let locations = data.storeLocations {
                    self?.openMap(locations, sender: sender)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.noDataFoundTVCell, for: indexPath)
            cell.textLabel?.text = noDataText
            return cell
        }
    }
}
extension StoreLocatorListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = viewModel.getCellModel(atIndex: indexPath.row), let url = data.url {
            self.redirectVC(redirectLink: url, redirectLogoUrl: data.imageUrl ?? "")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension StoreLocatorListVC {
    fileprivate func openSortPopUP() {
        sortPopUpView = Bundle.main.loadNibNamed("StoreLocaterSortPopupView", owner: self, options: nil)?.first as? StoreLocaterSortPopupView
        guard let keyWindow = APP_DEL?.window, let sortPopup = sortPopUpView else {
            return
        }
        sortPopUpView?.set(sortOption: sortBy)
        keyWindow.addSubview(sortPopUpView!)
        keyWindow.addConstraintsWithFormat("H:|[v0]|", views: sortPopup)
        keyWindow.addConstraintsWithFormat("V:|[v0]|", views: sortPopup)
        popClouserAction()
    }
    
    fileprivate func popClouserAction() {
        sortPopUpView?.closeButtonClouser = { [weak self] in
            self?.sortPopUpView?.removeFromSuperview()
        }
        sortPopUpView?.sortClouser = { [weak self] (sortBy) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.sortBy = sortBy
            strongSelf.viewModel.sortBy = sortBy
            strongSelf.relodAndScrollToTop()
        }
    }
    private func relodAndScrollToTop() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            self.reloadTableView()
            if self.viewModel.getStoreListCount() > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        })
    }
}
