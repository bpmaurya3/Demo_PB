//
//  LeftMenuViewController.swift
//  PayBack
//
//  Created by Dinakaran M on 31/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
enum LeftMenuHeader: Int {
    case earnPointsVC = 0
    case redeemPointsVC
    case offerZoneVC
    case exploreVC
}
class LeftMenuViewController: BaseViewController {
    fileprivate var sections = sectionData {
        didSet {
            self.tableview.reloadData()
        }
    }
    var homeViewController: UIViewController!
    let exploreStoryboard = UIStoryboard(name: "Explore", bundle: nil)
    let earnStoryboard = UIStoryboard(name: "Earn", bundle: nil)
    let burnStoryboard = UIStoryboard(name: "Burn", bundle: nil)
    let offerStoryboard = UIStoryboard(name: "OfferZone", bundle: nil)
    let inStoreStoryboard = UIStoryboard(name: "InStore", bundle: nil)
    let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
    var tempViewController: UIViewController?
    
    @IBOutlet weak private var homeLabel: UILabel!
    @IBOutlet weak private var topsuperview: NSLayoutConstraint!
    @IBOutlet weak fileprivate var tableview: UITableView!
    @IBOutlet weak private var subview: UIView!
    @IBOutlet weak private var headerview: UIView!
    
    fileprivate var previousSection: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        if #available(iOS 11, *) {} else {
            self.topsuperview.constant = 0
            NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActiveLeftMenu(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        }
        subview.backgroundColor = ColorConstant.leftRightMenuBgColor
        headerview.backgroundColor = ColorConstant.rightMenuHeaderColorBlue
        homeLabel.textColor = ColorConstant.textColorWhite
        homeLabel.font = FontBook.Regular.of(size: 15.0)
    }
    @objc func applicationDidBecomeActiveLeftMenu(_ notification: NSNotification) {
        self.updateLeftMenuStatus()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func updateLeftMenuStatus() {
        if #available(iOS 11, *) {} else {
        if (self.slideMenuController()?.isLeftOpen())! {
            self.slideMenuController()?.openLeft()
            }
        }
    }
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    @IBAction func homeButtonAction(_ sender: Any) {
        self.slideMenuController()?.popToRootViewController(close: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //swiftlint:disable function_body_length
    //swiftlint:disable cyclomatic_complexity
    func changeViewControllerSectionInRow(_ menu: LeftMenuSections) {
        guard !isProfileEditing else {
            self.openAlertPopupForEditProfile(menu)
            return
        }
        let isUserLogedInStatus = UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged)
        switch menu {
        case .eInstoreBrandsVC:
            let earn_InStorePartners = inStoreStoryboard.instantiateViewController(withIdentifier: "InStorePartnersVC") as? InStorePartnersVC
            self.slideMenuController()?.changeMainViewController(earn_InStorePartners!, close: true)
        case .eOnlineBrandsVC:
            let shopOnlinePartnersVC = earnStoryboard.instantiateViewController(withIdentifier: "BaseOnlinePartnersViewController") as? EarnBaseOnlinePartnersVC
            shopOnlinePartnersVC?.defaultSelectedIndex = 0
            self.slideMenuController()?.changeMainViewController(shopOnlinePartnersVC!, close: true)
        case .eShopOnlineViaPaybackVC:
            let shopOnlinePartnersVC = earnStoryboard.instantiateViewController(withIdentifier: "BaseOnlinePartnersViewController") as? EarnBaseOnlinePartnersVC
            shopOnlinePartnersVC?.defaultSelectedIndex = 0
            self.slideMenuController()?.changeMainViewController(shopOnlinePartnersVC!, close: true)
        case .eOtherOnlinepartnersVC:
            let earn_OtherOnlinePartnersVC = earnStoryboard.instantiateViewController(withIdentifier: "BaseOnlinePartnersViewController") as? EarnBaseOnlinePartnersVC
            earn_OtherOnlinePartnersVC?.defaultSelectedIndex = 1
            self.slideMenuController()?.changeMainViewController(earn_OtherOnlinePartnersVC!, close: true)
        case .eBankingServicesVC:
            let bankingServices = OnlinePartnersVC.storyboardInstance(storyBoardName: "Burn") as? OnlinePartnersVC
            bankingServices?.landingType = .bankingService
            self.slideMenuController()?.changeMainViewController(bankingServices!, close: true)
        case .eInstantVouchers:
            let instantVouchers = profileStoryboard.instantiateViewController(withIdentifier: "PoliciesVC") as? PoliciesVC
            instantVouchers?.type = .voucherWorld
            if isUserLogedInStatus {
                self.slideMenuController()?.changeMainViewController(instantVouchers!, close: true)
            } else {
                self.signInAction(viewController: instantVouchers)
            }
        case .eWriteReviewVC:
            let instantVouchers = profileStoryboard.instantiateViewController(withIdentifier: "PoliciesVC") as? PoliciesVC
            instantVouchers?.type = .reviews
            self.slideMenuController()?.changeMainViewController(instantVouchers!, close: true)
            
//            let reviewVC = earnStoryboard.instantiateViewController(withIdentifier: "ReviewVC") as? ReviewVC
//            self.slideMenuController()?.changeMainViewController(reviewVC!, close: true)
        case .eTakeSurveysVC:
            let surveyVC = earnStoryboard.instantiateViewController(withIdentifier: "SurveyVC") as? SurveyVC
            self.slideMenuController()?.changeMainViewController(surveyVC!, close: true)
        case .rInstantVouchersVC:
            let instantVouchers = profileStoryboard.instantiateViewController(withIdentifier: "PoliciesVC") as? PoliciesVC
            instantVouchers?.type = .voucherWorld
            if isUserLogedInStatus {
                self.slideMenuController()?.changeMainViewController(instantVouchers!, close: true)
            } else {
                self.signInAction(viewController: instantVouchers)
            }
        case .rRewardsCatalogueVC:
            let rewardVC = burnStoryboard.instantiateViewController(withIdentifier: "RewardsCatalogueVC") as? RewardsCatalogueVC
            self.slideMenuController()?.changeMainViewController(rewardVC!, close: true)
        case .rOnlineBrandsVC:
            let onlineBrandsVC = burnStoryboard.instantiateViewController(withIdentifier: "OnlinePartnersVC") as? OnlinePartnersVC
            onlineBrandsVC?.landingType = .burnProduct
            self.slideMenuController()?.changeMainViewController(onlineBrandsVC!, close: true)
        case .rInStoreBrandsVC:
            let rInStoreBrandsVC = inStoreStoryboard.instantiateViewController(withIdentifier: "InStorePartnersVC") as? InStorePartnersVC
            self.slideMenuController()?.changeMainViewController(rInStoreBrandsVC!, close: true)
        case .oNearbuyOffersVC:
//            let offer_InStore = offerStoryboard.instantiateViewController(withIdentifier: "InstoreOffersVC") as? InstoreOffersVC
//            self.slideMenuController()?.changeMainViewController(offer_InStore!, close: true)
            let offer_OnlineOffer = offerStoryboard.instantiateViewController(withIdentifier: "OnlineOffersVC") as? OnlineOffersVC
            offer_OnlineOffer?.categoryType = .inStoreOffer
            self.slideMenuController()?.changeMainViewController(offer_OnlineOffer!, close: true)
        case .oOnlineOffersVC:
            let offer_OnlineOffer = offerStoryboard.instantiateViewController(withIdentifier: "OnlineOffersVC") as? OnlineOffersVC
            offer_OnlineOffer?.categoryType = .onlineOffer
            self.slideMenuController()?.changeMainViewController(offer_OnlineOffer!, close: true)
        case .oRechargeOffersVC:
            let offer_Recharge = offerStoryboard.instantiateViewController(withIdentifier: "OnlineOffersVC") as? OnlineOffersVC
            offer_Recharge?.categoryType = .recharge
            self.slideMenuController()?.changeMainViewController(offer_Recharge!, close: true)
        case .oCouponsVC:
            let offer_Coupons = offerStoryboard.instantiateViewController(withIdentifier: "OnlineOffersVC") as? OnlineOffersVC
            offer_Coupons?.categoryType = .coupans
            self.slideMenuController()?.changeMainViewController(offer_Coupons!, close: true)
        case .exPaybackPlusVC:
            let explore_PaybackPlus = profileStoryboard.instantiateViewController(withIdentifier: "UpGradePayBackPlusVC") as? UpGradePayBackPlusVC
            self.slideMenuController()?.changeMainViewController(explore_PaybackPlus!, close: true)
        case .exInsuranceVC:
            let explore_Insurance = exploreStoryboard.instantiateViewController(withIdentifier: "InsuranceVC") as? InsuranceVC
            self.slideMenuController()?.changeMainViewController(explore_Insurance!, close: true)
        case .exCorporateRewardsVC:
            let exCorporateRewardsVC = OnlinePartnersVC.storyboardInstance(storyBoardName: "Burn") as? OnlinePartnersVC
            exCorporateRewardsVC?.landingType = .carporateRewards
            self.slideMenuController()?.changeMainViewController(exCorporateRewardsVC!, close: true)
        case .exKnowAboutPAYBACKVC:
            let explore_Payback = exploreStoryboard.instantiateViewController(withIdentifier: "ExplorePaybackViewController") as? ExplorePaybackViewController
            self.slideMenuController()?.changeMainViewController(explore_Payback!, close: true)
        }
    }
    //swiftlint:enable function_body_length
    //swiftlint:enable cyclomatic_complexity
    func changeHeaderViewController(_ headerMenu: LeftMenuHeader) {
        switch headerMenu {
        case .earnPointsVC:
            let earnLandindViewController = earnStoryboard.instantiateViewController(withIdentifier: "EarnLandingVC") as? EarnLandingVC
            self.slideMenuController()?.changeMainViewController(earnLandindViewController!, close: true)
        case .redeemPointsVC:
            let burnLandingViewController = burnStoryboard.instantiateViewController(withIdentifier: "BurnLandingVC") as? BurnLandingVC
            self.slideMenuController()?.changeMainViewController(burnLandingViewController!, close: true)
        case .offerZoneVC:
            let offerLandingViewController = offerStoryboard.instantiateViewController(withIdentifier: "OfferLandingVC") as? OfferLandingVC
             self.slideMenuController()?.changeMainViewController(offerLandingViewController!, close: true)
        case .exploreVC:
            let exploreLandingViewController = exploreStoryboard.instantiateViewController(withIdentifier: "ExploreLandingVC") as? ExploreLandingVC
            self.slideMenuController()?.changeMainViewController(exploreLandingViewController!, close: true)
        }
    }
    
    func signInAction(viewController: UIViewController? = nil) {
        self
            .onLoginSuccess { [weak self] in
                if let vc = viewController {
                    self?.tempViewController = vc
                }
//                self?.setView()
                self?.slideMenuController()?.closeLeft()
                self?.stopActivityIndicator()
                if let viewController = self?.tempViewController {
                        self?.slideMenuController()?.changeMainViewController(viewController, close: true)
                    self?.tempViewController = nil
                }
            }
            .onLoginError(error: { [weak self] (error) in
                self?.stopActivityIndicator()
                self?.showErrorView(errorMsg: error)
            })
            .signInPopUp()
    }
}

