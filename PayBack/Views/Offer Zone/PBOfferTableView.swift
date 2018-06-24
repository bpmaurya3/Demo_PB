//
//  PBOfferTableView.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 19/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
typealias LoadMoreInfo = (totalCount: Int, lastId: Int, isLoadMore: Bool, noDataText: String)

class PBOfferTableView: UIView {
    var offerTapClouser: ((Int) -> Void) = { _ in }
    var loadMoreClosure: () -> Void = { }
    var distanceActionClosure: ((UIButton) -> Void) = { _ in }

    fileprivate var isDataLoading = false

    fileprivate lazy var mOfferTableView: UITableView = {
        let mOfferTableView = UITableView(frame: .zero, style: .plain)
        mOfferTableView.backgroundColor = ColorConstant.collectionViewBGColor
        mOfferTableView.delegate = self
        mOfferTableView.dataSource = self
        mOfferTableView.separatorStyle = .none
        mOfferTableView.register(UINib(nibName: Cells.offersCellID, bundle: nil), forCellReuseIdentifier: Cells.offersCellID)
        mOfferTableView.register(UINib(nibName: Cells.insuranceCategoryCellNibID, bundle: nil), forCellReuseIdentifier: Cells.insuranceCategoryCellNibID)
        mOfferTableView.register(UINib(nibName: Cells.helpCentreDetailTVCellID, bundle: nil), forCellReuseIdentifier: Cells.helpCentreDetailTVCellID)
        mOfferTableView.register(NoDataFoundTVCell.self, forCellReuseIdentifier: Cells.noDataFoundTVCell)
        mOfferTableView.register(UINib(nibName: Cells.instoreListTVCell, bundle: nil), forCellReuseIdentifier: Cells.instoreListTVCell)
        mOfferTableView.showsVerticalScrollIndicator = false
        mOfferTableView.estimatedRowHeight = 50
        return mOfferTableView
    }()
    
    var categoryType: CategoryType = .none {
        didSet {
            setup()
        }
    }
    
    fileprivate var updateRedirectUrlClosure: ((String, String) -> Void)? = { _, _ in }
    @discardableResult
    func redirectUrl(closure: @escaping ((String, String) -> Void) ) -> Self {
       self.updateRedirectUrlClosure = closure
       return self
    }
    
    fileprivate var goOfferView: AlertCouponPopUp?
    fileprivate var scrollView: UIScrollView!
    
    var loadMoreInfo: LoadMoreInfo = (0, 0, false, "")
    var cellModel: [CouponsRechargeCellModel]? {
        didSet {
            if !loadMoreInfo.isLoadMore {
                DispatchQueue.main.async {
                    self.mOfferTableView.contentOffset = .zero
                }
            }
            DispatchQueue.main.async {
                self.mOfferTableView.tableFooterView?.isHidden = true
                self.mOfferTableView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(" PBOfferTableView deinit called")
    }
    
    private func setup() {
        
        self.addSubview(mOfferTableView)
        self.addConstraintsWithFormat("V:|[v0]|", views: mOfferTableView)
        self.addConstraintsWithFormat("H:|[v0]|", views: mOfferTableView)
        
        mOfferTableView.tableFooterView = UIView()
    }
}
extension PBOfferTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = cellModel, !model.isEmpty else {
            return No_Data_Found_CellDataSource_Count
        }
        return model.count
    }
    //swiftlint:disable cyclomatic_complexity
    fileprivate func configureInsuranceCategoryCell(_ cell: InsuranceCategoryCell, _ indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.rechargeOrInsuranceType = .insuranceCategory
        if let model = cellModel, model.count > indexPath.row {
            cell.cellViewModel = model[indexPath.row]
        }
        cell.buyOrKnowTapClouser = { [weak self] (redirectionUrl, redirectionLogoPath) in
            if let closure = self?.updateRedirectUrlClosure {
                closure(redirectionUrl, redirectionLogoPath)
            }
        }
        cell.update(containerBottomContraint: indexPath.row == (cellModel?.count)! - 1 ? 10 : 0)
    }
    
