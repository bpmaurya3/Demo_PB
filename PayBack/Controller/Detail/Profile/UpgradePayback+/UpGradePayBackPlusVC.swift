//
//  UpGradePayBackPlusVC.swift
//  PayBack
//
//  Created by Dinakaran M on 18/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class UpGradePayBackPlusVC: BaseViewController {
    
    @IBOutlet weak fileprivate var navigationView: DesignableNav!
    @IBOutlet weak fileprivate var mTableView: UITableView!
    @IBOutlet weak fileprivate var mUpgradeNowButton: UIButton!
    @IBOutlet weak fileprivate var mUpgradeNowButtonHeightConstraint: NSLayoutConstraint!
    
    fileprivate var upgradeNowClicked: Bool = false
    fileprivate var cellVisible: Bool = false
    fileprivate var upgradeNowStatus: Bool = false
    
    fileprivate let paybackPlusNwController = PaybackPlusNWController()
    
    fileprivate var heroBannerCellModel: [HeroBannerCellModel]? {
        didSet {
            self.mTableView.reloadData()
        }
    }
    fileprivate var partnersCellModel: [CouponsRechargeCellModel] = [] {
        didSet {
            self.mTableView.reloadData()
        }
    }
    var exclusiveCellModel: [ExclusiveBenefitsCVCellModel] = [] {
        didSet {
            self.mTableView.reloadData()
        }
    }
    private func reloadData(block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationView.title = "PAYBACK PLUS"
        registerCell()
        self.mUpgradeNowButton.titleLabel?.textColor = ColorConstant.buttonBackgroundColorPink
        self.mUpgradeNowButton.titleLabel?.textColor = ColorConstant.textColorWhite
        self.mUpgradeNowButton.titleLabel?.font = FontBook.Regular.of(size: 15.0)
        self.mUpgradeNowButton.backgroundColor = ColorConstant.buttonBackgroundColorPink
        guard self.checkConnection() else {
            return
        }
        fetchNonRefreshable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        mUpgradeNowButton.isHidden = false
        upgradeNowClicked = false
        cellVisible = false
        mUpgradeNowButtonHeightConstraint.constant = 50
        mTableView.separatorStyle = .none
        
        if self.isNetworkAvailable() {
            fetchBanner()
        }
    }
    
    override func connectionSuccess() {
        fetchBanner()
        fetchNonRefreshable()
    }
    override func userLogedIn(status: Bool) {
        if self.upgradeNowStatus {
            self.upgradeNow()
            self.upgradeNowStatus = false
        }
        
        guard status else {
            return
        }
        if status, let link = redirectUrl, link != "" {
            self.redirectVC(redirectLink: link, redirectLogoUrl: self.partnerlogoUrl ?? "")
            self.redirectUrl = ""
            self.partnerlogoUrl = ""
        } else {
            self.redirectUrl = ""
            self.partnerlogoUrl = ""
        }
        
    }
    override func willEnterForeground() {
        if self.isNetworkAvailable() {
            fetchBanner()
        }
    }
    
    deinit {
        print(" UpGradePayBackPlusVC deinit called")
    }
    
    private func registerCell() {
        mTableView.register(UINib(nibName: Cells.userInfoTVCellID, bundle: nil), forCellReuseIdentifier: Cells.userInfoTVCellID)
        mTableView.register(UINib(nibName: Cells.userPointTVCellID, bundle: nil), forCellReuseIdentifier: Cells.userPointTVCellID)
        mTableView.register(PBUserPointOfferTVCell.self, forCellReuseIdentifier: Cells.userPointOfferTVCellID)
        mTableView.register(CarouselTVCell.self, forCellReuseIdentifier: Cells.carouselTVCell)
        mTableView.register(UINib(nibName: Cells.exclusivBenefitsTVCellID, bundle: nil), forCellReuseIdentifier: Cells.exclusivBenefitsTVCellID)
        mTableView.register(UINib(nibName: Cells.offersCellID, bundle: nil), forCellReuseIdentifier: Cells.offersCellID)
    }
}
extension UpGradePayBackPlusVC {
    fileprivate func fetchBanner() {
        self.startActivityIndicator()
        let when = DispatchTime.now()
        DispatchQueue.global().asyncAfter(deadline: when) {
            self.paybackPlusNwController
                .onBannerImageSuccess { [weak self] (banner, expired) in
                    self?.heroBannerCellModel = expired ? nil : [banner]
                    self?.stopActivityIndicator()
                }
                .onBannerImageError { [weak self] (error) in
                    print("\(error)")
                    self?.stopActivityIndicator()
                }
                .fetchBannerImage()
        }
        
    }
    
