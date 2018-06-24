//
//  BurnProductDetailVC.swift
//  PayBack
//
//  Created by Valtech Macmini on 13/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class BurnProductDetailVC: BaseViewController {
    // check delivery flow not clear
    // Quantity dropdown UI not yet confirmed
    
    let burnProductDetailNWController = BurnProductDetailsNWController()
    @IBOutlet weak fileprivate var productTableview: UITableView!
    @IBOutlet weak private var cartButton: UIButton!
    @IBOutlet weak fileprivate var redeemButton: UIButton!
    @IBOutlet weak private var viewShadow: UIView!
    @IBOutlet weak private var emptyView: UIView!
    @IBOutlet weak private var emptyLabel: UILabel!
    
    fileprivate var productType: BurnProductCategoryType = .specify
    fileprivate var cellHeights = [IndexPath: CGFloat]()
    
    let addTocartFetcher = AddToCartFetcher()
    var deleteWishListFetcher: DeleteWishListFetcher!
    
    fileprivate var refundPolicy: String?
    fileprivate var reviewViewDataSource = [ReviewCellModel]()
    fileprivate var specifyViewDataSource = [SpecificationCellModel]()
    fileprivate var productDetailsData: BurnProductDetails.Result? {
        didSet {
            guard let productDetailsData = productDetailsData else {
                return
            }
            if self.specifyViewDataSource.isEmpty, let specifications = productDetailsData.specifications {
                for spec in specifications {
                    self.specifyViewDataSource.append(SpecificationCellModel(withRedeemSpecification: spec))
                }
            }
            if self.reviewViewDataSource.isEmpty, let reviews = productDetailsData.review {
                for review in reviews {
                    self.reviewViewDataSource.append(ReviewCellModel(withRedeemReview: review))
                }
            }
            
            self.refundPolicy = productDetailsData.refundPolicy

            self.productTableview.reloadData()
        }
    }
    var productID: String? = ""
    var requiredQuantity: Int = 1
    var redeemActionStatus: Bool = false
    var addToWishListStatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cartButton.isHidden = true
        cartButton.titleLabel?.font = FontBook.Regular.of(size: 15.0)
        redeemButton.titleLabel?.font = FontBook.Regular.of(size: 15.0)
        
        loadCellNibs()
        productTableview.rowHeight = UITableViewAutomaticDimension
        productTableview.tableFooterView = UIView()
        addTempData()
        addShadowBorder()
        UIchangesforBurnViews(sender: redeemButton)
        self.emptyView.isHidden = false
        self.emptyView.backgroundColor = ColorConstant.leftRightMenuBgColor
        self.emptyLabel.text = ""
        self.emptyLabel.font = FontBook.Regular.of(size: 17.0)
        
        self.deleteWishListFetcher = DeleteWishListFetcher()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.checkConnection() {
            fetchProductDetails()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        print(" BurnProductDetailVC deinit called")
    }
    override func connectionSuccess() {
        fetchProductDetails()
    }
    override func userLogedIn(status: Bool) {
        if !status {
            self.parent?.stopActivityIndicator()
        }
    }
}

extension BurnProductDetailVC {
    
    fileprivate func openSignIn() {
        self.onLoginSuccess { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.parent?.stopActivityIndicator()
            if strongSelf.redeemActionStatus {
                strongSelf.toCheckSufficientPoitsToBuy()
                strongSelf.redeemActionStatus = false
            } else if strongSelf.addToWishListStatus {
                strongSelf.addToWishListStatus = false
                strongSelf.addToWishlist()
            }
            }
            .onLoginError(error: { [weak self] (error) in
                self?.parent?.stopActivityIndicator()
                self?.showErrorView(errorMsg: error)
            })
            .signInPopUp()
    }
    
    fileprivate func addShadowBorder() {
        viewShadow.layer.masksToBounds = false
        viewShadow.layer.shadowColor = UIColor.lightGray.cgColor
        viewShadow.layer.shadowOpacity = 2
        viewShadow.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewShadow.layer.shadowRadius = 2
        DispatchQueue.main.async { [weak self] in
            self?.cartButton.layer.addBorder(edge: .right, color: .gray, thickness: 0.5)
        }
    }
    
