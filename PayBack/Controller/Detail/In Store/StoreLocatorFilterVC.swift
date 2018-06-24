//
//  StoreLocatorFilterVC.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 4/25/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit
enum StoreLocatorFilterType {
    case category
    case location
    case partner
}
class StoreLocatorFilterVC: UIViewController {
    @IBOutlet weak private var navBarTitle: UILabel!
    @IBOutlet weak private var navView: UIView!
    @IBOutlet weak private var segmentView: CustomSegmentView!
    @IBOutlet weak private var tableview: UITableView!
  
    @IBOutlet weak private var applyButton: UIButton!

    typealias ApplyClosure = (([String: String]) -> Void)
    var selectedPartners: ApplyClosure  = { _ in }
    let cellIdentifier = "SearchFilterTVCell"
    
    fileprivate var subSourceData: [SearchFilterTVCellModel] = []
    fileprivate var filteredArray: [SearchFilterTVCellModel] = []
    fileprivate var searchActive: Bool = false
    fileprivate var placeholderText: String = ""
    fileprivate var titleText: String = "FILTER"
    fileprivate var searchBarHeight: CGFloat = 56
    fileprivate var tableviewTopSpace: CGFloat = 20
    fileprivate var filterType: StoreLocatorFilterType!
    
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var tableviewTopSpaceConstraints: NSLayoutConstraint!
    @IBOutlet weak private var searchbarHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak private var subtitle: UILabel!
    
    var filterDataSource: [String: [SearchFilterTVCellModel]]?
    var filteredData: [String: String] = [:]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = filterDataSource, let subData = data["Category"] {
            subSourceData = subData
        }
        self.setSearchBarView()
        self.setUpTableview()
        self.searchBar.placeholder = "Search \(placeholderText)"
        
        self.subtitle.text = placeholderText
        self.subtitle.textColor = ColorConstant.textColorWhite
        self.subtitle.font = FontBook.Bold.ofNavigationBarTitleSize()
        
        self.navBarTitle.textColor = ColorConstant.textColorWhite
        self.navBarTitle.font = FontBook.Bold.ofNavigationBarTitleSize()
        self.navBarTitle.text = titleText
        
        self.applyButton.backgroundColor = ColorConstant.buttonBackgroundColorPink
        self.applyButton.titleLabel?.textColor = ColorConstant.textColorWhite
        self.applyButton.titleLabel?.font = FontBook.Regular.of(size: 15.0)
        
        self.tableviewTopSpaceConstraints.constant = tableviewTopSpace
        self.searchbarHeightConstraints.constant = searchBarHeight
        self.navView.backgroundColor = ColorConstant.backgroudColorBlue
        self.view.backgroundColor = ColorConstant.backgroundViewColor
        
         setupSegmentView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

        self.searchBar.text = nil
        self.reloadDataWithoutSearchText(searchText: "")
        self.searchActive = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    fileprivate func dropShadowOnSearchBarBottom() {
        let path = UIBezierPath(rect: searchBar.bounds)
        searchBar.layer.shadowPath = path.cgPath
        searchBar.layer.shadowColor = UIColor.lightGray.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        searchBar.layer.shadowOpacity = 1
        searchBar.layer.shadowRadius = 1.0
        searchBar.layer.masksToBounds = false
    }
    
