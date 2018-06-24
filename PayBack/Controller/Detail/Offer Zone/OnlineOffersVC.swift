//
//  OnlineOffersVC.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 06/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class OnlineOffersVC: BaseViewController {
    fileprivate var totalCount = 0
    fileprivate var lastId = 0
    fileprivate var isLoadMore = false
    fileprivate let collectionViewCellId = "CVCellId"
    fileprivate var noDataText = ""

    @IBOutlet weak private var navigationView: DesignableNav!
    @IBOutlet weak fileprivate var collectionView: UICollectionView!
    @IBOutlet weak fileprivate var segmentView: CustomSegmentView!
    @IBOutlet weak fileprivate var carouselView: PBCarousel!
    @IBOutlet weak fileprivate var carouselViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak private var enableLocationButton: UIButton!
    @IBAction func enableLocationButtonAction(_ sender: UIButton) {
        LocationManager.sharedLocationManager.openLocationSetting()
    }
    
    var categoryType: CategoryType = .none
    fileprivate var networkController: OfferZoneNWController!
    fileprivate var offerCarousel: OfferCarousel!
    fileprivate var offerZoneMenuCategory: OfferZoneMenuCategory!
    fileprivate var offerZoneCategoryDetails: OfferZoneCategoryDetails!
    
    fileprivate var segmentTitles: [SegmentCollectionViewCellModel] = [] {
        didSet {
            let font: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 15 : 25
            let segmentConfig = SegmentCVConfiguration()
                .set(title: segmentTitles)
                .set(numberOfItemsPerScreen: 4)
                .set(isImageIconHidden: true)
                .set(fontandsize: FontBook.Regular.of(size: font))
                .set(selectedIndex: defaultSelectedIndex)
                .set(deviderColor: .white)
            
            segmentView.configuration = segmentConfig
            
            segmentView.configuration?.selectedCompletion = { [weak self] (segmentModel, index) in
                if let strongSelf = self {
                    strongSelf.switchTabs(index)
                }
            }
            self.collectionView.isScrollEnabled = true
        }
    }
    var defaultSelectedIndex = 0
    fileprivate var cellModel: [CouponsRechargeCellModel] = []
    
    fileprivate var viewPageStack: [String: [String: Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorConstant.vcBGColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = ColorConstant.vcBGColor
        
        networkController = OfferZoneNWController()
        offerCarousel = OfferCarousel(networkController: networkController, categoryType: self.categoryType)
        offerZoneMenuCategory = OfferZoneMenuCategory(networkController: networkController, categoryType: self.categoryType)
        offerZoneCategoryDetails = OfferZoneCategoryDetails(networkController: networkController, categoryType: self.categoryType)
        setNavigationBar()
        setupCarouselView()
        registerCells()
        viewPageStack = [:]
        if self.checkConnection() {
            refreshableAPIs()
            if categoryType != .inStoreOffer {
                fetchSegmentTitles()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.checkConnection() {
            refreshableAPIs()
        }
        if categoryType == .inStoreOffer {
            NotificationCenter.default.addObserver(self, selector: #selector(fetchSegmentTitles), name: Notification.Name(LocationFound), object: nil)
            self.appViewSetUp()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(LocationFound), object: nil)
    }
    override func willEnterForeground() {
        if self.checkConnection() {
            refreshableAPIs()
        }
        if categoryType == .inStoreOffer {
            self.appViewSetUp()
        }
    }
    override func connectionSuccess() {
        refreshableAPIs()
        fetchSegmentTitles()
    }
    
    override func userLogedIn(status: Bool) {
        guard status else {
            return
        }
        if status, let link = redirectUrl, link != "" {
            self.redirect(redirectLink: link, redirectLogoUrl: self.partnerlogoUrl ?? "")
            self.redirectUrl = ""
            self.partnerlogoUrl = ""
        } else {
            self.redirectUrl = ""
            self.partnerlogoUrl = ""
        }
    }
    deinit {
        print(" OnlineOffersVC deinit called")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(LocationFound), object: nil)
    }
    
    private func setNavigationBar() {
        if categoryType == .inStoreOffer {
            navigationView.title = "Nearby"
        } else if categoryType == .onlineOffer {
            navigationView.title = "ONLINE OFFERS"
        }
        if categoryType == .recharge {
            navigationView.title = "RECHARGE OFFERS"
        } else if categoryType == .coupans {
            navigationView.title = "COUPONS"
        }
    }
    private func setupCarouselView() {
        let configuration = PBCarouselConfiguration()
            .set(collectionViewBounce: true)
            .set(collectionViewCellName: .partnerDetailCarousel)
            .set(isHeroCarousel: true)
        
        carouselView.confugure(withConfiguration: configuration)
        
        self.carouselViewHeightContraint.constant = Carousel_Height
    }
    
    private func registerCells() {
        collectionView.register(PBOfferContentCVCell.self, forCellWithReuseIdentifier: collectionViewCellId)
        collectionView.isScrollEnabled = false
    }
}
// Redirection ViewController
extension OnlineOffersVC {
    func redirect(redirectLink: String, redirectLogoUrl: String) {
        self.redirectVC(redirectLink: redirectLink, redirectLogoUrl: redirectLogoUrl)
    }
}
extension OnlineOffersVC {
    fileprivate func refreshableAPIs() {
        offerCarousel
            .onCarouselSuccess { [weak self] (carouselData) in
                self?.updateCarouselHeightContraint(carouselData: carouselData)
            }
            .onCasouselError { [weak self] (error) in
                print("\(error)")
                self?.updateCarouselHeightContraint(carouselData: nil)
            }
            .fetchCarousel()
    }
    @objc fileprivate func fetchSegmentTitles() {
        self.startActivityIndicator()
        offerZoneMenuCategory
            .onMenuCategorySuccess { [weak self] (segmentTitles) in
                self?.segmentTitles = segmentTitles
                self?.stopActivityIndicator()
            }
            .onMenuCategoryError { [weak self] (error) in
                print("\(error)")
                self?.stopActivityIndicator()
            }
            .fetchMenuCategory(location: LocationManager.sharedLocationManager.currectUserLocation)
    }
    fileprivate func fetchInStorOrOnlineOffers(withCategory categoryTag: String, isLoadMore: Bool) {
        if !isLoadMore {
            self.startActivityIndicator()
        }
        offerZoneCategoryDetails
            .onCategoryDetailsSuccess { [weak self] (couponsDetails, totalCount) in
                self?.stopActivityIndicator()
                self?.totalCount = totalCount
                self?.cellModel += couponsDetails
                self?.lastId = self?.cellModel.count ?? 0
                self?.storeDataInDictionary(self?.cellModel, categoryTag: categoryTag)
                if (self?.cellModel.isEmpty)! {
                    self?.noDataText = StringConstant.No_Data_Found
                }
                self?.collectionView.reloadData()
            }
            .onCategoryDetailsError { [weak self] _ in
                self?.stopActivityIndicator()
                self?.cellModel += []
                self?.storeDataInDictionary(self?.cellModel, categoryTag: categoryTag)
                if (self?.cellModel.isEmpty)! {
                    self?.noDataText = StringConstant.No_Data_Found
                }
                self?.collectionView.reloadData()
            }
            .fetchCategoryDetails(withCategory: categoryTag, lastId: lastId, location: LocationManager.sharedLocationManager.currectUserLocation)
    }
}
extension OnlineOffersVC {
    fileprivate func updateCarouselHeightContraint(carouselData: [HeroBannerCellModel]?) {
        guard let slides = carouselData else {
            self.carouselViewHeightContraint.constant = 0
            return
        }
        self.carouselView.slides = slides
        
        self.carouselView.cellActionHandler = { [weak self] index in
            let cellData = slides[index]
            if let urlString = cellData.redirectionURL {
                self?.redirect(redirectLink: urlString, redirectLogoUrl: cellData.redirectionPartnerLogo ?? "")
            }
        }
    }
}
    
// MARK: - Table view data source
extension OnlineOffersVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellId, for: indexPath) as? PBOfferContentCVCell
        cell?.redirectUrl(closure: { [weak self] (redirectUrl, redirectLogoUrl) in
            self?.redirect(redirectLink: redirectUrl, redirectLogoUrl: redirectLogoUrl)
        })
        cell?.backgroundColor = .clear
        cell?.loadMoreClosure = { [weak self]  in
            self?.isLoadMore = true
            let categoryTag = self?.segmentTitles[indexPath.item].itemId! ?? ""
            self?.fetchInStorOrOnlineOffers(withCategory: categoryTag, isLoadMore: true)
        }
        cell?.distanceActionClosure = { [weak self] (sender) in
            if let locations = self?.cellModel[sender.tag].storeLocations {
                self?.openMap(locations, sender: sender)
            }
        }
        return cell!
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PBOfferContentCVCell else {
            return
        }
        cell.categoryType = categoryType
        cell.loadMoreInfo = (totalCount, lastId, isLoadMore, noDataText)
        cell.cellModel = cellModel
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.move().x / self.view.frame.width
        scrollSegment(to: Int(index))
    }
}