    fileprivate func fetchNonRefreshable() {
        let when = DispatchTime.now() + 0.15
        DispatchQueue.global().asyncAfter(deadline: when) {
             self.fetchExclusive()
        }
        let when1 = when + 0.15
        DispatchQueue.global().asyncAfter(deadline: when1) {
            self.fetchPaybackPlusPartners()
        }
    }
    
    private func fetchPaybackPlusPartners() {
        paybackPlusNwController
            .onpartnersSuccess { [weak self](partners) in
                self?.partnersCellModel = partners
            }
            .onpartnersError { [weak self] _ in
                self?.partnersCellModel = []
            }
            .fetchPayBackPlusPartners()
    }
    
    private func fetchExclusive() {
        paybackPlusNwController
            .onExclusiveSuccess { [weak self] (exclusives) in
                self?.exclusiveCellModel = exclusives
            }
            .onExclusiveError { (error) in
                print("\(error)")
            }
            .fetchPaybackPlusExclusive()
    }
}

// MARK: TableView Method
extension UpGradePayBackPlusVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partnersCellModel.count + 5
    }
    //swiftlint:disable cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.userInfoTVCellID, for: indexPath) as? PBUserInfoTVCell {
                configureUserInfoCell(cell: cell)
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.userPointTVCellID, for: indexPath) as? PBUserPointTVCell {
                cell.contentView.isHidden = !cellVisible
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.userPointOfferTVCellID, for: indexPath) as? PBUserPointOfferTVCell {
                
                return cell
            }
        case 3:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.carouselTVCell, for: indexPath) as? CarouselTVCell {
                cell.carouselSlides = heroBannerCellModel
                cell.tapOnCarousel = { [weak self] (link, logoPath) in
                    self?.redirectVC(redirectLink: link, redirectLogoUrl: logoPath)
                }
                return cell
            }
        case 4:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.exclusivBenefitsTVCellID, for: indexPath) as? ExclusivBenefitsTVCell {
                cell.cellModel = exclusiveCellModel
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.offerTVCell, for: indexPath) as? PBOfferTVCell {
                cell.backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 250 / 255, alpha: 1.0)
                cell.offerCellModel = partnersCellModel[indexPath.row - 5]
                return cell
            }
        }
        return UITableViewCell()
    }
    //swiftlint:enable cyclomatic_complexity
}

extension UpGradePayBackPlusVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        switch indexPath.row {
        case 0, 1:
            height = upgradeNowClicked ? UITableViewAutomaticDimension : 0
        case 2:
            height = upgradeNowClicked ? 300 : 0
        case 3:
            height = upgradeNowClicked ? 0 : heroBannerCellModel == nil ? 0 : Carousel_Height
        case 4:
            height = DeviceType.IS_IPAD ? ScreenSize.SCREEN_WIDTH / 2.875 : 220
        default:
            height = UITableViewAutomaticDimension
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            if let bannerModel = heroBannerCellModel, !bannerModel.isEmpty, let redirectUrl = bannerModel[0].redirectionURL {
                if UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged) {
                    self.redirectVC(redirectLink: redirectUrl, redirectLogoUrl: bannerModel[0].redirectionPartnerLogo)
                }
            }
            return
        }
        openBannerOffer(indexPath.row)
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 100
    //    }
}

extension UpGradePayBackPlusVC {
    private func openBannerOffer(_ index: Int) {
        
        if index > 4 {
            let landingModel = self.partnersCellModel[index - 5]
            if let urlString = landingModel.redirectionUrl {
                self.redirectVC(redirectLink: urlString, redirectLogoUrl: landingModel.redirectionLogoPath)
            }
        }
    }
    
    fileprivate func configureUserInfoCell(cell: PBUserInfoTVCell) {
        cell.contentView.isHidden = !cellVisible
        
        let isUserLogedIn: Bool = UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged)
        if isUserLogedIn, let userDetails = UserProfileUtilities.getUserDetails() {
            cell.cellModel = userDetails
        }
    }
    
    @IBAction func upgradeNowButtonAction(_ sender: UIButton) {
        self.upgradeNow()
    }
    
    func upgradeNow() {
        let isUserLogedIn: Bool = UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged)
        if isUserLogedIn {
            mUpgradeNowButtonHeightConstraint.constant = upgradeNowClicked ? 50 : 0
            upgradeNowClicked = !upgradeNowClicked
            cellVisible = true
            expendHeight()
        } else {
            self.signInPopUp()
            self.upgradeNowStatus = true
        }
    }
    
    func expendHeight() {
        mTableView.beginUpdates()
        mTableView.reloadRows(at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0), IndexPath(row: 3, section: 0)], with: .automatic)
        mTableView.endUpdates()
        mTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
    } 
}
