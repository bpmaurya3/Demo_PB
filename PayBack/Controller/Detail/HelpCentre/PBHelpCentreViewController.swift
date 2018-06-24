//
//  PBHelpCentreViewController.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 15/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBHelpCentreViewController: BaseViewController {
    
    @IBOutlet weak private var navigationView: DesignableNav!
    @IBOutlet weak private var mTableView: UITableView!
    
    fileprivate lazy var helpCenterFetcher: HelpCenterFetcher = {
        return HelpCenterFetcher()
    }()
    fileprivate lazy var carouselFetcher: CarouselFetcher = {
        return CarouselFetcher()
    }()
    fileprivate var helpCenter: HelpCenter?
    
    var optionDataArray = [PBHelpCentreTVCellModel]() {
        didSet {
            self.reloadData {
                self.mTableView.reloadData()
            }
        }
    }
    
    var carouselSlides: [HeroBannerCellModel]? {
        didSet {
            self.reloadData {
                self.mTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        if self.checkConnection() {
            fetchHelpCenterData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isNetworkAvailable() {
            self.refreshableAPI()
        }
    }
    override func willEnterForeground() {
        if isNetworkAvailable() {
            self.refreshableAPI()
        }
    }
    override func connectionSuccess() {
        self.refreshableAPI()
        fetchHelpCenterData()
    }
    override func userLogedIn(status: Bool) {
        guard status else {
            return
        }
        if status, let url = self.redirectUrl, url != "" {
            self.redirectVC(redirectLink: url, redirectLogoUrl: self.partnerlogoUrl)
        } else {
            self.redirectUrl = ""
            self.partnerlogoUrl = ""
        }
    }
    
    deinit {
        print(" PBHelpCentreViewController deinit called")
    }
}
extension PBHelpCentreViewController {
    fileprivate func reloadData(block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }
    private func registerCells() {
        mTableView.register(CarouselTVCell.self, forCellReuseIdentifier: Cells.carouselTVCell)
        mTableView.register(UINib(nibName: Cells.helpCentreLabelCellID, bundle: nil), forCellReuseIdentifier: Cells.helpCentreLabelCellID)
        mTableView.register(PBHelpCentreTVCell.self, forCellReuseIdentifier: Cells.helpCentreCellID)
        mTableView.backgroundColor = ColorConstant.collectionViewBGColor
    }
    fileprivate func refreshableAPI() {
        let when = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.fetchCarousel()
        }
    }
    fileprivate func fetchHelpCenterData() {
        let whenDetails = DispatchTime.now() + 0.20
        DispatchQueue.main.asyncAfter(deadline: whenDetails) {
            self.fetchAccordianDetails()
        }
        
    }
}
extension PBHelpCentreViewController {
    fileprivate func fetchCarousel() {
        self.startActivityIndicator()
        carouselFetcher
            .onSuccess { [weak self] (carousel, expired) in
                self?.carouselSlides = expired ? [] : carousel
                self?.stopActivityIndicator()
            }
            .onError { [weak self] (error) in
                print("\(error)")
                self?.stopActivityIndicator()
            }
            .fetchHelpCenterCarousel()
    }
    
    fileprivate func fetchAccordianDetails() {
        self.startActivityIndicator()
        
        helpCenterFetcher
            .onSuccess(success: { [weak self] (helpCenter) in
                var cellModelArray = [PBHelpCentreTVCellModel]()
                self?.helpCenter = helpCenter
                guard let userRelatedData = helpCenter.accordionDetails else {
                    return
                }
                for helpCenterData in userRelatedData {
                    cellModelArray.append(PBHelpCentreTVCellModel(withHelpCenterData: helpCenterData))
                }
                self?.optionDataArray = cellModelArray
                self?.stopActivityIndicator()
            })
            .onError { [weak self] (error) in
                print("\(error)")
                self?.stopActivityIndicator()
            }
            .fetchHelpCenter()
    }
}

extension PBHelpCentreViewController: UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.carouselTVCell, for: indexPath) as? CarouselTVCell {
                cell.backgroundColor = UIColor.clear
                cell.carouselSlides = carouselSlides
                cell.tapOnCarousel = { [weak self] (link, logoPath) in
                    self?.redirectVC(redirectLink: link, redirectLogoUrl: logoPath)
                }
                return cell
            }
        } else if indexPath.row == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.helpCentreLabelCellID, for: indexPath) as? PBHelpCentreLabelTVCell {
                cell.backgroundColor = ColorConstant.collectionViewBGColor
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.helpCentreCellID, for: indexPath) as? PBHelpCentreTVCell {
                configureCell(cell: cell)
                return cell
            }
        }
        return UITableViewCell()
    }
    private func configureCell(cell: PBHelpCentreTVCell) {
        cell.backgroundColor = ColorConstant.collectionViewBGColor
        cell.optionDataArray = optionDataArray
        cell.tapClouser = { [weak self] (index) in
            print("\(index)")
            if let strongSelf = self {
                strongSelf.performSegue(withIdentifier: "PBHelpCentreDetailViewController", sender: index)
            }
        }
    }
}
extension PBHelpCentreViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return (carouselSlides == nil || !(carouselSlides?.isEmpty)!) ? Carousel_Height : 0
        } else if indexPath.row == 1 {
            return mTableView.frame.height / 7
        } else {
            let rowCount = optionDataArray.count / 3 + optionDataArray.count % 3
            return ((mTableView.frame.width - 22) / 3) * CGFloat(rowCount)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PBHelpCentreDetailViewController" {
            guard let selectedIndex = sender as? Int else {
                return
            }
            let spaceDetail = segue.destination as? PBHelpCentreDetailViewController
            spaceDetail?.defaultSelectedIndex = selectedIndex
            spaceDetail?.helpCenterData = helpCenter
            spaceDetail?.cameFirstTime = true
        }
    }
}