    fileprivate func configureRechargeCouponsCsell(_ cell: InsuranceCategoryCell, _ indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.rechargeOrInsuranceType = .rechargeOffers
        if let model = cellModel, model.count > indexPath.row {
            cell.cellViewModel = model[indexPath.row]
        }
        cell.goOfferTapClouser = { [weak self] model in
            if let strongSelf = self {
                strongSelf.showGoOfferView(model: model)
            }
        }
        cell.update(containerBottomContraint: indexPath.row == (cellModel?.count)! - 1 ? 10 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = cellModel, !model.isEmpty else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.noDataFoundTVCell, for: indexPath)
            cell.textLabel?.text = loadMoreInfo.noDataText
            return cell
        }
        switch categoryType {
        case .inStoreOffer:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.instoreListTVCell, for: indexPath) as? InstoreListTVCell {
                cell.backgroundColor = .clear
                if let model = cellModel, model.count > indexPath.row {
                    cell.offerCellModel = model[indexPath.row]
                }
                cell.distanceActionClosure = self.distanceActionClosure
                cell.update(containerBottomContraint: indexPath.row == (cellModel?.count)! - 1 ? 10 : 0)
                return cell
            }
        case .onlineOffer:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.offersCellID, for: indexPath) as? PBOfferTVCell {
                cell.backgroundColor = .clear
                if let model = cellModel, model.count > indexPath.row {
                    cell.offerCellModel = model[indexPath.row]
                }
                cell.update(containerBottomContraint: indexPath.row == (cellModel?.count)! - 1 ? 10 : 0)
                return cell
            }
        case .recharge, .coupans:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.insuranceCategoryCellNibID, for: indexPath) as? InsuranceCategoryCell {
                configureRechargeCouponsCsell(cell, indexPath)
                return cell
            }
        case .insuranceDetail:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.insuranceCategoryCellNibID, for: indexPath) as? InsuranceCategoryCell {
                configureInsuranceCategoryCell(cell, indexPath)
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
    //swiftlint:enable cyclomatic_complexity
}
extension PBOfferTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch categoryType {
        case .inStoreOffer, .onlineOffer:
            openUrl(index: indexPath.row)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrollView = scrollView
        switch categoryType {
        case .onlineOffer, .coupans:
            if (mOfferTableView.contentOffset.y + mOfferTableView.frame.size.height) >= mOfferTableView.contentSize.height {
                if !isDataLoading, loadMoreInfo.lastId < loadMoreInfo.totalCount {
                    isDataLoading = true
                    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    spinner.startAnimating()
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: mOfferTableView.bounds.width, height: CGFloat(44))
                    
                    self.mOfferTableView.tableFooterView = spinner
                    self.mOfferTableView.tableFooterView?.isHidden = false

                    self.loadMoreClosure()
                }
            }
        default:
            break
        }
    }
}
extension PBOfferTableView {
    
    private func showGoOfferView(model: CouponsRechargeCellModel) {
        guard let goOfferView = Bundle.main.loadNibNamed("AlertCouponPopUp", owner: self, options: nil)?.first as? AlertCouponPopUp else {
            return 
        }
        goOfferView.frame = CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT)
        
        let config = PopUpConfiguration()
            .set(hideCopy: false)
            .set(hideClose: false)
            .set(hideOfferCode: false)
            .set(hideDescription: false)
            .set(hideInstruction: false)
            .set(offerCouponString: model.promoCode!)
            .set(instructionString: model.termsAndCondition ?? "")
            .set(descriptionCouponText: model.subTitle ?? "")
        
        goOfferView.initWithConfiguration(configuration: config)
        goOfferView.copyOfferActionHandler = {(Data) in
            print("copy handled: \(Data)")
        }
        
        APP_DEL?.window?.addSubview(goOfferView)
        self.goOfferView = goOfferView
    }
    
    private func openUrl(index: Int) {
        if let model = cellModel, model.count > index {
            let cellData = model[index]
            if let urlString = cellData.redirectionUrl, let logoUrl = cellData.redirectionLogoPath, let closure = self.updateRedirectUrlClosure {
                closure(urlString, logoUrl)
            }
        }
    }
}
