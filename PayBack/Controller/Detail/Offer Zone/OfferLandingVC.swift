//
//  OfferLandingVC.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/28/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class OfferLandingVC: BaseViewController {
    fileprivate var heightDictionary: [Int : CGFloat] = [:]
    
    @IBOutlet weak private var navigationView: UIView!
    @IBOutlet weak fileprivate var mTableView: UITableView!
    
    var selectedCategory: Int?
    
    let offerzoneNwController = OfferZoneNWController()
    fileprivate var offerLandingViewModel: OfferLandingViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCells()
        self.mTableView.dataSource = self
        self.mTableView.delegate = self
        self.mTableView.tableFooterView = setFooterView()
        
        if self.checkConnection() {
            self.offerLandingViewModel.fetchAll()
        }
    }
    
    override func connectionSuccess() {
        self.offerLandingViewModel.refreshData()
        self.offerLandingViewModel.fetchAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.offerLandingViewModel.refreshData()
    }
    
    override func userLogedIn(status: Bool) {
        guard status else {
            return
        }
        if status, let link = redirectUrl, link != "" {
                self.redirectVC(redirectLink: link, redirectLogoUrl: self.partnerlogoUrl)
                self.redirectUrl = nil
                self.partnerlogoUrl = nil
        } else {
            self.redirectUrl = nil
            self.partnerlogoUrl = nil
        }
    }
    
    deinit {
        if offerLandingViewModel != nil {
            self.offerLandingViewModel.invalidateObservers()
        }
        print(" OfferLandingVC deinit called")
    }
    
    override func willEnterForeground() {
        self.offerLandingViewModel.refreshData()
    }
}

extension OfferLandingVC {
    fileprivate func setupUI() {
        self.startActivityIndicator()
        self.offerLandingViewModel = OfferLandingViewModel(networkController: offerzoneNwController)
        
        self.offerLandingViewModel.bindToOfferViewModels = { [weak self] in
            DispatchQueue.main.async {
                self?.stopActivityIndicator()
                self?.mTableView.reloadData()
            }
        }
        self.offerLandingViewModel.bindToCarouselViewModels = { [weak self]  in
            DispatchQueue.main.async {
                self?.stopActivityIndicator()
                self?.mTableView.reloadData()
            }
        }
        self.offerLandingViewModel.bindToGrigViewModels = { [weak self] in
            DispatchQueue.main.async {
                self?.stopActivityIndicator()
                self?.mTableView.reloadData()
            }
        }
    }
    
    func registerCells() {
        mTableView.register(CarouselTVCell.self, forCellReuseIdentifier: Cells.carouselTVCell)
        mTableView.register(GridTVCell.self, forCellReuseIdentifier: Cells.categoryCellID)
        mTableView.register(UINib(nibName: Cells.offersCellID, bundle: nil), forCellReuseIdentifier: Cells.offersCellID)
    }
    
    fileprivate func setFooterView() -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 8)
        view.backgroundColor = ColorConstant.collectionViewBGColor
        return view
    }
}

// MARK: - Table view data source
extension OfferLandingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offerLandingViewModel.offerViewModels.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0, let cell = tableView.dequeueReusableCell(withIdentifier: Cells.carouselTVCell, for: indexPath) as? CarouselTVCell {
            cell.carouselSlides = self.offerLandingViewModel.carouselViewModel
            cell.backgroundColor = UIColor.clear
            cell.tapOnCarousel = { [weak self] (link, logoPath) in
                self?.redirectVC(redirectLink: link, redirectLogoUrl: logoPath)
            }
            return cell
        } else if indexPath.row == 1, let cell = tableView.dequeueReusableCell(withIdentifier: Cells.categoryCellID, for: indexPath) as? GridTVCell {
            configureCategoryCell(cell: cell)
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.offersCellID, for: indexPath) as? PBOfferTVCell {
            cell.offerCellModel = self.offerLandingViewModel.offerModel(at: indexPath.row - 2)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightDictionary[indexPath.row] = cell.frame.size.height
    }
}

extension OfferLandingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openBannerOffer(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if self.offerLandingViewModel.carouselViewModel == nil {
                return 0
            }
            return Carousel_Height
        } else if indexPath.row == 1 {
            guard let grids = self.offerLandingViewModel.gridModels(), !grids.isEmpty else {
                return 0
            }
            let width = tableView.frame.size.width / 2 - 4
            return (width / OfferTiles_HeightRatio) * 2 + 16
        } else {
            return UITableViewAutomaticDimension
        }
    }
}

extension OfferLandingVC {
    
    private func configureCategoryCell(cell: GridTVCell) {
        cell.backgroundColor = ColorConstant.collectionViewBGColor
        if let gridCellModel = self.offerLandingViewModel.gridModels() {
            cell.categoryDataArray = gridCellModel
        }
        cell.categoryTapClouser = { [weak self] (index) in
            if let strongSelf = self {
                strongSelf.navigateToCategory(index)
            }
        }
    }
    
    private func navigateToCategory(_ index: Int) {
        selectedCategory = index
//        if index == 0 {
//            performSegue(withIdentifier: "InstoreOffersVC", sender: nil)
//            return
//        }
        performSegue(withIdentifier: "zoneToOnlineOffers", sender: nil)
    }
    
    private func openBannerOffer(_ index: Int) {
        if index == 0, let cellModel = self.offerLandingViewModel.carouselModel(at: index), let urlString = cellModel.redirectionURL {
            self.redirectVC(redirectLink: urlString, redirectLogoUrl: cellModel.redirectionPartnerLogo)
            return
        }
        
        if index > 1, let landingModel = self.offerLandingViewModel.offerModel(at: index - 2), let urlString = landingModel.redirectionUrl {
            self.redirectVC(redirectLink: urlString, redirectLogoUrl: landingModel.redirectionLogoPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "zoneToOnlineOffers", let dc = segue.destination as? OnlineOffersVC {
            switch selectedCategory {
            case 0?:
                dc.categoryType = .inStoreOffer
            case 1?:
                dc.categoryType = .onlineOffer
            case 2?:
                dc.categoryType = .recharge
            case 3?:
                dc.categoryType = .coupans
            default:
                break
            }
        }
    }
}