    fileprivate func updateProductDetails(productDetails: BurnProductDetails) {
        if let result = productDetails.result {
            self.productDetailsData = result[0]
            self.emptyView.isHidden = true
        } else {
            self.emptyView.isHidden = false
            self.emptyLabel.text = "Details not found"
        }
    }
    
    fileprivate func loadCellNibs() {
        
        productTableview.register(UINib(nibName: Cells.burnDetailHeaderCellNibID, bundle: nil), forCellReuseIdentifier: Cells.burnDetailHeaderCellNibID)
        productTableview.register(UINib(nibName: Cells.specifyCellNibID, bundle: nil), forCellReuseIdentifier: Cells.specifyCellNibID)
        productTableview.register(UINib(nibName: Cells.reviewCellNibID, bundle: nil), forCellReuseIdentifier: Cells.reviewCellNibID)
        productTableview.register(UINib(nibName: Cells.avgRatingCellNibID, bundle: nil), forCellReuseIdentifier: Cells.avgRatingCellNibID)
        productTableview.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        productTableview.register(NoDataFoundTVCell.self, forCellReuseIdentifier: Cells.noDataFoundTVCell)
    }
    
    fileprivate func addTempData() {
//        let data4 = SpecificationCellModel(featureType: "Sales category", featureDetail: "Hello world, I ruile alll thje eworjojsfgrjns nswer glsg lsg ")
//        specifyViewDataSource.append(data4!)
//        
//        let data5 = SpecificationCellModel(featureType: "Sales details", featureDetail: "Hello world, I ruile alll thje eworjojsfgrjns nswer glsg lsg ")
//        specifyViewDataSource.append(data5!)
//        
//        let data6 = SpecificationCellModel(featureType: "Sales Deatures", featureDetail: "200DP")
//        specifyViewDataSource.append(data6!)
//        
//        let data7 = ReviewCellModel(avgReviewCount: 4, avgRatingCount: 4, avgRating: 4, rating: 4, reviewTitle: "hello", reviewDate: "1997", reviewDetail: "It was perfect", reviewCustName: "James")
//        reviewViewDataSource.append(data7!)
//        
//        let data8 = ReviewCellModel(avgReviewCount: 4, avgRatingCount: 4, avgRating: 4, rating: 4, reviewTitle: "hello", reviewDate: "1997", reviewDetail: "It was perfect", reviewCustName: "James")
//        reviewViewDataSource.append(data8!)
//        
//        let data9 = ReviewCellModel(avgReviewCount: 4, avgRatingCount: 4, avgRating: 4, rating: 4, reviewTitle: "hello", reviewDate: "1997", reviewDetail: "It was perfect", reviewCustName: "James")
//        reviewViewDataSource.append(data9!)
    }
    fileprivate func UIchangesforBurnViews(sender: UIButton) {
        
        sender.backgroudColorWithTitleColor(color: ColorConstant.buttonBackgroundColorPink, titleColor: .white)
        
        switch sender {
        case cartButton:
            redeemButton.backgroudColorWithTitleColor(color: .white, titleColor: ColorConstant.productDetailsbuttonTextColor)
        default:
            cartButton.backgroudColorWithTitleColor(color: .white, titleColor: ColorConstant.productDetailsbuttonTextColor)
        }
    }
    fileprivate func goToCartScreen() {
        if let vc = MyCartVC.storyboardInstance(storyBoardName: "Main") as? MyCartVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    fileprivate func toCheckSufficientPoitsToBuy() {
        var totalPoints = 0
        if let totalPoint = UserProfileUtilities.getUserDetails()?.TotalPoints, let totalPointInInt = Int(totalPoint) {
            totalPoints = totalPointInInt
        }
        var redeemablePoints = 0
        if let actualPoints = productDetailsData?.price?.actualPoints {
            redeemablePoints = Int(actualPoints) * requiredQuantity
        }
        guard totalPoints >= redeemablePoints else {
            self.showErrorView(errorMsg: "Your points are not sufficient to buy")
            return
        }
        self.navigateToCartReviewController()
    }
    
    fileprivate func navigateToCartReviewController() {
        guard let productDetails = productDetailsData, let productId = productDetails.productId else {
            return
        }
        var skuCode = ""
        if let skus = productDetails.skus, !skus.isEmpty {
            skuCode = skus[0]
        }
        var imagePath = ""
        if let images = productDetails.images?.small, !images.isEmpty {
            imagePath = images[0]
        }
        
        let productInfo = CreateOrderProductInfoModel(ItemId: productId, SkuCode: skuCode, ItemName: productDetails.name ?? "", Quantity: self.requiredQuantity, points: Int(productDetails.price?.actualPoints ?? 0), UnitPrice: nil, imagePath: imagePath)
        
        if let deliveryDetailPageVC = CartReviewVC.storyboardInstance(storyBoardName: "Burn") as? CartReviewVC {
            deliveryDetailPageVC.productInfo = productInfo
            self.navigationController?.pushViewController(deliveryDetailPageVC, animated: true)
        }
    }
    
    fileprivate func shareAction(shareLink: String) {
        if shareLink != "" {
            // set up activity view controller
            let activityViewController = UIActivityViewController(activityItems: [shareLink as Any], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop]
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    fileprivate func addToWishlist() {
        if UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged) {
            guard let productId = self.productDetailsData?.productId else {
                return
            }
            let userId = UserProfileUtilities.getUserID()
            var skuCode = ""
            if let skus = self.productDetailsData?.skus, !skus.isEmpty {
                skuCode = skus[0]
            }
            let requestModel = RewardsAddWishListRequestModel(data: RewardsAddWishListRequestModel.WishListData(productId: productId, skuCode: skuCode, qty: "\(self.requiredQuantity)", totalPoint: "\(Int(productDetailsData?.price?.actualPoints ?? 0))", userId: userId))
            
            self.deleteWishListFetcher
                .onSuccess {[weak self] (success) in
                    if let message = success.message {
                        self?.showErrorView(errorMsg: message)
                    }
                }
                .onError {[weak self] (error) in
                    self?.showErrorView(errorMsg: error)
                }
                .addWishListForRewards(requestModel: requestModel)
        } else {
            self.addToWishListStatus = true
            self.openSignIn()
        }
    }
}

extension BurnProductDetailVC {
    @IBAction func redeemAction(_ sender: UIButton) {
        UIchangesforBurnViews(sender: sender)
        
        if UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged) {
            self.toCheckSufficientPoitsToBuy()
        } else {
            self.redeemActionStatus = true
            openSignIn()
        }
    }
    @IBAction func addToCartAction(_ sender: UIButton) {
        guard sender.titleLabel?.text == "ADD TO CART" else {
            self.goToCartScreen()
            return
        }
        guard let productId = self.productDetailsData?.productId else {
            return
        }
        let quantity = self.requiredQuantity
        addTocartFetcher
            .onSuccess { [weak self] (message) in
                self?.showErrorView(errorMsg: message)
//                self?.UIchangesforBurnViews(sender: sender)
//                UIView.transition(with: sender, duration: 0.5, options: .transitionFlipFromTop, animations: {
//                    sender.setTitle(NSLocalizedString("GO TO CART", comment: "GO TO CART"), for: .normal)
//                })
            }
            .onError { (error) in
                print("\(error)")
                self.showErrorView(errorMsg: error)
            }
            .addToCart(withQuantity: String(quantity), productId: productId)
    }
}

extension BurnProductDetailVC {
    
