//
//  ProductSearchFilterVC.swift
//  PayBack
//
//  Created by Valtech Macmini on 09/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ProductSearchFilterVC: BaseViewController {
    
    @IBOutlet weak fileprivate var navView: UIView!
    @IBOutlet weak fileprivate var clearButton: UIButton!
    @IBOutlet weak fileprivate var navTitle: UILabel!
    @IBOutlet weak fileprivate var backButton: UIButton!
    @IBOutlet weak fileprivate var searchFilterTableview: UITableView!
    @IBOutlet weak fileprivate var applyButton: UIButton!
    var fromRange: Int = 0
    var toRange: Int = 0
    var priceRange: PriceRange?
    var productListLandingType: ProductType = .none

    fileprivate var subFilters = [[SearchFilterTVCellModel]]()
    var  allFilterCellModel: [OtherFilterCellModel] = [] {
        didSet {
            filterCellModel = allFilterCellModel
            self.setSubfilterWithFilterModel()
        }
    }
    fileprivate var filterCellModel: [OtherFilterCellModel] = []
    fileprivate let cellIdentifier = "RangeSliderCell"
    var filterData: [String: String] = [:]
    
    typealias ApplyPressClosure = (([String: String]) -> Void)
    var selectedFilters: ApplyPressClosure  = { _ in }
    
    fileprivate var minRangeValue = 0
    fileprivate var maxRangeValue = 1000000

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
       self.applyButton.backgroundColor = ColorConstant.buttonBackgroundColorPink
           self.applyButton.titleLabel?.textColor = ColorConstant.textColorWhite
        self.applyButton.titleLabel?.font = FontBook.Regular.of(size: 15.0)
        self.navView.backgroundColor = ColorConstant.backgroudColorBlue
        self.navTitle.textColor = ColorConstant.textColorWhite
        self.navTitle.font = FontBook.Roboto.ofTitleSize()
        self.clearButton.titleLabel?.textColor = ColorConstant.textColorWhite
        self.clearButton.titleLabel?.font = FontBook.Roboto.ofTitleSize()
        
        self.searchFilterTableview.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.searchFilterTableview.register(FilterFeatureCell.self, forCellReuseIdentifier: "Cell")
        self.searchFilterTableview.estimatedRowHeight = 100
        self.searchFilterTableview.tableFooterView = UIView()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearAction(_ sender: Any) {
        resetAllValues()
    }
    
    @IBAction func applyAction(_ sender: Any) {
        //get all data
        filterCollectedData()
        backAction(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print(" Product search filter deinit called")
    }
}

extension ProductSearchFilterVC {
    
    fileprivate func setSubfilterWithFilterModel() {
        let points = filterCellModel.filter { $0.title == "Points Range" }
        
        if let point = points.first, let index = filterCellModel.index(of: point) {
            filterCellModel.remove(at: index)
        }
        
        for cellModel in filterCellModel {
            guard let values = cellModel.values else {
                return
            }
            var cellArray = [SearchFilterTVCellModel]()
            for (index, value) in values.enumerated() {
                cellArray.append(SearchFilterTVCellModel(partnerName: value.valueName, partnerId: value.valueId, isEnabled: value.isSelected, id: index))
            }
            subFilters.append(cellArray)
        }
    }
    
    // MARK: Gather All Filter Data
    
    fileprivate func getFilteredOtherFilter() -> [OtherFilterCellModel] {
        var filteredOtherFilterDataSource = [OtherFilterCellModel]()
        for filtered in filterData {
            guard let final = (filterCellModel.filter { $0.title == filtered.key }).first else {
                continue
            }
            filteredOtherFilterDataSource.append(final)
        }
        filteredOtherFilterDataSource = filteredOtherFilterDataSource.isEmpty ? filterCellModel : filteredOtherFilterDataSource
        return filteredOtherFilterDataSource
    }
    
