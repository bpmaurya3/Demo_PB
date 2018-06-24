//
//  RewardsCatalogueVC.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/12/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

enum RewardCatalougeCellType {
    case heroCarouselTVCell
    case whatsYourWishTVCell
    case middleAdWithBannerTVCell
    case recommendedDealsTVCell
    case adWithBannerTVCell
    case hotDealsTVCell
}

class RewardsCatalogueVC: BaseViewController {
    fileprivate var tableViewCellTypes: [RewardCatalougeCellType] = []
    
    @IBOutlet weak fileprivate var tableView: UITableView!
    
    let reawardNwController = RewardCatalogueNetworkController()
    fileprivate var rewardViewModel: RewardsCatalougeVM!
    
    fileprivate var carouselHeight: CGFloat = Carousel_Height
    fileprivate var bannerHeight: CGFloat = Banner_Height
    fileprivate var placardHeight: CGFloat = Banner_Height
    
    var loadStateForCell = [ShopOnlineCellType: Bool]()
    private var reusableAdCellForMiddleBanner: AdTVCell!
    private var reusableAdCellForAdBanner: AdTVCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rewardViewModel = RewardsCatalougeVM(networkController: reawardNwController)
        
        self.setupViews()
        
        guard self.checkConnection() else {
            return
        }
        self.rewardViewModel.fetchNonRefreshable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadStateForCell.removeAll()
        if self.isNetworkAvailable() {
            self.rewardViewModel.fetchRefreshable()
        }
    }
    override func connectionSuccess() {
        self.rewardViewModel.fetchRefreshable()
        self.rewardViewModel.fetchNonRefreshable()
    }
    override func willEnterForeground() {
        self.loadStateForCell.removeAll()
        if self.isNetworkAvailable() {
            self.rewardViewModel.fetchRefreshable()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func userLogedIn(status: Bool) {
        guard status else {
            return
        }
        if status, let link = redirectUrl, link != "" {
            self.redirectVC(redirectLink: link, redirectLogoUrl: self.partnerlogoUrl)
            self.redirectUrl = ""
            self.partnerlogoUrl = ""
        } else {
            self.redirectUrl = ""
            self.partnerlogoUrl = ""
        }
    }
    deinit {
        if self.rewardViewModel != nil {
            self.rewardViewModel.invalidateObservers()
        }
        print("RewardsCatalogueVC: Deinit called")
    }
    
    private func registerCells() {
        tableView.register(CarouselTVCell.self, forCellReuseIdentifier: Cells.carouselTVCell)
        tableView.register(WhatsYourWishTVCell.self, forCellReuseIdentifier: Cells.whatsYourWishTVCell)
        tableView.register(AdWithBannerTVCell.self, forCellReuseIdentifier: Cells.adWithBannerTVCell)
        tableView.register(HotDealsTVCell.self, forCellReuseIdentifier: Cells.hotDealsTVCell)
        tableView.register(TopTrendTVCell.self, forCellReuseIdentifier: Cells.topTrendTVCell)
        tableView.register(AdTVCell.self, forCellReuseIdentifier: Cells.adTVCell)
    }
    
    private func setupViews() {

        tableViewCellTypes = [.heroCarouselTVCell, .whatsYourWishTVCell, .middleAdWithBannerTVCell, .recommendedDealsTVCell, .adWithBannerTVCell, .hotDealsTVCell]
        
        self.tableView.backgroundColor = ColorConstant.vcBGColor
        self.tableView.tableFooterView = getFooterView(height: 20)
        
        self.registerCells()
        guard self.rewardViewModel != nil else {
            return
        }
        self.rewardViewModel.bindToHeroBannerViewModels = { [weak self] in
            self?.reloadData {
                self?.tableView.reloadData()
            }
        }
        self.rewardViewModel.bindToBannerViewModels = { [weak self] in
            self?.reloadData {
                self?.tableView.reloadData()
            }
        }
        self.rewardViewModel.bindToPlacardViewModels = { [weak self] in
            self?.reloadData {
                self?.tableView.reloadData()
            }
        }
        self.rewardViewModel.bindToWhatsYourWishViewModels = { [weak self] in
            self?.reloadData {
                self?.tableView.reloadData()
            }
        }
        self.rewardViewModel.bindToRecommendedDealsViewModels = { [weak self] in
            self?.reloadData {
                self?.tableView.reloadData()
            }
        }
        self.rewardViewModel.bindToHotDealsViewModels = { [weak self] in
            self?.reloadData {
                self?.tableView.reloadData()
            }
        }
    }
    private func reloadData(block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }
}

extension RewardsCatalogueVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.rewardViewModel != nil else {
            return 0
        }
        return tableViewCellTypes.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableViewCellTypes[indexPath.section] {
        case .heroCarouselTVCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.carouselTVCell, for: indexPath) as? CarouselTVCell
            cell?.carouselSlides = self.rewardViewModel.heroCarouselViewModel
            cell?.tapOnCarousel = { [weak self] (link, logoPath) in
                self?.redirectVC(redirectLink: link, redirectLogoUrl: logoPath)
            }
            return cell!
        case .whatsYourWishTVCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.whatsYourWishTVCell, for: indexPath) as? WhatsYourWishTVCell
            cell?.cellModel = self.rewardViewModel.whatsYourWishViewModel
            return cell!
        case .recommendedDealsTVCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.topTrendTVCell, for: indexPath) as? TopTrendTVCell
            cell?.productType = .burnProduct
            cell?.cellModel = self.rewardViewModel.recommendedDealsViewModel
            return cell!
        case .middleAdWithBannerTVCell:
            let model = self.rewardViewModel.bannerViewModel
            return configureBannerCell(model, tableView, indexPath, cellType: .middleAdWithBannerTVCell)
        case .adWithBannerTVCell:
            let model = self.rewardViewModel.placardViewModel
            return configureBannerCell(model, tableView, indexPath, cellType: .adWithBannerTVCell)
        case .hotDealsTVCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.hotDealsTVCell, for: indexPath) as? HotDealsTVCell
            cell?.cellModel = self.rewardViewModel.hotDealsViewModel
            return cell!
        }
    }
}

