//
//  HomeShowCaseTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 5/14/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

//
//  HotDealsTVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/14/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

final internal class HomeShowCaseTVCell: UITableViewCell {
    var cellTapClosure: (Int) -> Void = { _ in }
    var tapOnCarousel: (_ link: String, _ logoPath: String) -> Void = { _, _ in }

    fileprivate var dataSource: CollectionViewDataSource<HomeShowCaseCVCell, HomeShowCaseCVCellModel>!
    
    var showCaseData: ShowCaseTuple = ([], [], "", "") {
        didSet {
            self.cellModel = showCaseData.items
            self.carouselSlides = showCaseData.carousels
            self.title = showCaseData.title
        }
    }
    
    fileprivate var cellModel: [HomeShowCaseCVCellModel] = [] {
        didSet {
           
//            collectionView.heightAnchor.constraint(equalToConstant: cellModel.isEmpty ? 0 : 200).isActive = true
//            self.titleLabel.isHidden = cellModel.isEmpty ? true : false
//            self.underLineView.isHidden = cellModel.isEmpty ? true : false
//            self.viewAllButton.isHidden = cellModel.isEmpty ? true : false
            
            self.dataSource = CollectionViewDataSource(cellIdentifier: Cells.homeShowCaseCVCell, items: cellModel) { [unowned self] cell, vm in
                self.addColectionViewCellLayer(cell: cell)
                self.configureCell(cell: cell)
                cell.cellModel = vm
            }
            self.collectionView.dataSource = self.dataSource
            self.collectionView.reloadData()
        }
    }
    
    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    fileprivate lazy var rewardsNWController: RewardCatalogueNetworkController = {
        return RewardCatalogueNetworkController()
    }()
    
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = FontBook.Bold.of(size: 18)
        label.textColor = ColorConstant.rewardScreenTitleColor
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var underLineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = ColorConstant.bottomLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate var viewAllButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.backgroundColor = ColorConstant.shopNowButtonBGColor
        button.setTitle("VIEW ALL", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.register(UINib(nibName: Cells.homeShowCaseCVCell, bundle: nil), forCellWithReuseIdentifier: Cells.homeShowCaseCVCell)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    fileprivate var carousel: PBCarousel = {
        let carousel = PBCarousel(frame: .zero)
        carousel.backgroundColor = .clear
        carousel.translatesAutoresizingMaskIntoConstraints = false
        return carousel
    }()
    
    fileprivate var carouselSlides: [HeroBannerCellModel]? {
        didSet {
            guard let slides = carouselSlides else {
                carousel.heightAnchor.constraint(equalToConstant: 0).isActive = true
                self.carousel.slides = []
                return
            }
            self.carousel.slides = slides
            self.carousel.cellActionHandler = { [weak self] index in
                let data = slides[index]
                if let strongSelf = self, let redirectUrl = data.redirectionURL, redirectUrl != "" {
                    strongSelf.redirectVC(redirectLink: redirectUrl, redirectLogoUrl: data.redirectionPartnerLogo)
                }
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("HomeShowCaseTVCell: deinit called")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.carouselSlides = []
    }
    private func setupViews() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        
        addSubview(underLineView)
        underLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        underLineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13).isActive = true
        underLineView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        underLineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        addSubview(viewAllButton)
        viewAllButton.addTarget(self, action: .viewAllForHomeShowCaseTVCell, for: .touchUpInside)
        viewAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        viewAllButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        viewAllButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: viewAllButton.leadingAnchor, constant: -5).isActive = true
        
        addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: underLineView.bottomAnchor, constant: 26).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: Carousel_Height + 50).isActive = true

        addSubview(self.carousel)
        carousel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        carousel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        carousel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10).isActive = true
        carousel.heightAnchor.constraint(equalToConstant: Carousel_Height).isActive = true
        carousel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        let configuration = PBCarouselConfiguration()
            .set(collectionViewBounce: true)
            .set(collectionViewCellName: .partnerDetailCarousel)
            .set(isHeroCarousel: true)
        
        carousel.confugure(withConfiguration: configuration)
        carousel.cellActionHandler = { [weak self] Data in
            guard let slideImageData = self?.carouselSlides?[Data] else {
                return
            }
            if let redirectUrl = slideImageData.redirectionURL {
                self?.redirectVC(redirectLink: redirectUrl, redirectLogoUrl: slideImageData.redirectionPartnerLogo)
            }
        }
    }
}
extension HomeShowCaseTVCell {
    @objc func viewAllClicked() {
        print("View all clicked")
        let parentController = self.parentViewController as? ExtendedHomeVC
        switch showCaseData.type {
        case "earn-deal", "earn-cagtegory":
            if let strongSelf = parentController, let vc = OnlinePartnersVC.storyboardInstance(storyBoardName: "Burn") as? OnlinePartnersVC {
                vc.landingType = .earnProduct
                vc.navigationTitle = showCaseData.title
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        case "redeem-deal", "redeem-cagtegory":
            let productListRequestParams = ("", "recommended-deals", ProductCategory.none, ProductType.burnProduct, showCaseData.title)
            
            if let strongSelf = parentController, let vc = ProductListVC.storyboardInstance(storyBoardName: "Burn") as? ProductListVC {
                vc.productListRequestParams = productListRequestParams
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        case "promotion":
            if let strongSelf = parentController, let vc = InstantVoucherVC.storyboardInstance(storyBoardName: "Main") as? InstantVoucherVC {
                vc.showCaseTuple = showCaseData
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
    
    fileprivate func addColectionViewCellLayer(cell: UICollectionViewCell) {
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1.0
    }
    fileprivate func configureCell(cell: UICollectionViewCell) {
        guard let cell = cell as? HomeShowCaseCVCell  else {
            return
        }
        cell.buyNowClosure = {[weak self] (model) in
            if let url = model.redirectionURL {
                self?.redirectVC(redirectLink: url, redirectLogoUrl: model.itemImagePath ?? "")
            }
        }
    }
}

extension HomeShowCaseTVCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height - 25, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let modelData = cellModel[indexPath.item]
        switch showCaseData.type {
        case "earn-deal", "earn-cagtegory":
            cellTapClosure(indexPath.item)

//            guard modelData.itemType == "product" else {
//                if let urlString = modelData.appDeepLink {
//                    tapOnCarousel(urlString, modelData.partnerImagePath ?? "")
//                }
//                return
//            }
//            let parentController = self.parentViewController as? ExtendedHomeVC
//            if let strongSelf = parentController, let vc = EarnProductDetailsVC.storyboardInstance(storyBoardName: "Earn") as? EarnProductDetailsVC {
//                guard let PID = modelData.itemId, PID != "" else {
//                    strongSelf.showErrorView(errorMsg: StringConstant.productDetailsMissing)
//                    return
//                }
//                vc.productID = PID
//                strongSelf.navigationController?.pushViewController(vc, animated: true)
//            }
        case "redeem-deal", "redeem-cagtegory":
            let parentController = self.parentViewController as? ExtendedHomeVC
            if let strongSelf = parentController, let vc = BurnProductDetailVC.storyboardInstance(storyBoardName: "Burn") as? BurnProductDetailVC {
                guard let PID = modelData.itemId, PID != "" else {
                    strongSelf.showErrorView(errorMsg: StringConstant.productDetailsMissing)
                    return
                }
                vc.productID = PID
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
}

extension HomeShowCaseTVCell {
    func redirectVC(redirectLink: String, redirectLogoUrl: String? = "") {
        tapOnCarousel(redirectLink, redirectLogoUrl ?? "")
    }
}