    fileprivate func fetchProductDetails() {
        self.startActivityIndicator()
        
        burnProductDetailNWController
            .onError { [weak self] (error) in
                self?.stopActivityIndicator()
                self?.emptyLabel.text = "Details not found"
                self?.showErrorView(errorMsg: error)
            }
            .onSuccess { [weak self] (ProductDetailModel) in
                self?.stopActivityIndicator()
                self?.updateProductDetails(productDetails: ProductDetailModel)
            }
            .getBurnProductDetails(productID: productID ?? "")
    }
}

extension BurnProductDetailVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            switch productType {
            case .specify:
                return specifyViewDataSource.isEmpty ? No_Data_Found_CellDataSource_Count : specifyViewDataSource.count
            case .refund:
                return 1
            default:
               // return reviewViewDataSource.isEmpty ? No_Data_Found_CellDataSource_Count : reviewViewDataSource.count + 1
                return reviewViewDataSource.isEmpty ? No_Data_Found_CellDataSource_Count : reviewViewDataSource.count

            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = productTableview.dequeueReusableCell(withIdentifier: Cells.burnDetailHeaderCellNibID, for: indexPath) as? BurnProductDetailHeaderCell
            cell?.getOrderQuantity(closure: { [weak self] (quantity) in
                self?.requiredQuantity = quantity
            })
            cell?.shareActionHandler = { [weak self] (shareURL) in
                self?.shareAction(shareLink: shareURL)
            }
            cell?.wishActionHandler = { [weak self] in
                self?.addToWishlist()
            }
            cell?.productDetailsData = self.productDetailsData
            configureBurnProductDetailHeaderCell(cell: cell!)
            return cell!
        } else {
            switch productType {
            case .specify:
                guard !specifyViewDataSource.isEmpty else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Cells.noDataFoundTVCell, for: indexPath)
                    return cell
                }
                return configureSpecifyCell(indexPath: indexPath)
            case .refund:
                guard refundPolicy != nil, refundPolicy != "" else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Cells.noDataFoundTVCell, for: indexPath)
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.font = FontBook.Regular.of(size: 11.5)
                cell.textLabel?.textColor = ColorConstant.textColorPointTitle
                cell.textLabel?.text = refundPolicy ?? StringConstant.No_Data_Found
                return cell
            default:
                guard !reviewViewDataSource.isEmpty else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Cells.noDataFoundTVCell, for: indexPath)
                    return cell
                }
               // return (indexPath.row == 0) ? configureAvgRatingCell(indexPath: indexPath) : configureReviewCell(indexPath: indexPath)
                return configureReviewCell(indexPath: indexPath)
            }
        }
    }
}

