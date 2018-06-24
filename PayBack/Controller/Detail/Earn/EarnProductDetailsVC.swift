//
//  PBProductDetailsViewController.swift
//  PaybackPopup
//
//  Created by Mohsin Surani on 8/22/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class EarnProductDetailsVC: BaseViewController {
    
    @IBOutlet weak private var emptyLabel: UILabel!
    @IBOutlet weak private var wishButton: UIButton!
    @IBOutlet weak private var shareButton: UIButton!
    @IBOutlet weak private var shopButton: UIButton!
    @IBOutlet weak private var viewShadow: UIView!
    @IBOutlet weak private var emptyView: UIView!
    @IBOutlet weak fileprivate var productTableview: UITableView!
    fileprivate var isWishList = false
    fileprivate var isShare = false
    
    fileprivate var compareViewDataSource: [CompareCellModel] = [] {
        didSet {
            self.productTableview.reloadData()
        }
    }
    fileprivate var reviewViewDataSource: [ReviewCellModel] = [] {
        didSet {
            self.productTableview.reloadData()
        }
    }
    fileprivate var specifyViewDataSource: [SpecificationCellModel] = [] {
        didSet {
            self.productTableview.reloadData()
        }
    }
    fileprivate var productType: ProductCategoryType = .compare
    fileprivate var cellHeights = [IndexPath: CGFloat]()
    let earnProductDetailNWController = EarnProductDetailsNWController()
    fileprivate var productDetailsData: EarnProductDetails? {
        didSet {
            self.productTableview.reloadData()
        }
    }
    fileprivate var reviewErrorMsg: String? {
        didSet {
            self.productTableview.reloadData()
        }
    }
    var productID: String? = ""
    var shareUrl: String = ""
    var disableViewAll: Bool = false
    fileprivate let viewAllDataCellId = "viewAllDataCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.redirectUrl = nil
        self.partnerlogoUrl = nil
        loadCellNibs()
        addTempData()
        UIchangesforEarnViews(sender: shopButton)
        addShadowBorder()
        productTableview.tableFooterView = UIView(frame: .zero)
        wishButton.titleLabel?.font = FontBook.Regular.of(size: 15.0)
        shareButton.titleLabel?.font = FontBook.Regular.of(size: 15.0)
        shopButton.titleLabel?.font = FontBook.Regular.of(size: 15.0)
        emptyView.backgroundColor = ColorConstant.leftRightMenuBgColor
        emptyLabel.font = FontBook.Regular.of(size: 17.0)
        emptyView.isHidden = false
        emptyLabel.text = ""
        
        if self.checkConnection() {
            callNetworkApi()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "WishListButtonTitleChanged"), object: nil, queue: nil) { [weak self] (notification) in
            guard let model = notification.object as? WishListCellModel else {
                return
            }
            if self?.productDetailsData?.metaInfo?.id == model.productId {
                self?.wishButton.setTitle("WISHLIST", for: .normal)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func connectionSuccess() {
        callNetworkApi()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "WishListButtonTitleChanged"), object: nil)
        super.viewWillDisappear(animated)
    }
    
    private func callNetworkApi() {
        self.startActivityIndicator()
        earnProductDetailNWController
            .onError { [weak self] (error) in
                self?.showErrorView(errorMsg: error)
                 self?.stopActivityIndicator()
            }
            .onSuccess { [weak self] (ProductDetailModel) in
                if ProductDetailModel.metaInfo?.id != nil {
                    self?.emptyView.isHidden = true
                    self?.updateProductDetails(productDetails: ProductDetailModel)
                } else {
                    self?.emptyLabel.text = "Details not found"
                }
                self?.stopActivityIndicator()
            }
            .getEarnProductDetails(productID: productID ?? "")
        
        earnProductDetailNWController
            .onComparePrize { [weak self] (compareCellModel) in
                self?.compareViewDataSource = compareCellModel
        }
        earnProductDetailNWController.onSpecification { [weak self] (specificCellModel) in
            self?.specifyViewDataSource = specificCellModel
        }
        earnProductDetailNWController.onReview { [weak self] (reviewModel, error) in
            if let reviewModel = reviewModel {
                self?.reviewViewDataSource = reviewModel
            } else {
                self?.reviewErrorMsg = error
            }
        }
    }
    
    private func addShadowBorder() {
        viewShadow.layer.masksToBounds = false
        viewShadow.layer.shadowColor = UIColor.lightGray.cgColor
        viewShadow.layer.shadowOpacity = 2
        viewShadow.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewShadow.layer.shadowRadius = 2
        
        DispatchQueue.main.async { [weak self] in
            self?.shareButton.layer.addBorder(edge: .left, color: .lightGray, thickness: 0.5)
            self?.shareButton.layer.addBorder(edge: .right, color: .lightGray, thickness: 0.5)
        }
    }
    
    func updateProductDetails(productDetails: EarnProductDetails) {
        self.productDetailsData = productDetails
    }
    private func loadCellNibs() {
        
        productTableview.register(UINib(nibName: Cells.earnProductDetailHeaderCell, bundle: nil), forCellReuseIdentifier: Cells.earnProductDetailHeaderCell)
        productTableview.register(UINib(nibName: Cells.compareCellNibID, bundle: nil), forCellReuseIdentifier: Cells.compareCellNibID)
        productTableview.register(UINib(nibName: Cells.specifyCellNibID, bundle: nil), forCellReuseIdentifier: Cells.specifyCellNibID)
        productTableview.register(UINib(nibName: Cells.reviewCellNibID, bundle: nil), forCellReuseIdentifier: Cells.reviewCellNibID)
        productTableview.register(UINib(nibName: Cells.avgRatingCellNibID, bundle: nil), forCellReuseIdentifier: Cells.avgRatingCellNibID)
        productTableview.register(UITableViewCell.self, forCellReuseIdentifier: viewAllDataCellId)
        productTableview.register(NoDataFoundTVCell.self, forCellReuseIdentifier: Cells.noDataFoundTVCell)
    }
    
    @IBAction func wishlistAction(_ sender: UIButton) {
        guard self.wishButton.titleLabel?.text != "GO TO WishList" else {
            self.goToWishListScreen()
            return
        }
        isWishList = true
        let userLogedIn = UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged)
        guard userLogedIn else {
            self
                .onLoginSuccess { [weak self] in
                    self?.addToWishList(sender: (self?.wishButton)!)
                }
                .onLoginError(error: { [weak self] (error) in
                    self?.showErrorView(errorMsg: error)
                })
                .signInPopUp()
            return
        }
        self.addToWishList(sender: sender)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        //UIchangesforEarnViews(sender: sender)
        if self.shareUrl != "" {
            let activityViewController = UIActivityViewController(activityItems: [self.shareUrl as Any], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = sender
            
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop]
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func shopNowAction(_ sender: UIButton) {
      //  UIchangesforEarnViews(sender: sender)
        let linkUrl: String? = productDetailsData?.metaInfo?.storeLink
        let logoUrl: String = productDetailsData?.metaInfo?.storeLogo ?? ""
        
        if let url = linkUrl {
            self.redirectVC(redirectLink: url, redirectLogoUrl: logoUrl)
        }
    }
    override func userLogedIn(status: Bool) {
        guard status else {
            return
        }
        if isWishList || isShare {
            isWishList = false
            isShare = false
            return
        }
        if status && self.redirectUrl != nil && self.redirectUrl != "" {
            self.redirectVC(redirectLink: self.redirectUrl!, redirectLogoUrl: self.partnerlogoUrl)
        } else {
            self.redirectUrl = nil
            self.partnerlogoUrl = nil
        }
    }
    private func UIchangesforEarnViews(sender: UIButton) {
        
        sender.backgroudColorWithTitleColor(color: ColorConstant.shopNowButtonBGColor, titleColor: .white)
        
        switch sender {
        case wishButton:
            shopButton.backgroudColorWithTitleColor(color: .white, titleColor: ColorConstant.productDetailsbuttonTextColor)
            shareButton.backgroudColorWithTitleColor(color: .white, titleColor: ColorConstant.productDetailsbuttonTextColor)
        case shareButton:
            shopButton.backgroudColorWithTitleColor(color: .white, titleColor: ColorConstant.productDetailsbuttonTextColor)
            wishButton.backgroudColorWithTitleColor(color: .white, titleColor: ColorConstant.productDetailsbuttonTextColor)
        default:
            wishButton.backgroudColorWithTitleColor(color: .white, titleColor: ColorConstant.productDetailsbuttonTextColor)
            shareButton.backgroudColorWithTitleColor(color: .white, titleColor: ColorConstant.productDetailsbuttonTextColor)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("EarnProductDetailsVC deinit called")
    }
}
extension EarnProductDetailsVC {
    fileprivate func goToWishListScreen() {
        if let vc = MyWhishlistVC.storyboardInstance(storyBoardName: "Profile") as? MyWhishlistVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc fileprivate func resetWishLitButton(notification: Notification) {
        guard let model = notification.object as? WishListCellModel else {
            return
        }
        
        if productDetailsData?.metaInfo?.id == model.productId {
            self.wishButton.setTitle("WISHLIST", for: .normal)
        }
    }
    
    fileprivate func addToWishList(sender: UIButton) {
       // UIchangesforEarnViews(sender: sender)
        var productInfo = (id: "", name: "", url: "", userAction: "follow_product", inStock: "1" )
        if let metaInfo = productDetailsData?.metaInfo {
            productInfo = (id: metaInfo.id ?? "", name: metaInfo.title ?? "", url: metaInfo.appDeepLink ?? "", userAction: "follow_product", inStock: "1" )
        }
        let userEmail = UserProfileUtilities.getUserDetails()?.EmailAddress ?? ""
        self.startActivityIndicator()
        self.earnProductDetailNWController
            .onAddWishListSuccess { [weak self] successMsg in
                self?.stopActivityIndicator()
                self?.showErrorView(errorMsg: successMsg)
//                UIView.transition(with: sender, duration: 0.5, options: .transitionFlipFromTop, animations: {
//                    self?.wishButton.setTitle(NSLocalizedString("GO TO WishList", comment: "GO TO WishList"), for: .normal)
//                })
            }
            .onAddWishListError { [weak self] (error) in
                self?.stopActivityIndicator()
                self?.showErrorView(errorMsg: error)
            }
            .addWishLish(loginUserEmail: userEmail, productInfo: productInfo)
    }
}

extension EarnProductDetailsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            switch productType {
            case .compare:
                return compareViewDataSource.isEmpty ? No_Data_Found_CellDataSource_Count : self.disableViewAll ? compareViewDataSource.count : compareViewDataSource.count <= 3 ? compareViewDataSource.count : 4
            case .specify:
                return specifyViewDataSource.isEmpty ? No_Data_Found_CellDataSource_Count : specifyViewDataSource.count
            default:
                //return reviewViewDataSource.isEmpty ? No_Data_Found_CellDataSource_Count : reviewViewDataSource.count + 1
                return reviewViewDataSource.isEmpty ? No_Data_Found_CellDataSource_Count : reviewViewDataSource.count

            }
        }
    }
    //swiftlint:disable cyclomatic_complexity
    //swiftlint:disable function_body_length
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = productTableview.dequeueReusableCell(withIdentifier: Cells.earnProductDetailHeaderCell, for: indexPath) as? ProductDetailHeaderCell
            cell?.productDetailsData = self.productDetailsData
            cell?.shopNowActionHandler = { [weak self] (link, logo) in
                self?.redirectUrl = link
                self?.partnerlogoUrl = logo
            }
            cell?.shareActionHandler = { [weak self] (shareUrl) in
                self?.shareUrl = shareUrl
            }
            configureProductDetailHeaderCell(cell: cell!)
            return cell!
        } else {
            switch productType {
            case .compare:
                guard !compareViewDataSource.isEmpty else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Cells.noDataFoundTVCell, for: indexPath)
                    return cell
                }
                if compareViewDataSource.count < 3 {
                    return configureCompareCell(indexPath: indexPath)
                } else {
                    if indexPath.row <= 2 {
                        return configureCompareCell(indexPath: indexPath)
                    } else if indexPath.row == 3 {
                        if !self.disableViewAll {
                        return viewAllCompareData(indexPath: indexPath)
                        } else {
                            return configureCompareCell(indexPath: indexPath)
                        }
                    } else {
                        if !self.disableViewAll {
                            return UITableViewCell()
                        } else {
                            return configureCompareCell(indexPath: indexPath)
                        }
                    }
                }
            case .specify:
                guard !specifyViewDataSource.isEmpty else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Cells.noDataFoundTVCell, for: indexPath)
                    return cell
                }
                return configureSpecifyCell(indexPath: indexPath)
            default:
                guard !reviewViewDataSource.isEmpty else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Cells.noDataFoundTVCell, for: indexPath)
                    return cell
                }
                //return (indexPath.row == 0) ? configureAvgRatingCell(indexPath: indexPath) : configureReviewCell(indexPath: indexPath)
                return configureReviewCell(indexPath: indexPath)
            }
        }
    }
    //swiftlint:enable cyclomatic_complexity
    //swiftlint:enable function_body_length
}

