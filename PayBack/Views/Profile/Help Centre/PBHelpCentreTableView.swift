//
//  PBHelpCentreTableView.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 28/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBHelpCentreTableView: UIView {
    
    fileprivate lazy var mHelpCentreTableView: UITableView = {
        let mHelpCentreTableView = UITableView(frame: .zero, style: .plain)
        mHelpCentreTableView.backgroundColor = UIColor.clear
        mHelpCentreTableView.delegate = self
        mHelpCentreTableView.dataSource = self
        mHelpCentreTableView.register(UINib(nibName: Cells.helpCentreDetailTVCellID, bundle: nil), forCellReuseIdentifier: Cells.helpCentreDetailTVCellID)
        mHelpCentreTableView.showsVerticalScrollIndicator = false
        mHelpCentreTableView.estimatedSectionHeaderHeight = 100
        mHelpCentreTableView.rowHeight = UITableViewAutomaticDimension
        mHelpCentreTableView.keyboardDismissMode = .onDrag
        mHelpCentreTableView.separatorStyle = .singleLineEtched
        mHelpCentreTableView.separatorColor = .red
        mHelpCentreTableView.tableFooterView = UIView()
        return mHelpCentreTableView
    }()
    var sourceData: [PBHelpCentreDetailTVCellModel] = [] {
        didSet {
            mHelpCentreTableView.reloadData()
        }
    }
    fileprivate var previousSection: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        //dataInitialized()
    }
    
    func dataInitialized() {
        let data1 = PBHelpCentreDetailTVCellModel(question: "How do I login to my PAYBACK account? How do I login to my PAYBACK account? How do I login to my PAYBACK account? How do I login to my PAYBACK account?", answer: "Log on to www.payback.in and enter your 16 digit PAYBACK Number / Username to view your points balance and activate coupons. To update your profile or redeem PAYBACK points, please enter your 4-digit PIN. PIN is a 4 digit numeric value which needs to be typed in to access your PAYBACK account. Log on to www.payback.in and enter your 16 digit PAYBACK Number / Username to view your points balance and activate coupons. To update your profile or redeem PAYBACK points, please enter your 4-digit PIN. PIN is a 4 digit numeric value which needs to be typed in to access your PAYBACK account.", isCollabsHidden: true, index: 0)
        let data2 = PBHelpCentreDetailTVCellModel(question: "How do I login to my PAYBACK account?", answer: "your PAYBACK account.", isCollabsHidden: true, index: 1)
        let data3 = PBHelpCentreDetailTVCellModel(question: "How do I login to my PAYBACK account?", answer: "Log on to www.payback.in and enter your 16 digit PAYBACK Number / Username to view your points balance and activate coupons. To update your profile or redeem PAYBACK points, please enter your 4-digit PIN. PIN is a 4 digit numeric value which needs to be typed in to access your PAYBACK account.", isCollabsHidden: true, index: 2)
        let data4 = PBHelpCentreDetailTVCellModel(question: "How do I login to my PAYBACK account?", answer: "Log on to www.payback.in and enter your 16 digit PAYBACK Number / Username to view your points balance and activate coupons. To update your profile or redeem PAYBACK points, please enter your 4-digit PIN. PIN is a 4 digit numeric value which needs to be typed in to access your PAYBACK account.", isCollabsHidden: true, index: 3)
        let data5 = PBHelpCentreDetailTVCellModel(question: "How do I login to my PAYBACK account? How do I login to my PAYBACK account? How do I login to my PAYBACK account? How do I login to my PAYBACK account?", answer: "Log on to www.payback.in and enter your 16 digit PAYBACK Number / Username to view your points balance and activate coupons. To update your profile or redeem PAYBACK points, please enter your 4-digit PIN. PIN is a 4 digit numeric value which needs to be typed in to access your PAYBACK account. Log on to www.payback.in and enter your 16 digit PAYBACK Number / Username to view your points balance and activate coupons. To update your profile or redeem PAYBACK points, please enter your 4-digit PIN. PIN is a 4 digit numeric value which needs to be typed in to access your PAYBACK account.", isCollabsHidden: true, index: 4)
        let data6 = PBHelpCentreDetailTVCellModel(question: "How do I login to my PAYBACK account?", answer: "your PAYBACK account.", isCollabsHidden: true, index: 5)
        let data7 = PBHelpCentreDetailTVCellModel(question: "How do I login to my PAYBACK account?", answer: "Log on to www.payback.in and enter your 16 digit PAYBACK Number / Username to view your points balance and activate coupons. To update your profile or redeem PAYBACK points, please enter your 4-digit PIN. PIN is a 4 digit numeric value which needs to be typed in to access your PAYBACK account.", isCollabsHidden: true, index: 6)
        let data8 = PBHelpCentreDetailTVCellModel(question: "How do I login to my PAYBACK account?", answer: "Log on to www.payback.in and enter your 16 digit PAYBACK Number / Username to view your points balance and activate coupons. To update your profile or redeem PAYBACK points, please enter your 4-digit PIN. PIN is a 4 digit numeric value which needs to be typed in to access your PAYBACK account.", isCollabsHidden: true, index: 7)
        sourceData.append(data1)
        sourceData.append(data2)
        sourceData.append(data3)
        sourceData.append(data4)
        sourceData.append(data5)
        sourceData.append(data6)
        sourceData.append(data7)
        sourceData.append(data8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(" PBHelpCentreTableView deinit called")
    }
    
    private func setup() {
        mHelpCentreTableView.register(UITableViewCell.self, forCellReuseIdentifier: "WriteToUs")
        mHelpCentreTableView.register(UINib(nibName: "PBHelpWriteUsCell", bundle: nil), forCellReuseIdentifier: "PBHelpWriteUsCell")
        
        self.addSubview(mHelpCentreTableView)
        self.addConstraintsWithFormat("H:|[v0]|", views: mHelpCentreTableView)
        self.addConstraintsWithFormat("V:|[v0]|", views: mHelpCentreTableView)
    }
    
}
extension PBHelpCentreTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.frame.origin.y = 0
        return sourceData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        let data = sourceData[section]
        return data.isCollabsHidden! ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.helpCentreDetailTVCellID, for: indexPath) as? PBHelpCentreDetailTVCell
        cell?.sourceData = sourceData[indexPath.section]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == sourceData.count {
            return UIView(frame: .zero)
        }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? HelpCentreTVHeaderFooterView ?? HelpCentreTVHeaderFooterView(reuseIdentifier: "header")
        let modeldata = sourceData[section]
        header.titleLabel.font = DeviceType.IS_IPAD ? FontBook.Bold.of(size: 13.0) : FontBook.Bold.of(size: 11.0)

        header.titleLabel.text = modeldata.ques
        header.titleLabel.tag = modeldata.indexID!
        header.arrowLabel.text = "+"
        header.arrowLabel.tag = modeldata.indexID!
        header.setCollapsed((modeldata.isCollabsHidden)!)
        header.section = modeldata.indexID!
        header.delegate = self
        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = ColorConstant.segmentDividerColor
        return view
    }
}