extension BurnProductDetailVC: UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return getHeightForHeaderFooter(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
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
extension BurnProductDetailVC {
    fileprivate func configureSpecifyCell(indexPath: IndexPath) -> SpecifyCell {
        let cell = (productTableview.dequeueReusableCell(withIdentifier: Cells.specifyCellNibID, for: indexPath) as? SpecifyCell)
        cell?.cellViewModel = specifyViewDataSource[indexPath.row]
        return cell!
    }
    
    fileprivate func configureReviewCell(indexPath: IndexPath) -> ReviewCell {
        let cell = (productTableview.dequeueReusableCell(withIdentifier: Cells.reviewCellNibID, for: indexPath) as? ReviewCell)
       // cell?.cellViewModel = reviewViewDataSource[indexPath.row - 1]
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
            cell?.cellErrorMsg = "No reviews available for this productid."
        }
        return cell!
    }
    fileprivate func configureBurnProductDetailHeaderCell(cell: BurnProductDetailHeaderCell) {
        
        cell.refundActionHandler = { [weak self] in
            self?.detailAction(type: .refund)
        }
        cell.specifyActionHandler = { [weak self] in
            self?.detailAction(type: .specify)
        }
        cell.reviewActionHandler = { [weak self] in
            self?.detailAction(type: .review)
        }
        cell.standardActionHandler = { [weak self] in
            self?.productTableview.updateTableView(animation: false)
        }
        cell.expressActionHandler = { [weak self] in
            self?.productTableview.reloadSections([1], with: .none)
        }
        
        cell.carouselActionHandler = { [weak self] Data, Data1 in
            if let imageSlider = SlideShowVC.storyboardInstance(storyBoardName: "Earn") as? SlideShowVC {
                imageSlider.startIndex = Data
                imageSlider.images = Data1
                self?.present(imageSlider, animated: true, completion: nil)
            }
        }
        
        cell.editingActionHandler = { [weak self] keyboardHeight, isSatisfied in
            let offset: CGFloat = (keyboardHeight == 0) ? 0 : keyboardHeight + 150
            self?.productTableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: offset, right: 0)
        }
    }
    
    fileprivate func detailAction(type: BurnProductCategoryType) {
        productType = type
        self.productTableview.reloadData()
    }
    
    fileprivate func rateNowAction() {
        print("rate now clicked")
    }
    
    fileprivate func couponAction() {
        print("coupon clicked")
    }
}