    func setSearchBarView() {
        searchBar.backgroundColor = UIColor.white
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.setImage(UIImage(named: "searchicon"), for: .search, state: .normal)
        let textField = searchBar.value(forKey: "searchField") as? UITextField
        textField?.font = FontBook.Bold.of(size: 12.0)
        textField?.textColor = ColorConstant.textColorPointTitle
        textField?.attributedPlaceholder = NSAttributedString(string: "Search Partner Name",
                                                              attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {[weak self] in
            self?.dropShadowOnSearchBarBottom()
        }
    }
    
    func setUpTableview() {
        tableview.estimatedRowHeight = 150
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.tableFooterView = UIView(frame: .zero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        print("Denit - StoreLocatorFilterVC ")
    }
}
extension StoreLocatorFilterVC {
    @IBAction func backButtonAction(_ sender: Any) {
        guard let filterDatasource = filterDataSource else {
            return
        }
        for dataSource in filterDatasource {
            if let selectedFields = filteredData[dataSource.key]?.components(separatedBy: ",") {
                for value in dataSource.value {
                    if let name = value.partnerName {
                        value.state = selectedFields.contains(name) ? true : false
                    }
                }
            } else {
                for value in dataSource.value {
                    value.state = false
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearAction(_ sender: Any) {
        guard let filterDatasource = filterDataSource else {
            return
        }
        for dataSource in filterDatasource {
            for items in dataSource.value {
                items.state = false
            }
        }
        tableview.reloadData()
    }
    
    @IBAction func applyButtonAction(_ sender: Any) {
        guard let filterDatasource = filterDataSource else {
            return
        }
        for dataSource in filterDatasource {
            var selectedFields = ""
            let selectedArray = dataSource.value.filter({ $0.state == true })
            for (index, item) in selectedArray.enumerated() {
                selectedFields.append(item.partnerName ?? "")
                if index != selectedArray.count - 1 {
                    selectedFields.append(",")
                }
            }
            filteredData[dataSource.key] = selectedFields
        }
        self.selectedPartners(filteredData)
        self.navigationController?.popViewController(animated: true)
        print("Done Button Clicked")
    }
}
extension StoreLocatorFilterVC {
    private func setupSegmentView() {
        let segmentTitle1 = SegmentCollectionViewCellModel(image: nil, title: "Location", itemId: 1)
        let segmentTitle2 = SegmentCollectionViewCellModel(image: nil, title: "Category", itemId: 2)
        let segmentTitle3 = SegmentCollectionViewCellModel(image: nil, title: "Partners", itemId: 3)
        let title = [segmentTitle1, segmentTitle2, segmentTitle3]
        
        let config = SegmentCVConfiguration()
            .set(title: title)
            .set(isImageIconHidden: true)
            .set(selectedIndex: 0)
            .set(numberOfItemsPerScreen: 3)
            .set(textColor: ColorConstant.textColorBlack)
            .set(selectedIndexTextColor: ColorConstant.textColorPink)
            .set(fontandsize: FontBook.Regular.ofSegmentTapTitleSize())
        
        segmentView.configuration = config
        
        segmentView.configuration?.selectedCompletion = { [weak self] (sdf, index) in
            self?.searchBar.resignFirstResponder()
            self?.searchBar.text = nil
            if let strongSelf = self {
                print("Selected Seg Index \(index)")
                if index == 0 {
                    self?.filterType = .location
                    if let data = strongSelf.filterDataSource, let subData = data["City"] {
                        strongSelf.subSourceData = subData
                    }
                } else if index == 1 {
                    self?.filterType = .category
                    if let data = strongSelf.filterDataSource, let subData = data["Category"] {
                        strongSelf.subSourceData = subData
                    }
                } else {
                    self?.filterType = .partner
                    if let data = strongSelf.filterDataSource, let subData = data["Partner"] {
                        strongSelf.subSourceData = subData
                    }
                }
                strongSelf.tableview.reloadData()
                strongSelf.tableview.layoutIfNeeded()
                strongSelf.tableview.contentOffset = .zero
            }
        }
    }
}
extension StoreLocatorFilterVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive && !(searchBar.text?.isEmpty)! {
            return filteredArray.count
        }
        return subSourceData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchFilterTVCell
        var id: Int = 0
        if searchActive && !filteredArray.isEmpty {
            cell?.subFilterItems = filteredArray[indexPath.row]
            id = filteredArray[indexPath.row].id
        } else if !subSourceData.isEmpty {
            cell?.subFilterItems = subSourceData[indexPath.row]
            id = subSourceData[indexPath.row].id
        }
        cell?.set(optionButtonTag: id)
        cell?.updateSeletedState(closure: { [weak self] (selectedIndex, state)  in
            if self?.filterType == .location {
                if let sourceData = self?.subSourceData {
                    for model in sourceData {
                        model.state = model.id == selectedIndex ? true : false
                    }
                }
                self?.tableview.reloadData()
                return
            }
            if let sourceData = self?.subSourceData, let selectedData = sourceData.first(where: { $0.id == selectedIndex }) {
                selectedData.state = state
            }
        })
        return cell!
    }
}
extension StoreLocatorFilterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected Index \(indexPath.row)")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension StoreLocatorFilterVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.reloadDataWithoutSearchText(searchText: searchText)
    }
    fileprivate func reloadDataWithoutSearchText(searchText: String) {
        filteredArray = subSourceData.filter {
            $0.partnerName?.range(of: searchText, options: [.caseInsensitive, .anchored]) != nil
        }
        searchActive = searchText.isEmpty ? false : true
        self.tableview.reloadData()
    }
    @discardableResult
    func onApply(closure: @escaping ApplyClosure) -> Self {
        selectedPartners = closure
        return self
    }
}
