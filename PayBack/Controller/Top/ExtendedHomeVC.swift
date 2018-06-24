//
//  ExtendedHomeVC.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 5/14/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit
import Crashlytics
import FirebasePerformance

enum ExtentedHomeCellType {
    case tiles
    case nearbuyOffers
    case showcase
    case none
}
typealias ShowCaseTuple = (items: [HomeShowCaseCVCellModel], carousels: [HeroBannerCellModel], title: String, type: String)

class ExtendedHomeVC: BaseViewController {
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet weak fileprivate var currentPointLabel: UILabel!
    @IBOutlet weak fileprivate var nameLabel: UILabel!
    @IBOutlet weak var homeHeaderView: UIView!
    @IBOutlet weak var barcodeButton: UIButton!
    
    fileprivate var sections: [ExtentedHomeCellType] = []
    fileprivate var showCaseDataArray: [ShowCaseTuple] = []
    fileprivate var imageGrid: [LandingTilesGridCellModel] = []
    fileprivate var viewModel: ExtendedHomeVM!
    fileprivate var locationAlertView: PBLocationAlertView?
    
    fileprivate var nearbuyOffersData: [InstoreListTVCellModel] = []
    fileprivate var isBarCodeAction = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.textColor = ColorConstant.textColorWhite
        self.currentPointLabel.font = FontBook.Roboto.of(size: 22.5)
        self.view.backgroundColor = ColorConstant.vcBGColor
        self.barcodeButton.backgroundColor = .clear
        self.homeHeaderView.isHidden = true
        setupTableView()
        setupViewModel()
        sections = [.tiles, .showcase, .nearbuyOffers]
        