extension RewardsCatalogueVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableViewCellTypes[indexPath.section] {
        case .heroCarouselTVCell:
            return self.rewardViewModel.heroCarouselViewModel == nil ? 0 : carouselHeight
        case .whatsYourWishTVCell:
            return self.rewardViewModel.whatsYourWishViewModel.isEmpty ? 0 : ScreenSize.SCREEN_WIDTH / 2.435 < 220 ? 220 : ScreenSize.SCREEN_WIDTH / 2.435 //220
        case .adWithBannerTVCell:
            return configureBanners(model: self.rewardViewModel.placardViewModel)
        case .middleAdWithBannerTVCell:
            return configureBanners(model: self.rewardViewModel.bannerViewModel)
        case .recommendedDealsTVCell:
            return self.rewardViewModel.recommendedDealsViewModel.isEmpty ? 0 : (ScreenSize.SCREEN_WIDTH / 2 - 1) / 0.4815 //DeviceType.IS_IPAD ? 450 : 410
        case .hotDealsTVCell:
            return self.rewardViewModel.hotDealsViewModel.isEmpty ? 0 : (ScreenSize.SCREEN_WIDTH / 2 - 1) / 0.815 < 290 ? 290 : (ScreenSize.SCREEN_WIDTH / 2 - 1) / 0.815 //290
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
      
        var height: CGFloat = 12
        switch tableViewCellTypes[section] {
        case .heroCarouselTVCell:
            height = 1.5
        case .hotDealsTVCell:
            height = 20
        default:
            break
        }
        
        return self.getFooterView(height: height)
    }
    
    private func getFooterView(height: CGFloat) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: (tableView.frame.size.width), height: height))
        view.backgroundColor = ColorConstant.vcBGColor
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableViewCellTypes[indexPath.section] == .middleAdWithBannerTVCell {
            guard let data = self.rewardViewModel.bannerViewModel else {
                return
            }
            
            if let redirectUrl = data.redirectionURL {
                self.redirectVC(redirectLink: redirectUrl, redirectLogoUrl: data.redirectionPartnerLogo)
            }
            
        } else if tableViewCellTypes[indexPath.section] == .adWithBannerTVCell {
            guard let data = self.rewardViewModel.placardViewModel else {
                return
            }
            
            if let redirectUrl = data.redirectionURL {
                self.redirectVC(redirectLink: redirectUrl, redirectLogoUrl: data.redirectionPartnerLogo)
            }
        }
        
    }
}
extension RewardsCatalogueVC {
    fileprivate func configureBanners(model: HeroBannerCellModel?) -> CGFloat {
        guard let model = model else {
            return 0
        }
        return  model.admob == true ? DeviceType.IS_IPAD ? iPad_AdSize : UITableViewAutomaticDimension : model.expired == true ? 0 : bannerHeight
    }
    fileprivate func configureBannerCell(_ model: HeroBannerCellModel?, _ tableView: UITableView, _ indexPath: IndexPath, cellType: ShopOnlineCellType) -> UITableViewCell {
        if cellType == .middleAdWithBannerTVCell {
            if loadStateForCell[cellType] == true {
                return  self.reusableAdCellForMiddleBanner
            }
            if model?.admob == true {
                reusableAdCellForMiddleBanner = tableView.dequeueReusableCell(withIdentifier: Cells.adTVCell,
                                                               for: indexPath) as? AdTVCell
                reusableAdCellForMiddleBanner?.setup(viewController: self, moduleType: .burnProduct, cellType: cellType, adUnitId: model?.adUnitId ?? "")
                return reusableAdCellForMiddleBanner!
            }
        } else if cellType == .adWithBannerTVCell {
            if loadStateForCell[cellType] == true {
                return  self.reusableAdCellForAdBanner
            }
            if model?.admob == true {
                reusableAdCellForAdBanner = tableView.dequeueReusableCell(withIdentifier: Cells.adTVCell,
                                                               for: indexPath) as? AdTVCell
                reusableAdCellForAdBanner?.setup(viewController: self, moduleType: .burnProduct, cellType: cellType, adUnitId: model?.adUnitId ?? "")
                return reusableAdCellForAdBanner!
            }
        }
       
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.adWithBannerTVCell, for: indexPath) as? AdWithBannerTVCell
        cell?.adWithBannerCellModel = model
        return cell!
    }
}
