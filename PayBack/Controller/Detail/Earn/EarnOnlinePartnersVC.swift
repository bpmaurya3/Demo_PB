//
//  EarnOnlinePartnersVC.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/31/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class EarnOnlinePartnersVC: BaseViewController {
    var loadStateForCell = [ShopOnlineCellType: Bool]()
    
    fileprivate var tableViewCellTypes = [ShopOnlineCellType]()
    
    fileprivate let shopOnlineNWController = ShopOnlineNetworkController()
    fileprivate var shopOnlineViewModel: ShopOnlineViewModel!
    fileprivate var showCaseCategoryCount = 0
    @IBOutlet weak private var tableView: UITableView!
    
    private var carouselHeight: CGFloat = Carousel_Height
    private var bannerHeight: CGFloat = Banner_Height
    private var placardHeight: CGFloat = Banner_Height
    private var reusableAdCellBanner: AdTVCell!
    private var reusableAdCellPlacard: AdTVCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.shopOnlineViewModel = ShopOnlineViewModel(networkController: shopOnlineNWController)
        
        setupViews()
        registerCells()
        
        if !self.checkConnection(withErrorViewYPosition: 0) {
            return
        }
        
        self.shopOnlineViewModel.fetchNonRefreshable()
        guard #available(iOS 11, *) else {
            if self.isNetworkAvailable() {
                self.refreshBanners()
            }
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadStateForCell.removeAll()
        if self.isNetworkAvailable() {
            self.refreshBanners()
        }
    }
    
    override func connectionSuccess() {
        self.setupViews()
        self.refreshBanners()
        self.shopOnlineViewModel.fetchNonRefreshable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        if self.shopOnlineViewModel != nil {
            self.shopOnlineViewModel.invalidateObservers()
        }
        print("EarnOnlinePartnersVC Deinit called")
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
    override func willEnterForeground() {
        self.loadStateForCell.removeAll()
        if self.isNetworkAvailable() {
            self.refreshBanners()
        }
    }
    
    private func setupViews() {
        tableViewCellTypes = [.heroCarouselTVCell, .shopClickTVCell, .categoriesTVCell, .topTrendTVCell, .middleAdWithBannerTVCell, .adWithBannerTVCell]
        
        self.shopOnlineViewModel.bindToCarouselViewModels = { [weak self] in
            self?.reloadData {
                self?.tableView.reloadData()
            }
        }
        self.shopOnlineViewModel.bindToBannerViewModels = { [weak self] in
            self?.reloadData {
                self?.tableView.reloadData()
            }
        }
        self.shopOnlineViewModel.bindToPlacardViewModels = { [weak self] in
            self?.reloadData {
                self?.tableView.reloadData()
            }
        }
        self.shopOnlineViewModel.bindToShopClickViewModels = { [weak self] in
            self?.reloadData {
                self?.tableView.reloadData()
            }
        }
        self.shopOnlineViewModel.bindToCategoriesViewModels = { [weak self] in
            self?.reloadData {
                self?.tableView.reloadData()
            }
        }
        self.shopOnlineViewModel.bindToTopTrendViewModels = { [weak self] in
            self?.reloadData {
                self?.tableView.reloadData()
            }
        }
        self.shopOnlineViewModel.bindToElectronicsViewModels = { [weak self] in
            self?.reloadData {
                self?.tableView.reloadData()
            }
        }
        self.shopOnlineViewModel.bindToShowCaseCategories = { [weak self] (showcaseCategories) in
            guard !showcaseCategories.isEmpty else {
                return
            }
            self?.showCaseCategoryCount = showcaseCategories.count
            self?.tableViewCellTypes = [.heroCarouselTVCell, .shopClickTVCell, .categoriesTVCell, .topTrendTVCell, .middleAdWithBannerTVCell, .showCaseCategoryTVCell, .adWithBannerTVCell]
            self?.reloadData {
                self?.tableView.reloadData()
            }
        }
    }
    private func reloadData(block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }
    private func registerCells() {
        tableView.register(CarouselTVCell.self, forCellReuseIdentifier: Cells.carouselTVCell)
        tableView.register(ShopClickTVCell.self, forCellReuseIdentifier: Cells.shopClickTVCell)
        tableView.register(CategoriesTVCell.self, forCellReuseIdentifier: Cells.categoriesTVCell)
        tableView.register(TopTrendTVCell.self, forCellReuseIdentifier: Cells.topTrendTVCell)
        tableView.register(ShowCaseCategoryTVCell.self, forCellReuseIdentifier: Cells.showCaseCategoryTVCell)
        tableView.register(AdWithBannerTVCell.self, forCellReuseIdentifier: Cells.adWithBannerTVCell)
        tableView.register(AdTVCell.self, forCellReuseIdentifier: Cells.adTVCell)
        tableView.tableFooterView = UIView()
    }
    
    private func refreshBanners() {
        self.shopOnlineViewModel.fetchRefreshable()
    }
}