        for i in 0...50 {
            self.perform(#selector(test(a:)), with: i, afterDelay: 1)
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
//                self.test(a: i)
//            }
        }
    }
    @objc func test(a: Int) {
        print("Print: \(a)")
    }
    override func connectionSuccess() {
        self.fetchData()
    }
    private func fetchData() {
        self.viewModel.refresh()
        self.fetchNearBuyOffers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchNearBuyOffers), name: NSNotification.Name(LocationFound), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundd), name: .UIApplicationWillEnterForeground, object: nil)
        if self.checkConnection() {
            self.fetchData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(LocationFound), object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillEnterForeground, object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        print("ExtendedHomeVC: deinit called")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(LocationFound), object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillEnterForeground, object: nil)

    }
    
    override func userLogedIn(status: Bool) {
        self.updateUserDetails()
        guard status else {
            isBarCodeAction = false
            return
        }
        if isBarCodeAction {
            isBarCodeAction = false
            self.redirectToBarcodeVC()
            return
        }
        if status, let link = redirectUrl, link != "" {
            self.redirectVC(redirectLink: link, redirectLogoUrl: self.partnerlogoUrl)
        } else {
            self.redirectUrl = ""
            self.partnerlogoUrl = ""
        }
    }
    @objc func willEnterForegroundd() {
        self.viewModel.refresh()
        LocationManager.sharedLocationManager.initializeLocationManager()
        print("ExtendedHomeVC: Will Enter foreground called")
        if !LocationManager.sharedLocationManager.loacationServiceEnabled() {
            self.fetchNearBuyOffers()
        }
    }
    @IBAction func barcodeAction(_ sender: UIButton) {
        let userLogedIn = UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged)
        guard userLogedIn else {
            isBarCodeAction = true
            self.signInPopUp()
            return
        }
        self.redirectToBarcodeVC()
    }
    private func redirectToBarcodeVC() {
        if let vc = PBBarCodeViewController.storyboardInstance(storyBoardName: "Main") as? PBBarCodeViewController {
            vc.mobileNumString = UserProfileUtilities.getUserDetails()?.MobileNumber ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension ExtendedHomeVC {
    fileprivate func setupTableView() {
        tableView.estimatedRowHeight = 320
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(PBBaseControllerTableViewCell.self, forCellReuseIdentifier: Cells.pbBaseControllerTableViewCell)
        tableView.register(HomeShowCaseTVCell.self, forCellReuseIdentifier: Cells.homeShowCaseTVCell)
        tableView.register(UINib(nibName: Cells.instoreListTVCell, bundle: nil), forCellReuseIdentifier: Cells.instoreListTVCell)
    }
    fileprivate func setupViewModel() {
        viewModel = ExtendedHomeVM()
        viewModel.errorHandler = { [weak self] in
            self?.openErrorView(withMessage: StringConstant.timeOutMessage)
        }
        viewModel.bindToHomeAEMContentViewModels = { [weak self] in
            self?.updateUserDetails()
            self?.imageGrid = (self?.viewModel.getImageGrid())!
            self?.showCaseDataArray = (self?.viewModel.getShowCaseContent())!
            for showCaseTuple in (self?.showCaseDataArray)! {
                if showCaseTuple.type == "earn-deal" {
                    //self?.viewModel.fetchTopTrends(parameters: ShopOnlineProductParamsModel())
                    self?.viewModel.fetchShopOnlinePartners()
                } else if showCaseTuple.type == "earn-cagtegory" {
                    self?.viewModel.fetchTopTrends(parameters: ShopOnlineProductParamsModel())
                } else if showCaseTuple.type == "redeem-deal" {
                    self?.viewModel.fetchRecommendedDeals(limit: "10")
                } else if showCaseTuple.type == "redeem-cagtegory" {
                    self?.viewModel.fetchRecommendedDeals(limit: "10")
                }
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
//        viewModel.bindToTrendingViewModels = { [weak self] in
//            let indexPath = IndexPath(row: 0, section: 1)
//            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
        viewModel.bindToRecommenedDealViewModels = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.bindToNearbuyOffersViewModels = { [weak self] in
            self?.fetchNearBuyOffers()
        }
        viewModel.bindToOnlinePartnersViewModels = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    @objc func fetchNearBuyOffers() {
        if LocationManager.sharedLocationManager.loacationServiceEnabled() {
            hideLocationAlert()
            if let sourceData = self.viewModel.nearbuyOffersViewModel {
                nearbuyOffersData = sourceData
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                if let loc = LocationManager.sharedLocationManager.currectUserLocation {
                    self.viewModel.fetchInStoreListNear(currentLocation: loc.coordinate)
                }
            }
        } else {
            nearbuyOffersData = self.mockNearbuyOffers()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
extension ExtendedHomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .tiles:
            return imageGrid.count
        case .showcase:
            return showCaseDataArray.count
        case .nearbuyOffers:
            return nearbuyOffersData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .tiles:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.pbBaseControllerTableViewCell, for: indexPath) as? PBBaseControllerTableViewCell
            cell?.staticData = imageGrid[indexPath.row]
            return cell!
        case .showcase:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.homeShowCaseTVCell, for: indexPath) as? HomeShowCaseTVCell else {
                return UITableViewCell()
            }
            configureShowCaseCell(indexPath, cell)
            return cell
        case .nearbuyOffers:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.instoreListTVCell, for: indexPath) as? InstoreListTVCell else {
                return UITableViewCell()
            }
            configureNearbuyOffersCell(cell, indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            return cell
        }
    }
}
extension ExtendedHomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case .tiles:
            return HomeTiles_Height
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if sections[section] == .nearbuyOffers {
            let view = NearBuyOffersHeader()
            return view
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sections[section] == .nearbuyOffers, !nearbuyOffersData.isEmpty {
            return 50
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .tiles:
            switch imageGrid[indexPath.row].uniqueKey {
            case "1":
                let earnLanding = EarnLandingVC.storyboardInstance(storyBoardName: "Earn")
                self.show(earnLanding!, sender: nil)
            case "2":
                let burnLanding = BurnLandingVC.storyboardInstance(storyBoardName: "Burn")
                self.show(burnLanding!, sender: nil)
            case "3":
                let offerLanding = OfferLandingVC.storyboardInstance(storyBoardName: "OfferZone")
                self.show(offerLanding!, sender: nil)
            case "4":
                let exploreLanding = ExploreLandingVC.storyboardInstance(storyBoardName: "Explore")
                self.show(exploreLanding!, sender: nil)
            default:
                break
            }
        case .nearbuyOffers:
            let data = nearbuyOffersData[indexPath.row]
            if let url = data.url {
                self.redirectVC(redirectLink: url, redirectLogoUrl: data.imageUrl ?? "")
            }
        default:
            break
        }
    }
}
extension ExtendedHomeVC {
    fileprivate func configureShowCaseCell(_ indexPath: IndexPath, _ cell: HomeShowCaseTVCell) {
        var showcaseTuple = showCaseDataArray[indexPath.row]
        if  showcaseTuple.type == "earn-deal" {
            var deals = [HomeShowCaseCVCellModel]()
            if let trendingDeal = self.viewModel.onlinePartnersViewModel {
                deals = trendingDeal
            }
            showcaseTuple = (deals, showcaseTuple.carousels, showcaseTuple.title, showcaseTuple.type)
            cell.showCaseData = showcaseTuple
        } else if showcaseTuple.type == "redeem-deal" || showcaseTuple.type == "redeem-cagtegory" {
            var deals = [HomeShowCaseCVCellModel]()
            if let recommendedDeal = self.viewModel.recommendedDealsViewModel {
                deals = recommendedDeal
            }
            showcaseTuple = (deals, showcaseTuple.carousels, showcaseTuple.title, showcaseTuple.type)
            cell.showCaseData = showcaseTuple
        } else if showcaseTuple.type == "promotion" {
            cell.showCaseData = showCaseDataArray[indexPath.row]
        }
        cell.tapOnCarousel = { [weak self] (link, logoPath) in
            self?.redirectVC(redirectLink: link, redirectLogoUrl: logoPath)
        }
        cell.cellTapClosure = { [weak self] (index) in
            if let strongSelf = self, let partnerDetails = self?.viewModel.onlinePartner?.partnerDetails {
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
            partnerDetailsVC.onlinePartner = (self.viewModel.onlinePartner, index) as? (OtherPartner, Int)
            navigationController?.pushViewController(partnerDetailsVC, animated: true)
        }
    }
    fileprivate func configureNearbuyOffersCell(_ cell: InstoreListTVCell, _ indexPath: IndexPath) {
        cell.sourceData = nearbuyOffersData[indexPath.row]
        cell.set(distanceButtonTag: indexPath.row)
        if cell.sourceData?.isOverLayDisplay == true, indexPath.row == 1 {
            self.showLocationAlert(cell: cell)
        }
        cell.distanceActionClosure = { [weak self] (sender) in
            if let locations = cell.sourceData?.storeLocations {
                self?.openMap(locations, sender: sender)
            }
        }
    }
}
extension ExtendedHomeVC {
    func showLocationAlert(cell: InstoreListTVCell) {
        self.hideLocationAlert()
        if locationAlertView == nil {
            locationAlertView = Bundle.main.loadNibNamed("PBLocationAlertView", owner: self, options: nil)?.first as? PBLocationAlertView
            locationAlertView?.frame = CGRect(x: 15, y: 10, width: cell.frame.width - 30, height: 120)
            locationAlertView?.layer.cornerRadius = 3
            cell.addSubview(locationAlertView!)
            locationAlertView?.okButtonClouser = { [weak self] in
                if let strongSelf = self {
                    strongSelf.locationAlertOKButtonAction()
                }
            }
            
            locationAlertView?.cancelButtonClouser = { [weak self] in
                if let strongSelf = self {
                    strongSelf.locationAlertCancelButtonAction()
                }
            }
        }
    }
    
    func locationAlertOKButtonAction() {
        LocationManager.sharedLocationManager.openLocationSetting()
    }
    
    func locationAlertCancelButtonAction() {
        
    }
    
    func hideLocationAlert() {
        locationAlertView?.removeFromSuperview()
        locationAlertView = nil
    }
}
extension ExtendedHomeVC {
    
    fileprivate func updateUserDetails() {
        self.homeHeaderView.isHidden = false
        let headerConfiguration = self.viewModel.getHeaderCongifuration()
        if let headerBGColor = headerConfiguration.headerBGColor, headerBGColor != "" {
            self.homeHeaderView.backgroundColor = UIColor(hex: headerBGColor)
        }
        self.barcodeButton.downloadImageFromUrl(urlString: headerConfiguration.headerBarCodeIcon ?? "")
        let color = UIColor(hex: headerConfiguration.headerTextColor ?? "#FFFFFF")
        self.nameLabel.textColor = color
        self.currentPointLabel.textColor = color

        if self.isUserLogedIn {
            guard let userDetails = UserProfileUtilities.getUserDetails() else {
                return
            }
            var name: String = ""
            if let firstName = userDetails.FirstName {
                name = firstName
            }
            if let lastName = userDetails.LastName {
                name += " "+lastName
            }
            if name != "" {
                self.nameLabel.text = "\(name)!"
            } else {
                self.nameLabel.text = ""
            }
            self.currentPointLabel.text = "Current Point Balance:"
            if let points = userDetails.TotalPoints {
                self.currentPointLabel.attributedText = getAttributedTextForPoints(changingValues: points, color: color)
            }
        } else {
            self.nameLabel.text = headerConfiguration.headerNonLogInTxt ?? ""//"Welcome!"
            self.currentPointLabel.text = headerConfiguration.headerNonLogInDescTxt ?? "" //getAttributedTextForPoints(changingValues: "")
            self.currentPointLabel.font = FontBook.Regular.of(size: 14)
        }
    }
    
    fileprivate func getAttributedTextForPoints(changingValues: String, color: UIColor) -> NSAttributedString {
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .left
        
        if changingValues.isEmpty {
            return NSMutableAttributedString(string: "Enter the world of rewarding journey", attributes: [NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: FontBook.Regular.of(size: 14) as Any, NSAttributedStringKey.paragraphStyle: titleParagraphStyle])
        }
        
        let staticValue = NSMutableAttributedString(string: "Current Point Balance: ", attributes: [NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: FontBook.Regular.of(size: 14) as Any, NSAttributedStringKey.paragraphStyle: titleParagraphStyle])
        
        let changingText = NSMutableAttributedString(string: "\(changingValues) \(StringConstant.pointsSymbol)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: FontBook.Regular.of(size: 14) as Any, NSAttributedStringKey.paragraphStyle: titleParagraphStyle])
        
        let combination = NSMutableAttributedString()
        
        combination.append(staticValue)
        combination.append(changingText)
        
        return combination
    }
}

// MOCK
extension ExtendedHomeVC {
    fileprivate func mock() -> [LandingTilesGridCellModel] {
        let data1 = LandingTilesGridCellModel(image: #imageLiteral(resourceName: "demo"), title: "Earn", icon: #imageLiteral(resourceName: "demo2"))
        let data2 = LandingTilesGridCellModel(image: #imageLiteral(resourceName: "demo"), title: "Burn", icon: #imageLiteral(resourceName: "demo2"))
        let data3 = LandingTilesGridCellModel(image: #imageLiteral(resourceName: "demo"), title: "Offer Zone", icon: #imageLiteral(resourceName: "offeractivated"))
        let data4 = LandingTilesGridCellModel(image: #imageLiteral(resourceName: "demo"), title: "Explore", icon: #imageLiteral(resourceName: "locationwhite"))
        
        return [data1, data2, data3, data4]
    }
    fileprivate func mockShopAndEarnPoints() -> [HomeShowCaseCVCellModel] {
        let data = HomeShowCaseCVCellModel(partnerImage: #imageLiteral(resourceName: "Sample_4"), itemImage: #imageLiteral(resourceName: "Sample_6"), title: "Shop And Earn Points", actualPrice: "1000", finalPrice: "500", points: "200")
        
        return [data, data, data, data]
    }
    fileprivate func mockInstantVoucher() -> [HomeShowCaseCVCellModel] {
        let data = HomeShowCaseCVCellModel(itemImage: #imageLiteral(resourceName: "placeholder"), title: "Shop And Earn Points", buyButtonTitle: "Buy")
        
        return [data, data, data, data]
    }
    fileprivate func mockShopWithPoints() -> [HomeShowCaseCVCellModel] {
        let data = HomeShowCaseCVCellModel(itemImage: #imageLiteral(resourceName: "Sample_6"), title: "Shop And Earn Points", pointText: "4443" )
        
        return [data, data, data, data]
    }
    func mockCarouselData() -> [HeroBannerCellModel] {
        let slide2 = HeroBannerCellModel(image: #imageLiteral(resourceName: "demo2"))
        let slide3 = HeroBannerCellModel(image: #imageLiteral(resourceName: "demo"))
        let slide4 = HeroBannerCellModel(image: #imageLiteral(resourceName: "demo2"))
        let slides = [slide2, slide3, slide4]
        return slides
    }
    
    func mockNearbuyOffers() -> [InstoreListTVCellModel] {
        let data1 = InstoreListTVCellModel(storeLogo: #imageLiteral(resourceName: "placeholder"), storeMsg: "Fastrack e-gift card worth Rs. 1,000", storeName: "Fastrack", storeDistance: "2 Kms", storeAddress: "DLF Cyber City", isOverLayDisplay: true)
        let data2 = InstoreListTVCellModel(storeLogo: #imageLiteral(resourceName: "placeholder"), storeMsg: "Fabindia e-gift card worth Rs. 1,000", storeName: "Fabindia", storeDistance: "2 Kms", storeAddress: "MGF Mall, Gurgaon", isOverLayDisplay: true)
        let data3 = InstoreListTVCellModel(storeLogo: #imageLiteral(resourceName: "placeholder"), storeMsg: "Shoppers Stop gift cards worth Rs. 1,000", storeName: "Shoppers Stop", storeDistance: "2 Kms", storeAddress: "MGF Mall, Gurgaon", isOverLayDisplay: true)
        let data4 = InstoreListTVCellModel(storeLogo: #imageLiteral(resourceName: "placeholder"), storeMsg: "Big Bazaar e-gift card worth Rs.1,000", storeName: "Big Bazaar", storeDistance: "2 Kms", storeAddress: "Big Bazaar", isOverLayDisplay: true)
        
        return [data1, data2, data3, data4]
    }
}
