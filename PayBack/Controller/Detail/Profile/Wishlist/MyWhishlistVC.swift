//
//  MyWhishlistVC.swift
//  PayBack
//
//  Created by Dinakaran M on 18/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class MyWhishlistVC: BaseViewController {
    
    @IBOutlet weak private var navigationView: DesignableNav!
    @IBOutlet weak private var mTableView: UITableView!
    
    fileprivate var wishListLandingType: ProductType = .earnProduct
    fileprivate var wishListModel: PBWishListVM!
    private var isRedirected = false
    private var contentOffset: CGPoint = .zero
    
    internal lazy var emptyView: EmptyOrderView = {
        let tv = EmptyOrderView(frame: .zero, style: .plain)
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorConstant.vcBGColor
        
        self.wishListModel = PBWishListVM(withNetworkController: self)
        self.wishListModel.bindToWishListViewModels = {[weak self] in
            if let strongSelf = self {
                strongSelf.stopActivityIndicator()
                strongSelf.mTableView.isHidden = strongSelf.wishListModel.dataSource.isEmpty ? true : false
                guard !strongSelf.wishListModel.dataSource.isEmpty else {
                    strongSelf.openEmptyWishListView()
                    return
                }
                strongSelf.mTableView.reloadData()
                strongSelf.mTableView.layoutIfNeeded()
                strongSelf.mTableView.contentOffset = strongSelf.contentOffset
            }
        }
        
        mTableView.register(UINib(nibName: Cells.wishListCellID, bundle: nil), forCellReuseIdentifier: Cells.wishListCellID)
        mTableView.estimatedRowHeight = 50.0
        mTableView.rowHeight = UITableViewAutomaticDimension
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isRedirected {
            isRedirected = false
            return
        }
        self.contentOffset = self.mTableView.contentOffset
        let when = DispatchTime.now() + 0.15
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.startActivityIndicator()
            self.wishListModel.fetchWishList()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeEmptyWishListView()
    }
    deinit {
        if self.wishListModel != nil {
            self.wishListModel.invalidateObservers()
        }
        print("Deinit called - MyWhishlistVC")
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
    fileprivate func removeEmptyWishListView() {
        self.emptyView.removeFromSuperview()
    }
    fileprivate func openEmptyWishListView() {
        DispatchQueue.main.async {
            self.emptyView.tabSelectionType = .whishListCell
            self.view.addSubview(self.emptyView)
            self.emptyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            self.emptyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.emptyView.topAnchor.constraint(equalTo: self.navigationView.bottomAnchor, constant: 0).isActive = true
            self.emptyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        }
    }
}
extension MyWhishlistVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishListModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.wishListCellID, for: indexPath) as? PBWishListTVCell {
            cell.wishListLandingType = wishListLandingType
            cell.wishListCellModel = wishListModel.dataSource[indexPath.item]
            configureCellHandler(cell: cell)
            return cell
        }
        return UITableViewCell()
    }
}
extension MyWhishlistVC {
    fileprivate func navigateToCartReviewController(model: WishListCellModel) {
        guard let productId = model.productId else {
            return
        }
        var skuCode = ""
        if let sku = model.skuCode {
            skuCode = sku
        }
        var imagePath = ""
        if let path = model.imagePath {
            imagePath = path
        }
        
        let productInfo = CreateOrderProductInfoModel(ItemId: productId, SkuCode: skuCode, ItemName: model.mProductName ?? "", Quantity: 1, points: Int(model.mProductPrice ?? "") ?? 0, UnitPrice: nil, imagePath: imagePath)
        
        if let deliveryDetailPageVC = CartReviewVC.storyboardInstance(storyBoardName: "Burn") as? CartReviewVC {
            deliveryDetailPageVC.productInfo = productInfo
            self.navigationController?.pushViewController(deliveryDetailPageVC, animated: true)
        }
    }
}
extension MyWhishlistVC {
    fileprivate func configureCellHandler(cell: PBWishListTVCell) {
        cell.deleteCellHandler = { [weak self] model in
            self?.startActivityIndicator()
            self?.wishListModel
                .onDeleteSuccess(success: { [weak self] _, deletedModel in
                    self?.stopActivityIndicator()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WishListButtonTitleChanged"), object: deletedModel)
                })
                .onDeleteError(error: { [weak self] (error) in
                    self?.stopActivityIndicator()
                    self?.showErrorView(errorMsg: error)
                })
                .deleteCellModel(model: model)
        }
        cell.shareHandler = { [weak self] (model, sender) in
            let activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = sender
            
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop]
            self?.present(activityViewController, animated: true, completion: nil)
        }
        cell.cartOrBuyHandler = { [weak self] (model, moduleType) in
            switch model.prodyctType {
            case "Rewards"?:
                self?.navigateToCartReviewController(model: model)
                break
            default:
                guard let url = model.storeLink else {
                    return
                }
                self?.isRedirected = true
                self?.redirectVC(redirectLink: url, redirectLogoUrl: model.storeLogo)
            }
        }
    }
}
