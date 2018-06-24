//
//  PointsCalculatorVC.swift
//  PayBack
//
//  Created by Mohsin Surani on 05/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//  ghmmb

import UIKit

class PointsCalculatorVC: BaseViewController {
    
    @IBOutlet weak fileprivate var pointTableView: UITableView!
    
    fileprivate var pointCalculateDataSource: [PointCalculatorCellModel] = []
    fileprivate var pointActionHandler: (() -> Void )?
    var footerViewInstance: PointFooterView?
    fileprivate var pointCalculatorFetcher: PointCalculatorFetcher!
    
    fileprivate var redeemPointsValue: Float = 0.25
    fileprivate var maxEarnPointsValue = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointCalculatorFetcher = PointCalculatorFetcher()
        self.pointTableView.register(UINib(nibName: Cells.pointCellNibID, bundle: nil), forCellReuseIdentifier: Cells.pointCellNibID)
        self.pointTableView.tableHeaderView = getHeaderView()
        
        if self.checkConnection() {
            connectionSuccess()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func connectionSuccess() {
        getCalculatedData()
    }
    
    private func getHeaderView() -> UIView {
        let topLabel = UILabel(frame: CGRect(x: 0, y: 26, width: ScreenSize.SCREEN_WIDTH - 0, height: 100))
        topLabel.numberOfLines = 0
        topLabel.textAlignment = .center
        topLabel.textColor = ColorConstant.headerTextColorPoint
        topLabel.text = chooseMonthlySpends
        topLabel.font = FontBook.Bold.of(size: 15)
        return topLabel
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if footerViewInstance == nil {
            self.pointTableView.tableFooterView = getFooterView()
        }
    }
    
    private func getFooterView() -> PointFooterView {
        footerViewInstance = (Bundle.main.loadNibNamed(pointFooterViewNibID, owner: self, options: nil)![0] as? PointFooterView)
        return footerViewInstance!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print(" PointsCalculatorVC deinit called")
    }
}

extension PointsCalculatorVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointCalculateDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pointCell = tableView.dequeueReusableCell(withIdentifier: Cells.pointCellNibID, for: indexPath) as? MyPointsCell
        pointCell?.cellViewModel = pointCalculateDataSource[indexPath.row]
        pointCell?.pointActionHandler = { [weak self] in
            self?.calculateTotalPoints()
        }
        return pointCell!
    }
}

extension PointsCalculatorVC {
    
    fileprivate func getCalculatedData() {
        pointCalculatorFetcher
            .onSuccess { [weak self] (pointcalculatorData) in
                
                if let pointData = pointcalculatorData.pointsCalculatorInfo {
                    
                    if let maxEarnPtValue = pointData.maxEarnPointsValue {
                        self?.maxEarnPointsValue = maxEarnPtValue
                    }
                    
                    if let redeemPtValue = pointData.redeemPointsValue {
                        self?.redeemPointsValue = redeemPtValue
                    }
                    
                    guard let categoryData = pointData.categories else {
                        return
                    }
                    
                    self?.integrateDataSource(result: categoryData)
                }
            }
            .onError { [weak self] (error) in
                self?.view?.errorMsgView(errorMsg: error)
            }
            .fetchPointCalculator()
    }
    
    fileprivate func integrateDataSource(result: [PointCalculator.PointsCalculatorInfo.Categories]) {
        for data in result {
            pointCalculateDataSource.append(PointCalculatorCellModel(withPointCalculator: data))
        }
        calculateTotalPoints()
        self.pointTableView.reloadData()
    }
    
    fileprivate func calculateTotalPoints() {
        var totalPoints = 0
        for data in pointCalculateDataSource {
            let value = Float(data.price!)
            let dividerValue = data.earnPointsForValue! / 100
            let eachPoint = value * dividerValue
            totalPoints += Int(eachPoint)
        }
        footerViewInstance?.setCalculatedValue(totalPoints: totalPoints, redeemValue: redeemPointsValue, maxPoints: maxEarnPointsValue)
    }
}