    fileprivate func filterCollectedData() {
        if productListLandingType == .earnProduct {
            priceRange?.min = Int(filterData["min"] ?? "") ?? fromRange
            priceRange?.max = Int(filterData["max"] ?? "") ?? toRange
        } else {
            let priceRance = allFilterCellModel.filter({ $0.title == "Points Range" })
            for price in priceRance where (price.values!.count > 1) {
                price.values![0].valueId = "\(filterData["min"] ?? String(fromRange))"
                price.values![1].valueId = "\(filterData["max"] ?? String(toRange))"
            }
        }
        
        let filteredOtherFilterDataSource = getFilteredOtherFilter()
        for otherFilter in filteredOtherFilterDataSource {
            let selectedBrand = filterData[otherFilter.title!]
            guard let values = otherFilter.values else {
                continue
            }
            for value in values {
                guard let brand = selectedBrand, brand.contains(value.valueId) else {
                    value.isSelected = false
                    continue
                }
                value.isSelected = true
            }
        }
        var tempFilterData = filterData
        for key in filterData.keys where filterData[key] == "" {
            tempFilterData.removeValue(forKey: key)
        }
        filterData = tempFilterData
        self.selectedFilters(filterData)
    }
    
    // MARK: remove All Filter Data
    
    fileprivate func resetAllValues() {
        self.resetValues()
        filterData.removeAll()
        searchFilterTableview.reloadData()
    }
    
    fileprivate func resetValues() {
        for subfilter in subFilters {
            for filter in subfilter {
                filter.state = false
            }
        }
    }
}

extension ProductSearchFilterVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productListLandingType == .earnProduct {
            return  section == 0 ? (priceRange != nil ? 1 : 0) : filterCellModel.count
        } else {
            let points = allFilterCellModel.filter { $0.title == "Points Range" }
            return  section == 0 ? (!points.isEmpty ? 1 : 0) : filterCellModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RangeSliderCell
            configureRangeCell(cell: cell, index: indexPath.row)
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FilterFeatureCell
            cell?.cellViewModel = filterCellModel[indexPath.row]
            return cell!
        }
    }
}

extension ProductSearchFilterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 229 / 255, green: 243 / 255, blue: 1, alpha: 1)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section > 0 {
            let storyBoard = UIStoryboard(name: "InStore", bundle: nil)
            let subFilterVC = storyBoard.instantiateViewController(withIdentifier: "SearchFilterVC") as? SearchFilterVC
            guard let title = filterCellModel[indexPath.row].title else {
                return
            }
            subFilterVC?.placeholderText = title
            subFilterVC?.subSourceData = subFilters[indexPath.row]
            
            subFilterVC?.onDonePress(closure: { (selectedData) in
                self.filterData[title] = selectedData
            })
            self.navigationController?.pushViewController(subFilterVC!, animated: true)
        }
    }
}

extension ProductSearchFilterVC {
    fileprivate func configureRangeCell(cell: RangeSliderCell?, index: Int) {
        if productListLandingType == .earnProduct {
            if let priceRange = priceRange, let min = priceRange.min, let max = priceRange.max {
                if !self.filterData.isEmpty {
                    cell?.cellViewModel = RangeSliderCellModel(minValue: fromRange, maxValue: toRange, lowerValue: min, upperValue: max, title: "Price Range", rangeSymbol: StringConstant.rsSymbol)
                } else {
                    cell?.cellViewModel = RangeSliderCellModel(minValue: fromRange, maxValue: toRange, lowerValue: fromRange, upperValue: toRange, title: "Price Range", rangeSymbol: StringConstant.rsSymbol)
                }
            }
        } else {
            let points = allFilterCellModel.filter { $0.title == "Points Range" }
            if let values = points[index].values, let min = Int(values[0].valueId), let max = Int(values[1].valueId) {
                if !self.filterData.isEmpty {
                    cell?.cellViewModel = RangeSliderCellModel(minValue: fromRange, maxValue: toRange, lowerValue: min, upperValue: max, title: "Points Range", rangeSymbol: StringConstant.pointsSymbol)
                } else {
                    cell?.cellViewModel = RangeSliderCellModel(minValue: fromRange, maxValue: toRange, lowerValue: fromRange, upperValue: toRange, title: "Points Range", rangeSymbol: StringConstant.pointsSymbol)
                }
            }
        }
        cell?.rangeSliderClosure = { [weak self] (min, max) in
            self?.filterData["min"] = String(min)
            self?.filterData["max"] = String(max)
        }
    }
}