extension OnlineOffersVC {
    fileprivate func storeDataInDictionary(_ cellModel: [CouponsRechargeCellModel]?, categoryTag: String) {
        var stack: [String: Any] = [:]
        if let model = cellModel {
            let firstTenModel = Array(model.prefix(20))
            stack["model"] = firstTenModel
        }
        stack["lastId"] = 20
        stack["totalCount"] = totalCount
        viewPageStack[categoryTag] = stack
    }
    func switchTabs(_ index: Int) {
        defaultSelectedIndex = index
        lastId = 0
        totalCount = 0
        let indexPath = IndexPath(item: index, section: 0)
        if collectionView.numberOfItems(inSection: 0) > indexPath.item {
            collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        let categoryTag = segmentTitles[indexPath.item].itemId!
        cellModel.removeAll()
        self.isLoadMore = false
        
        if let pageStack = viewPageStack, let stack = pageStack[categoryTag] {
            if let model = stack["model"] as? [CouponsRechargeCellModel] {
                self.cellModel = model
                if cellModel.isEmpty {
                    noDataText = StringConstant.No_Data_Found
                }
                self.collectionView.reloadData()
            }
            lastId = stack["lastId"] as? Int ?? 0
            totalCount = stack["totalCount"] as? Int ?? 0
            
        } else {
            self.fetchInStorOrOnlineOffers(withCategory: categoryTag, isLoadMore: false)
        }
    }
    
    func scrollSegment(to index: Int) {
        segmentView?.selectSegmentAtIndex(index)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension OnlineOffersVC {
    @objc private  func appViewSetUp() {
        LocationManager.sharedLocationManager.initializeLocationManager()
        if LocationManager.sharedLocationManager.loacationServiceEnabled() {
            print("Location enabled")
            enableLocationButton.isHidden = true
            collectionView.isHidden = false
            segmentView.isHidden = false
        } else {
            print("Location Disabled")
            enableLocationButton.isHidden = false
            collectionView.isHidden = true
            segmentView.isHidden = true
        }
    }
}