extension EarnProductDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return getHeightForHeaderFooter(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else {
            return 70.0
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return getHeightForHeaderFooter(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
   
    fileprivate func getHeightForHeaderFooter(section: Int) -> CGFloat {
        if section == 1 && productType == .specify {
            return 10
        }
        return CGFloat.leastNormalMagnitude
    }
}

// MARK: Cell Configurations
extension EarnProductDetailsVC {
    
    fileprivate func configureCompareCell(indexPath: IndexPath) -> CompareCell {
        let cell = (productTableview.dequeueReusableCell(withIdentifier: Cells.compareCellNibID, for: indexPath) as? CompareCell)
        cell?.setTagforShopNowButton(tagIndex: indexPath.row)
        cell?.cellViewModel = compareViewDataSource[indexPath.row]
        cell?.updateShopNow(closure: { [weak self] (link, logo) in
                self?.openinBrowser(url: link, logo: logo)
        })
        return cell!
    }

    fileprivate func viewAllCompareData(indexPath: IndexPath) -> UITableViewCell {
        let cell = productTableview.dequeueReusableCell(withIdentifier: viewAllDataCellId, for: indexPath)
        let viewAllButton = UIButton()
        viewAllButton.setTitle("View all >", for: .normal)
        viewAllButton.setTitleColor(UIColor.blue, for: .normal)
        viewAllButton.translatesAutoresizingMaskIntoConstraints = false
        viewAllButton.addTarget(self, action: #selector(viewAllDataAction), for: .touchUpInside)
        cell.addSubview(viewAllButton)
        
        viewAllButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        viewAllButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        viewAllButton.topAnchor.constraint(equalTo: cell.topAnchor, constant: 15).isActive = true
        viewAllButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -15).isActive = true
        viewAllButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func viewAllDataAction() {
        print("view all clicked")
        self.disableViewAll = true
        self.productTableview.reloadData()
        
//        self.productTableview.deleteRows(at: [IndexPath(row: compareViewDataSource.count, section: 1)], with: .none)
    }
    
    func openinBrowser(url: String, logo: String) {
        let userLogedIn = UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged)
        if userLogedIn {
            if url != "" {
                self.redirectVC(redirectLink: url, redirectLogoUrl: logo)
            }
        } else {
            self.redirectVC(redirectLink: url, redirectLogoUrl: logo)
        }
    }
    
    fileprivate func configureSpecifyCell(indexPath: IndexPath) -> SpecifyCell {
        let cell = (productTableview.dequeueReusableCell(withIdentifier: Cells.specifyCellNibID, for: indexPath) as? SpecifyCell)
        cell?.cellViewModel = specifyViewDataSource[indexPath.row]
        return cell!
    }
    
    fileprivate func configureReviewCell(indexPath: IndexPath) -> ReviewCell {
        let cell = (productTableview.dequeueReusableCell(withIdentifier: Cells.reviewCellNibID, for: indexPath) as? ReviewCell)
        //cell?.cellViewModel = reviewViewDataSource[indexPath.row - 1]
        cell?.cellViewModel = reviewViewDataSource[indexPath.row]
        return cell!
    }
    
    fileprivate func configureAvgRatingCell(indexPath: IndexPath) -> AvgRatingCell {
        let cell = (productTableview.dequeueReusableCell(withIdentifier: Cells.avgRatingCellNibID, for: indexPath) as? AvgRatingCell)
        if !reviewViewDataSource.isEmpty {
            cell?.cellViewModel = reviewViewDataSource[indexPath.row]
            cell?.ratingActionHandler = { [weak self] in
                self?.rateNowAction()
            }
        } else {
            cell?.cellErrorMsg = self.reviewErrorMsg
        }
        return cell!
    }
    
    fileprivate func configureProductDetailHeaderCell(cell: ProductDetailHeaderCell) {
        cell.compareActionHandler = { [weak self] in
            self?.detailAction(type: .compare)
        }
        cell.specifyActionHandler = { [weak self] in
            self?.detailAction(type: .specify)
        }
        cell.reviewActionHandler = { [weak self] in
            self?.detailAction(type: .review)
        }
        cell.couponActionHandler = { [weak self] in
            self?.couponAction()
        }
        cell.carouselActionHandler = { [weak self] Data, Data1 in            
            let storyboardMain = UIStoryboard(name: "Earn", bundle: nil)
            
            let imageSlider = storyboardMain.instantiateViewController(withIdentifier: "SlideShowVC") as? SlideShowVC
            imageSlider?.startIndex = Data
            imageSlider?.images = Data1
            self?.present(imageSlider!, animated: true, completion: nil)
        }
    }
    private func detailAction(type: ProductCategoryType) {
        productType = type
        self.productTableview.reloadData()
    }
    
    private func rateNowAction() {
        print("rate now clicked")
    }
    private func couponAction() {
        print("coupon clicked")
    }
    
    fileprivate func addTempData() {
        
    }
}