extension LeftMenuViewController {
    fileprivate func configureCell(cell: LeftMenuCustomCell, indexPath: IndexPath) {
        let item: Item = sections[indexPath.section].items[indexPath.row]
        
        cell.cellModel = item
        
        let leadingConstant = (item.ItemID == LeftMenuSections.eShopOnlineViaPaybackVC.rawValue) || (item.ItemID == LeftMenuSections.eOtherOnlinepartnersVC.rawValue) ? 40 : 25
        cell.update(leadingConstraint: CGFloat(leadingConstant))
    }
}

extension LeftMenuViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 0 : sections[section].items.count
    }
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leftmenuCollectionCell") as? LeftMenuCustomCell
        configureCell(cell: cell!, indexPath: indexPath)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DeviceType.IS_IPAD ? 55 : 44.0 //UITableViewAutomaticDimension
    }
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? LeftMenuTableviewHeader ?? LeftMenuTableviewHeader(reuseIdentifier: "header")
        header.titleLabel.text = sections[section].name
        header.titleLabel.tag = section
        header.arrowLabel.text = "+"
        header.arrowLabel.tag = section
        header.setCollapsed(sections[section].collapsed)
        header.section = section
        header.delegate = self
        return header
    }
}

extension LeftMenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowAtIndexPath = sections[indexPath.section].items[indexPath.row].ItemID
        if let menu = LeftMenuSections(rawValue: rowAtIndexPath!) {
            self.changeViewControllerSectionInRow(menu)
        }
    }
}
// MARK: - Section Header Delegate
extension LeftMenuViewController: CollapsibleTableViewHeaderDelegate {
    func headerTitleScection(_ header: LeftMenuTableviewHeader, section: Int) {
        //if let headerMenu = LeftMenuHeader(rawValue: section) {
        // self.changeHeaderViewController(headerMenu)
        //}
        self.toggleSection(header, section: section)
    }
    func toggleSection(_ header: LeftMenuTableviewHeader, section: Int) {
        
        if previousSection != -1 {
            if previousSection == section {
                let collapsed = !sections[previousSection].collapsed
                // Toggle collapse
                sections[previousSection].collapsed = collapsed
                header.setCollapsed(collapsed)
                previousSection = -1
            } else {
                let collapsed = !sections[section].collapsed
                // Toggle collapse
                sections[section].collapsed = collapsed
                header.setCollapsed(collapsed)
                
                let collapsed1 = !sections[previousSection].collapsed
                // Toggle collapse
                sections[previousSection].collapsed = collapsed1
                header.setCollapsed(collapsed1)
                
                previousSection = section
            }
        } else {
            let collapsed = !sections[section].collapsed
            // Toggle collapse
            sections[section].collapsed = collapsed
            header.setCollapsed(collapsed)
            previousSection = section
        }
        //tableview.reloadData()
        tableview.reloadSections([section], with: .automatic)
       
        //        let collapsed = !sections[section].collapsed
        //        // Toggle collapse
        //        sections[section].collapsed = collapsed
        //        header.setCollapsed(collapsed)
        //        tableview.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}
extension LeftMenuViewController {
    private func openAlertPopupForEditProfile(_ menu: LeftMenuSections) {
        self.openAlertPopupForEditProfile()
        self.slideMenuController()?.closeLeft()
        self.onAlertPopupForEditProfile { [weak self] in
            self?.changeViewControllerSectionInRow(menu)
        }
    }
}