extension PBHelpCentreTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
// MARK: - Section Header Delegate
extension PBHelpCentreTableView: HelpCentreHeaderDelegate {
    func headerTitleScection(_ header: HelpCentreTVHeaderFooterView, section: Int) {
        self.toggleCollabsSection(header, section: section)
    }
    func toggleSection(_ header: HelpCentreTVHeaderFooterView, section: Int) {
        self.toggleCollabsSection(header, section: section)
    }
    func toggleCollabsSection(_ header: HelpCentreTVHeaderFooterView, section: Int) {
        if previousSection != -1 {
            if previousSection == section {
                let modelData = sourceData[previousSection]
                let collapsed = !(modelData.isCollabsHidden)!
                modelData.isCollabsHidden = collapsed
                header.setCollapsed(collapsed)
                previousSection = -1
            } else {
                let modelData = sourceData[section]
                let collapsed = !(modelData.isCollabsHidden)!
                modelData.isCollabsHidden = collapsed
                header.setCollapsed(collapsed)
                
                let modelData2 = sourceData[previousSection]
                let collapsed2 = !(modelData2.isCollabsHidden)!
                modelData2.isCollabsHidden = collapsed2
                header.setCollapsed(collapsed2)
                
                previousSection = section
            }
        } else {
            let modelData = sourceData[section]
            let collapsed = !(modelData.isCollabsHidden)!
            modelData.isCollabsHidden = collapsed
            header.setCollapsed(collapsed)
            previousSection = section
        }
        mHelpCentreTableView.reloadData()
    }
}