extension EarnOnlinePartnersVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewCellTypes.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableViewCellTypes[section] {
        case .showCaseCategoryTVCell:
            return self.showCaseCategoryCount
        default:
            return 1
        }
    }
    //swiftlint:disable function_body_length
    //swiftlint:disable force_cast
    //swiftlint:disable cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewCellTypes[indexPath.section] {
        case .heroCarouselTVCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.carouselTVCell, for: indexPath) as! CarouselTVCell
            cell.carouselSlides = self.shopOnlineViewModel.carouselViewModel
            cell.tapOnCarousel = { [weak self] (link, logoPath) in
                self?.redirectVC(redirectLink: link, redirectLogoUrl: logoPath)
            }
            return cell
        case .shopClickTVCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.shopClickTVCell, for: indexPath) as! ShopClickTVCell
            if let model = self.shopOnlineViewModel.shopClickViewModel {
                cell.cellModel = model
            }
            configShopClickCellClosure(cell: cell)
            return cell
        case .categoriesTVCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.categoriesTVCell, for: indexPath) as! CategoriesTVCell
            cell.categoryOrInsurance = .shop
            if let model = self.shopOnlineViewModel.categoriesViewModel {
                cell.cellModel = model
            }
            return cell
        case .topTrendTVCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.topTrendTVCell, for: indexPath) as! TopTrendTVCell
            cell.productType = .earnProduct
            if let model = self.shopOnlineViewModel.topTrendViewModel {
                cell.cellModel = model
            }
            cell.toptrendTapClosure = { [weak self] (url, partnerLogo) in
                self?.redirectVC(redirectLink: url, redirectLogoUrl: partnerLogo)
            }
            return cell
        case .showCaseCategoryTVCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.showCaseCategoryTVCell, for: indexPath) as! ShowCaseCategoryTVCell
            cell.showCaseCategory = self.shopOnlineViewModel.getShowCaseCategory(at: indexPath.row)
            if let name = cell.showCaseCategory?.categoryName, let model = self.shopOnlineViewModel.showcaseCategoriesViewModel[name] {
                cell.cellModel = model
            }
            return cell
        case .middleAdWithBannerTVCell:
            let model = self.shopOnlineViewModel.bannerViewModel
            return configureBannerCell(model, tableView, indexPath, cellType: .middleAdWithBannerTVCell)
        case .adWithBannerTVCell:
            let model = self.shopOnlineViewModel.placardViewModel
            return configureBannerCell(model, tableView, indexPath, cellType: .adWithBannerTVCell)
        }
    }
    //swiftlint:enable cyclomatic_complexity
    // swiftlint:enable force_cast
    //swiftlint:enable function_body_length
}

