//
//  SearchVC.swift
//  PayBack
//
//  Created by Dinakaran M on 19/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
class SearchVC: UIViewController {
    
    fileprivate let cellIdentifier = "SearchTVCell"
    @IBOutlet weak fileprivate var searchTextField: UITextField!
    @IBOutlet weak fileprivate var tableview: UITableView!
    
    @IBOutlet weak fileprivate var dropDownView: UIView!
    fileprivate var drop: PayBackDropDown!
    
    fileprivate var searchType = ProductType.earnProduct.rawValue
    fileprivate var isClearSearchResult = false
    
    fileprivate lazy var searchFetcher: SearchFetcher = {
        return SearchFetcher()
    }()
    
    var searchCellModel: [SearchTVCellModel] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableview.reloadData()
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        self.searchTextField.text = nil
        clearSearchResults()
    }
    
    private func clearSearchResults() {
        self.searchFetcher.cancelTask()

        self.searchCellModel.removeAll()
        DispatchQueue.main.async { [unowned self] in
            self.tableview.reloadData()
        }
    }
    
    @IBAction func editingChangeAction(_ sender: UITextField) {
        if let seachText = sender.text, !seachText.isEmpty {
            self.isClearSearchResult = false
            if self.searchType == ProductType.earnProduct.rawValue {
                self.search(searchText: seachText)
            } else {
                clearSearchResults()
            }
        } else {
            self.isClearSearchResult = true
            clearSearchResults()
        }
    }
    
    private func search(searchText: String) {
        self.searchFetcher
            .onSuccess(success: { [weak self] (searchResults) in
                var cellModelArray = [SearchTVCellModel]()
                guard let strongSelf = self else {
                    self?.searchCellModel = cellModelArray
                    return
                }
                if !strongSelf.isClearSearchResult {
                    for result in searchResults {
                        cellModelArray.append(SearchTVCellModel(withSearchResult: result))
                    }
                    strongSelf.searchCellModel = cellModelArray
                }
            })
            .onError(error: { [weak self] (error) in
                print("\(error)")
                self?.clearSearchResults()
            })
            .search(searchType: searchType, searchText: searchText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.estimatedRowHeight = 100
        self.tableview.rowHeight = UITableViewAutomaticDimension
        self.tableview.tableFooterView = UIView(frame: .zero)
        self.tableview.keyboardDismissMode = .onDrag
        searchTextField.returnKeyType = .search
        searchTextField.textColor = ColorConstant.textColorPointTitle
        searchTextField.font = FontBook.Regular.of(size: 15.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.removeIwishToView()
        super.viewWillDisappear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if drop == nil {
            addIwishToView()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print(" SearchVC: deinit called")
    }
}

// MARK: Drop Down

extension SearchVC {
    fileprivate func addIwishToView() {
        if #available(iOS 11.0, *) {
            drop = PayBackDropDown(frame: CGRect(origin: CGPoint(x: self.dropDownView.frame.origin.x, y: self.view.safeAreaInsets.top + 15), size: self.dropDownView.frame.size))
        } else {
            drop = PayBackDropDown(frame: CGRect(origin: CGPoint(x: self.dropDownView.frame.origin.x, y: 35), size: self.dropDownView.frame.size))
        }
        
        drop.placeholder = self.searchType == ProductType.earnProduct.rawValue ? "Earn" : self.searchType == ProductType.burnProduct.rawValue ? "Redeem" : self.searchType == ProductType.offerProduct.rawValue ? "Offer" : "I wish to"
        drop.options = ["Earn", "Redeem"]
        drop.tableHeight = CGFloat(drop.options.count * 30)
        drop.didSelect { [weak self] (option, index) in
            
            print("You just select: \(option) at index: \(index)")
            
            switch index {
            case 0:
                self?.searchType = ProductType.earnProduct.rawValue
            case 1:
                self?.searchType = ProductType.burnProduct.rawValue
            case 2:
                self?.searchType = ProductType.offerProduct.rawValue
            default:
                self?.searchType = ProductType.earnProduct.rawValue
            }
            self?.editingChangeAction((self?.searchTextField)!)
        }
        
        let window = UIApplication.shared.keyWindow
        window?.addSubview(drop)
    }
    
    fileprivate func removeIwishToView() {
        drop.resign()
        drop.removeFromSuperview()
        drop = nil
    }
}
extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text, text.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            return true
        }
        textField.resignFirstResponder()
        
        let category = (searchType == ProductType.earnProduct.rawValue) ? ProductCategory.mobileSearch : ProductCategory.none
        
        let isExist = self.getPreviousViewController(of: "ProductListVC")
        isExist?.removeFromParentViewController()
        
        let burnStoryboard = UIStoryboard(name: "Burn", bundle: nil)
        if let vc = burnStoryboard.instantiateViewController(withIdentifier: "ProductListVC") as? ProductListVC {
            vc.productListRequestParams = (text, "", category, ProductType(rawValue: searchType)!, text)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return true
    }
}
extension SearchVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCellModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchTVCell
        configureCell(cell: cell!, indexPath: indexPath)
        if searchCellModel.count > indexPath.row {
            cell?.sourceData = searchCellModel[indexPath.row]
        }
        return cell!
    }
}
extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTextField.resignFirstResponder()
        let model = searchCellModel[indexPath.row]
        let storyboard = UIStoryboard(name: "Earn", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EarnProductDetailsVC") as? EarnProductDetailsVC
        vc?.productID = model.itemId
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension SearchVC {
    fileprivate func configureCell(cell: SearchTVCell, indexPath: IndexPath) {
        
        let isFooterDisplay = indexPath.row == searchCellModel.count - 1 ? false : true
        let isDividerDisplay = indexPath.row == searchCellModel.count - 1 ? true : false
        
        cell
            .display(isFooterViewDisplay: isFooterDisplay)
            .display(isdividerViewDisplay: isDividerDisplay)
      
    }
}
