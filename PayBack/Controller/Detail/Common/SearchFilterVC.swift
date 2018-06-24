//
//  SearchFilterVC.swift
//  PayBack
//
//  Created by Dinakaran M on 15/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class SearchFilterVC: BaseViewController {
    typealias DonePressClosure = ((String) -> Void)
    var selectedPartners: DonePressClosure  = { _ in }
    let cellIdentifier = "SearchFilterTVCell"
    
    var subSourceData: [SearchFilterTVCellModel] = []
    var filteredArray: [SearchFilterTVCellModel] = []
    var searchActive: Bool = false
    var placeholderText: String = ""
    var titleText: String = "SORT"
    var searchBarHeight: CGFloat = 56
    var tableviewTopSpace: CGFloat = 20
    
    @IBOutlet weak private var navView: UIView!
    @IBOutlet weak fileprivate var tableview: UITableView!
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var tableviewTopSpaceConstraints: NSLayoutConstraint!
    @IBOutlet weak private var doneButton: UIButton!
    @IBOutlet weak private var searchbarHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak private var subtitle: UILabel!
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearAction(_ sender: Any) {
        for items in subSourceData {
            items.state = false
        }
        tableview.reloadData()
    }
    @IBAction func doneButtonAction(_ sender: Any) {
        var selectedFields = ""
        let selectedArray = subSourceData.filter({ $0.state == true })
        for (index, item) in selectedArray.enumerated() {
            selectedFields.append(item.partnerId ?? "")
            if index != selectedArray.count - 1 {
                selectedFields.append(",")
            }
        }
        self.selectedPartners(selectedFields)
        backButtonAction(self)
        print("Done Button Clicked")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSearchBarView()
        self.setUpTableview()
        self.searchBar.placeholder = "Search \(placeholderText)"
        
        self.subtitle.text = placeholderText
        self.subtitle.textColor = ColorConstant.textColorWhite
        self.subtitle.font = FontBook.Bold.ofNavigationBarTitleSize()
        
        self.doneButton.backgroundColor = ColorConstant.buttonBackgroundColorPink
        self.doneButton.titleLabel?.textColor = ColorConstant.textColorWhite
        self.doneButton.titleLabel?.font = FontBook.Regular.of(size: 15.0)
        
        self.tableviewTopSpaceConstraints.constant = tableviewTopSpace
        self.searchbarHeightConstraints.constant = searchBarHeight
        self.navView.backgroundColor = ColorConstant.backgroudColorBlue
        self.view.backgroundColor = ColorConstant.backgroundViewColor
        
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
        print("Denit - SearchFilterVC ")
    }
}

extension SearchFilterVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
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
            if let sourceData = self?.subSourceData, let selectedData = sourceData.first(where: { $0.id == selectedIndex }) {
                selectedData.state = state
            }
        })
        return cell!
    }
}
extension SearchFilterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected Index \(indexPath.row)")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension SearchFilterVC: UISearchBarDelegate {
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
        filteredArray = subSourceData.filter {
            $0.partnerName?.range(of: searchText, options: [.caseInsensitive, .anchored]) != nil
        }
        searchActive = searchText.isEmpty ? false : true
        self.tableview.reloadData()
    }
    @discardableResult
    func onDonePress(closure: @escaping DonePressClosure) -> Self {
        selectedPartners = closure
        return self
    }
}