extension EarnOnlinePartnersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableViewCellTypes[indexPath.section] {
        case .heroCarouselTVCell:
            return self.shopOnlineViewModel.carouselViewModel == nil ? 0 : carouselHeight
        case .shopClickTVCell:
            return self.shopOnlineViewModel.shopClickViewModel == nil || !(self.shopOnlineViewModel.shopClickViewModel?.isEmpty)! ? 180 : 0
        case .categoriesTVCell:
            return self.shopOnlineViewModel.categoriesViewModel == nil || !(self.shopOnlineViewModel.categoriesViewModel?.isEmpty)! ? 180 : 0
        case .topTrendTVCell:
            let height = DeviceType.IS_IPAD ? 450 : self.view.frame.width + 50
            return self.shopOnlineViewModel.topTrendViewModel == nil || !(self.shopOnlineViewModel.topTrendViewModel?.isEmpty)! ? height : 0
        case .showCaseCategoryTVCell:
            let category = self.shopOnlineViewModel.getShowCaseCategory(at: indexPath.row)
            guard let name = category?.categoryName, let model = self.shopOnlineViewModel.showcaseCategoriesViewModel[name], !(model.isEmpty) else {
                return 0
            }
            return  285
        case .adWithBannerTVCell:
            return configureBanners(model: self.shopOnlineViewModel.placardViewModel)
        case .middleAdWithBannerTVCell:
            return configureBanners(model: self.shopOnlineViewModel.bannerViewModel)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.sectionFooterHeight))
        view.backgroundColor = ColorConstant.vcBGColor

        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var urlString: String?
        var urlLogoString: String?
        switch tableViewCellTypes[indexPath.section] {
        case .middleAdWithBannerTVCell:
            let model = self.shopOnlineViewModel.bannerViewModel
            urlString = model?.redirectionURL
            urlLogoString = model?.redirectionPartnerLogo
        case .adWithBannerTVCell:
            let model = self.shopOnlineViewModel.placardViewModel
            urlString = model?.redirectionURL
            urlLogoString = model?.redirectionPartnerLogo
        default:
            break
        }
        
        if let urlString = urlString {
            self.redirectVC(redirectLink: urlString, redirectLogoUrl: urlLogoString)
        }
    }
}
extension EarnOnlinePartnersVC {
    private func configShopClickCellClosure(cell: ShopClickTVCell) {
        cell.cellTapClosure = { [weak self] (index) in
            if let strongSelf = self, let partnerDetails = self?.shopOnlineViewModel.earnPartner?.partnerDetails {
                let partnerDetail = partnerDetails[index]
                if  partnerDetail.isIntermdPgReq ?? false {
                    strongSelf.pushToPartnerDetail(atIndex: index)
                } else {
                    if let link = partnerDetail.linkUrl, link != "" {
                        strongSelf.redirectVC(redirectLink: link, redirectLogoUrl: partnerDetail.logoImage ?? "")
                    }
                }
            }
        }
    }
    
    private func pushToPartnerDetail(atIndex index: Int) {
        if let partnerDetailsVC = PartnerDetailsVC.storyboardInstance(storyBoardName: "Earn") as? PartnerDetailsVC {
            partnerDetailsVC.onlinePartner = (self.shopOnlineViewModel.earnPartner, index) as? (OtherPartner, Int)
            navigationController?.pushViewController(partnerDetailsVC, animated: true)
        }
    }
    fileprivate func configureBanners(model: HeroBannerCellModel?) -> CGFloat {
        guard let model = model else {
            return 0
        }
        return  model.admob == true ? DeviceType.IS_IPAD ? iPad_AdSize : UITableViewAutomaticDimension : model.expired == true ? 0 : bannerHeight
    }
    fileprivate func configureBannerCell(_ model: HeroBannerCellModel?, _ tableView: UITableView, _ indexPath: IndexPath, cellType: ShopOnlineCellType) -> UITableViewCell {
        if cellType == .middleAdWithBannerTVCell {
            if loadStateForCell[cellType] == true {
                return self.reusableAdCellBanner
            }
            if model?.admob == true {
                reusableAdCellBanner = tableView.dequeueReusableCell(withIdentifier: Cells.adTVCell,
                                                                     for: indexPath) as? AdTVCell
                reusableAdCellBanner?.setup(viewController: self, moduleType: .earnProduct, cellType: cellType, adUnitId: model?.adUnitId ?? "")
                return reusableAdCellBanner!
            }
        } else if cellType == .adWithBannerTVCell {
            if cellType == .middleAdWithBannerTVCell {
                if loadStateForCell[cellType] == true {
                    return self.reusableAdCellPlacard
                }
                if model?.admob == true {
                    reusableAdCellPlacard = tableView.dequeueReusableCell(withIdentifier: Cells.adTVCell,
                                                                          for: indexPath) as? AdTVCell
                    reusableAdCellPlacard?.setup(viewController: self, moduleType: .earnProduct, cellType: cellType, adUnitId: model?.adUnitId ?? "")
                    return reusableAdCellPlacard!
                }
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.adWithBannerTVCell, for: indexPath) as? AdWithBannerTVCell
        cell?.adWithBannerCellModel = model
        return cell!
    }
}
