//
//  ProductListVC.swift
//  PayBack
//
//  Created by Dinakaran M on 06/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ProductListVC: BaseViewController {
    fileprivate var filteredData: [String: String] = [:]
    fileprivate var sortedByBurn: SortBy = .None
    fileprivate var sortedByEarn: String = ""
    fileprivate let cellIdentifier = "productCell"
    
    @IBOutlet weak fileprivate var navView: DesignableNav!
    @IBOutlet weak fileprivate var filterlabelCount: UILabel!
    @IBOutlet weak fileprivate var filterlabl: UILabel!
    @IBOutlet weak fileprivate var tableview: UITableView!
    @IBOutlet weak fileprivate var sortlabel: UILabel!
    @IBOutlet weak fileprivate var noProductLabel: UILabel!
    @IBOutlet weak fileprivate var sortButton: UIButton!
    @IBOutlet weak fileprivate var filterButton: UIButton!
    @IBOutlet weak fileprivate var sortView: UIView!
    @IBOutlet weak fileprivate var filterView: UIView!
    @IBOutlet weak fileprivate var sortFilterViewHeightConstraint: NSLayoutConstraint!
    
    fileprivate var productListLandingType: ProductType = .none
    fileprivate var sortPopUpView: PBProductSortPopupView?
    fileprivate var productListNWController: ProductListNetworkController!
    fileprivate var productListViewModel: ProductListVM!
    fileprivate var navTitle: String? = ""
    fileprivate var fromRange: Int = 0
    fileprivate var toRange: Int = 0
    fileprivate var filterStatus: Bool = false
    fileprivate var productname: String = ""
    
    var productListRequestParams: (searchText: String, categoryPath: String, category: ProductCategory, productListLandingType: ProductType, productName: String)? {
        didSet {
            guard let productListRequestParams = productListRequestParams else {
                return
            }
            productname = productListRequestParams.productName
            self.productListLandingType = productListRequestParams.productListLandingType
            self.startActivityIndicator()
            productListNWController = ProductListNetworkController()
            productListViewModel = ProductListVM(networkController: productListNWController, productListRequestParams: productListRequestParams)
            
            self.productListViewModel.bindToProductListViewModels = { [unowned self] in
                self.showNoProduct()
                self.keepSliderRangeInitialValue()
                self.tableview.reloadData()
            }
            self.productListViewModel.onError(error: { [weak self] (error) in
                self?.stopActivityIndicator()
                self?.showErrorView(errorMsg: error)
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableViewAutomaticDimension
        self.filterlabl.font = FontBook.Regular.of(size: 15.0)
        self.filterlabl.textColor = ColorConstant.textColorPointTitle
        self.sortlabel.font = FontBook.Regular.of(size: 15.0)
        self.sortlabel.textColor = ColorConstant.textColorPointTitle
        self.filterlabelCount.font = FontBook.Bold.ofNotificationLabelSize()
        self.filterlabelCount.backgroundColor = ColorConstant.primaryColorPink
        self.filterlabelCount.isHidden = true
        self.filterlabelCount.text = "0"
        self.navView.title = productname.uppercased()
        self.noProductLabel.textColor = self.navView.backgroundColor
        self.noProductLabel.font = FontBook.Regular.ofTitleSize()
        self.view.backgroundColor = ColorConstant.backgroundViewColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        if self.productListViewModel != nil {
            self.productListViewModel.invalidateObservers()
        }
        print("ProductListVC: deinit called")
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
    @IBAction func sortAction(_ sender: Any) {
        openSortPopUP()
    }
    @IBAction func filterAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toFilter", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilter", let productFilter = segue.destination as? ProductSearchFilterVC {
            productFilter.fromRange = fromRange
            productFilter.toRange = toRange
            productFilter.priceRange = self.productListViewModel.getPriceRange()
            productFilter.productListLandingType = productListLandingType
            
            if let filter = self.productListViewModel.getFilterModel() {
                productFilter.allFilterCellModel = filter
                productFilter.filterData = self.filteredData
            }
            productFilter.selectedFilters = { [weak self] (filterData) in
                self?.filterDataUpdate(filteredData: filterData)
                self?.filteredData = filterData
                self?.filteredData["sort"] = self?.productListLandingType == .burnProduct  ? self?.sortedByBurn.rawValue : self?.sortedByEarn
                self?.applySortAndFilter()
            }
        }
    }
}
extension ProductListVC {
    fileprivate func showNoProduct() {
        if self.productListViewModel.dataSource.isEmpty {
            if !self.filterStatus {
                self.sortButton.isEnabled(state: false)
                self.filterButton.isEnabled(state: false)
                sortView.isHidden = true
                filterView.isHidden = true
                sortFilterViewHeightConstraint.constant = 0
            }
            self.noProductLabel.isHidden = false
            self.tableview.isHidden = true
        } else {
            self.noProductLabel.isHidden = true
            self.tableview.isHidden = false
        }
        self.stopActivityIndicator()
    }
    fileprivate func keepSliderRangeInitialValue() {
        guard let filterModel = self.productListViewModel.getFilterModel(), !filterModel.isEmpty else {
            self.filterButton.isEnabled(state: false)
            self.filterlabl.text = "No Filter"
            return
        }
        if !self.filterStatus {
            guard productListLandingType == .burnProduct else {
                if let priceRange = self.productListViewModel.getPriceRange() {
                    self.fromRange = priceRange.min ?? 0
                    self.toRange = priceRange.max ?? 0
                }
                self.filterStatus = true
                return
            }
            let points = filterModel.filter { $0.title == "Points Range" }
            if points.count >= 1 {
                if let values = points[0].values, let min = Int(values[0].valueId), let max = Int(values[1].valueId) {
                    self.fromRange = min
                    self.toRange = max
                }
            }
            self.filterStatus = true
        }
    }
    
    fileprivate func filterDataUpdate(filteredData: [String: String]) {
        print(filteredData)
        var tempListArr: [String] = []
        for (key, value) in filteredData {
            if key == "min" || key == "max" || key == "sort" {
                print(value)
            } else {
                if value.length > 0 {
                    tempListArr += value.components(separatedBy: ",")
                }
            }
        }
        if let min = filteredData["min"], let max = filteredData["max"] {
            let minInt = min
            let maxInt = max
            if minInt != String(self.fromRange) || maxInt != String(self.toRange) {
                tempListArr.append("slider range")
            }
        }
        
        if !tempListArr.isEmpty {
            self.filterlabelCount.isHidden = false
            self.filterlabelCount.text = "\(tempListArr.count)"
        } else {
            self.filterlabelCount.isHidden = true
        }
    }
    
    fileprivate func openSortPopUP() {
        sortPopUpView = Bundle.main.loadNibNamed("PBProductSortPopupView", owner: self, options: nil)?.first as? PBProductSortPopupView
        guard let keyWindow = APP_DEL?.window, let sortPopup = sortPopUpView else {
            return
        }
        sortPopup.set(sortOption: sortedByBurn, moduleType: productListLandingType)
        if let sortModel = productListViewModel.getSortByModel() {
            sortPopup.cellModel = sortModel
        }
        keyWindow.addSubview(sortPopUpView!)
        keyWindow.addConstraintsWithFormat("H:|[v0]|", views: sortPopup)
        keyWindow.addConstraintsWithFormat("V:|[v0]|", views: sortPopup)
        popClouserAction()
    }
    
    fileprivate func popClouserAction() {
        if let sortModel = productListViewModel.getSortByModel() {
            let height = sortModel.count * 50 + 50
            sortPopUpView?.setHeight(height: height)
        }
        
        sortPopUpView?.closeButtonClouser = { [weak self] in
            self?.sortPopUpView?.removeFromSuperview()
        }
        sortPopUpView?.sortClouser = { [weak self] (sortBy) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.sortedByBurn = sortBy
            strongSelf.filteredData["sort"] = sortBy.rawValue
            strongSelf.applySortAndFilter()
        }
        sortPopUpView?.sortByClouser = { [weak self] (sortBy) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.sortedByEarn = sortBy
            strongSelf.filteredData["sort"] = sortBy
            strongSelf.applySortAndFilter()
        }
    }
    private func applySortAndFilter() {
        self.startActivityIndicator()
        self.productListViewModel
            .onSuccess { [weak self] in
                self?.scrollToTop()
            }
            .onError(error: { [weak self] (error) in
                self?.stopActivityIndicator()
                self?.showErrorView(errorMsg: error)
            })
            .applyFilterAndLoadMore(skip: "0", isLoadMore: false, filteredDict: self.filteredData)
    }
    fileprivate func scrollToTop() {
        DispatchQueue.main.async {
            let numberOfRows = self.tableview.numberOfRows(inSection: 0)
            if numberOfRows > 0 {
                self.tableview.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
            }
        }
    }
}

extension ProductListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let product = self.productListViewModel.product(at: indexPath.row)
        guard let productId = product.productID, productId != "" else {
            self.showErrorView(errorMsg: StringConstant.productDetailsMissing)
            return
        }
        
        switch productListLandingType {
        case .earnProduct:
            guard product.itemType == "product" else {
                if let urlString = product.appDeepLink {
                    self.redirectVC(redirectLink: urlString, redirectLogoUrl: product.storeLogo ?? "")
                }
                return
            }
            let storyboard = UIStoryboard(name: "Earn", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EarnProductDetailsVC") as? EarnProductDetailsVC
            vc?.productID = productId
            self.navigationController?.pushViewController(vc!, animated: true)
           
        case .burnProduct:
            let storyboard = UIStoryboard(name: "Burn", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BurnProductDetailVC") as? BurnProductDetailVC
            vc?.productID = productId
            self.navigationController?.pushViewController(vc!, animated: true)
        default:
            break
        }
    }
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        isDataLoading = false
//    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//        if (tableview.contentOffset.y + tableview.frame.size.height) >= tableview.contentSize.height {
//            if !isDataLoading, self.skip < self.totalProductCount {
//                isDataLoading = true
//                self.skip += 10
//                applyFilterAndLoadMore(skip: String(self.skip), isLoadMore: true)
//            }
//        }
//    }
}
extension ProductListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productListViewModel != nil ? self.productListViewModel.dataSource.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProductListCell
        cell?.productCellModel = self.productListViewModel.product(at: indexPath.row)
        return cell!
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastId = productListViewModel.last()
        if indexPath.row == lastId - 3, lastId < productListViewModel.totalCount() {
            self.productListViewModel.applyFilterAndLoadMore(skip: String(lastId), isLoadMore: true, filteredDict: filteredData)
        }
    }
}
