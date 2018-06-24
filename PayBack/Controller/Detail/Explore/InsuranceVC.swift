//
//  InsuranceVC.swift
//  PayBack
//
//  Created by Valtech Macmini on 13/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class InsuranceVC: BaseViewController {

    @IBOutlet weak fileprivate var insuranceTableView: UITableView!
    fileprivate let categoriesCellId = "categoriesCellId"
    
    typealias TypesTuples = (item: ShopClickCellViewModel, index: Int)

    fileprivate let insuranceNwController = ExploreNWController()
    fileprivate var carouselSlides: [HeroBannerCellModel]? {
        didSet {
            let indexPath = IndexPath(row: 0, section: 0)
            insuranceTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    fileprivate var insuranceTypesModel: [ShopClickCellViewModel] = [] {
        didSet {
            insuranceTableView.reloadSections([1], with: .none)
        }
    }
    fileprivate var insurancePartnerModel: [ShopClickCellViewModel] = [] {
        didSet {
            insuranceTableView.reloadSections([2], with: .none)
        }
    }
    fileprivate var insuranceProtectDataSource = [InsuranceProtectCellModel]() {
        didSet {
            insuranceTableView.reloadSections([3], with: .none)
        }
    }
    fileprivate var insurancePartners: OtherPartner?

    override func viewDidLoad() {
        super.viewDidLoad()
        insuranceTableView.bounces = false
        insuranceTableView.estimatedRowHeight = 100
        insuranceTableView.register(CarouselTVCell.self, forCellReuseIdentifier: Cells.carouselTVCell)
        insuranceTableView.register(UINib(nibName: Cells.insuranceHeaderCellNibID, bundle: nil), forCellReuseIdentifier: Cells.insuranceHeaderCellNibID)
        insuranceTableView.register(UINib(nibName: Cells.insuranceProtectCellNibID, bundle: nil), forCellReuseIdentifier: Cells.insuranceProtectCellNibID)
        insuranceTableView.register(CategoriesTVCell.self, forCellReuseIdentifier: categoriesCellId)
        insuranceTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
       // addTempData()
        
        if self.checkConnection() {
            connectionSuccess()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.checkConnection() {
            refreshableData()
        }
    }
    override func connectionSuccess() {
        let when = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.refreshableData()
        }
        let when1 = when + 0.15
        DispatchQueue.main.asyncAfter(deadline: when1) {
            self.fetchInsuranceTypes()
        }
        let when2 = when1 + 0.15
        DispatchQueue.main.asyncAfter(deadline: when2) {
            self.fetchInsurancePartners()
        }
        let when3 = when2 + 0.15
        DispatchQueue.main.asyncAfter(deadline: when3) {
            self.fetchWhyProtect()
        }
    }
    private func refreshableData() {
        self.fetchCarouselData()
    }
    override func willEnterForeground() {
        self.refreshableData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        print(" InsuranceVC deinit called")
    }
}
extension InsuranceVC {
    fileprivate func fetchCarouselData() {
        insuranceNwController
            .onCarouselSuccess { [weak self] (carouselData, isExpired) in
                guard !carouselData.isEmpty && isExpired == false else {
                    self?.carouselSlides = []
                    return
                }
                self?.carouselSlides = carouselData
            }
            .onCarouselError { [weak self] (error) in
                print("\(error)")
                self?.carouselSlides = []
            }
            .fetchInsuranceCarouselData()
    }
    
    fileprivate func fetchInsuranceTypes() {
        insuranceNwController
            .onInsuranceTypesSuccessHandler { [weak self] (insuranceTypes) in
                self?.insuranceTypesModel = insuranceTypes
            }
            .onInsuranceTypesError { (error) in
                print("\(error)")
            }
            .fetchInsuranceTypes()
    }
    
    fileprivate func fetchInsurancePartners() {
        //ShopOnlineNetworkController().fetchInsuranceClick(boundTo: self)
        
        insuranceNwController
            .onInsurancePartnersSuccessHandler { [weak self] (insurancePartnersModel, insurancePartners) in
                self?.insurancePartners = insurancePartners
                self?.insurancePartnerModel = insurancePartnersModel
            }
            .onInsurancePartnersError { (error) in
                print("\(error)")
            }
            .fetchInsurancePartners()
        
    }
    
    fileprivate func fetchWhyProtect() {
        insuranceNwController
            .onWhyProtectSuccess { (whyProtect) in
                self.insuranceProtectDataSource = whyProtect
            }
            .onWhyProtectError { [weak self](error) in
                print("\(error)")
                self?.addTempData()
            }
            .fetchInsuranceWhyProtect()
    }
}

extension InsuranceVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 3) ? insuranceProtectDataSource.count + 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.carouselTVCell, for: indexPath) as? CarouselTVCell
            cell?.carouselSlides = self.carouselSlides
            cell?.tapOnCarousel = { [weak self] (link, logoPath) in
                self?.redirectVC(redirectLink: link, redirectLogoUrl: logoPath)
            }
            return cell!
        case 1:
            return configureHeaderCell(indexPath: indexPath)
        case 2:
            return configurePartnerCell(indexPath: indexPath)
        default:
           return configureProtectCell(indexPath: indexPath)
        }
    }
    
    fileprivate func pushToDetails(data: TypesTuples) {
        self.performSegue(withIdentifier: "toInsuranceDetail", sender: data)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInsuranceDetail" {
            guard let sender = sender as? TypesTuples else {
                return
            }
            
            let insuranceCategories = (segue.destination as? InsuranceCategoriesVC)
            insuranceCategories?.insuranceCatModel = sender.item
        }
    }
}

extension InsuranceVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2, 3:
            return 10
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            var carouselHeight: CGFloat = Carousel_Height
            if let carouselSlides = carouselSlides, carouselSlides.isEmpty {
                carouselHeight = 0
            }
            return carouselHeight
        case 1:
            return DeviceType.IS_IPAD ? 150 : 105
        case 2:
            return 180
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 229 / 255, green: 243 / 255, blue: 1, alpha: 1)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3, insuranceProtectDataSource.count > (indexPath.row - 1) {
            let cellModel = insuranceProtectDataSource[indexPath.row - 1]
            if let url = cellModel.redirectionURL {
                self.redirectVC(redirectLink: url, redirectLogoUrl: cellModel.iconImagePath ?? "")
            }
        }
    }
}

extension InsuranceVC {
    fileprivate func configureHeaderCell(indexPath: IndexPath) -> InsuranceHeaderCell {
        let cell = (insuranceTableView.dequeueReusableCell(withIdentifier: Cells.insuranceHeaderCellNibID, for: indexPath) as? InsuranceHeaderCell)
        cell?.cellModel = insuranceTypesModel
        cell?.collectionActionHandler = { [weak self] (item, index) in
            self?.pushToDetails(data: (item, index))
        }
        return cell!
    }
    
    fileprivate func configurePartnerCell(indexPath: IndexPath) -> CategoriesTVCell {
        let cell = insuranceTableView.dequeueReusableCell(withIdentifier: categoriesCellId, for: indexPath) as? CategoriesTVCell
        cell?.cellModel = insurancePartnerModel
        cell?.categoryOrInsurance = .insurance
        cell?.selectionStyle = .none
        configCellClosure(cell: cell)
        return cell!
    }
    
    private func configCellClosure(cell: CategoriesTVCell?) {
        cell?.selectedPartnerSite(closure: { [weak self] (index) in
            if let strongSelf = self, let partnerDetails = self?.insurancePartners?.partnerDetails {
                let partnerDetail = partnerDetails[index]
                if  partnerDetail.isIntermdPgReq ?? false {
                    strongSelf.pushToPartnerDetail(atIndex: index)
                } else {
                    if let link = partnerDetail.linkUrl, link != "" {
                        strongSelf.redirectVC(redirectLink: link, redirectLogoUrl: partnerDetail.logoImage ?? "")
                    }
                }
            }
        })
    }
    
    private func pushToPartnerDetail(atIndex index: Int) {
        if let partnerDetailsVC = PartnerDetailsVC.storyboardInstance(storyBoardName: "Earn") as? PartnerDetailsVC {
            partnerDetailsVC.onlinePartner = (self.insurancePartners, index) as? (OtherPartner, Int)
            self.navigationController?.pushViewController(partnerDetailsVC, animated: true)
        }
    }
    
    fileprivate func configureProtectCell(indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = insuranceTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.selectionStyle = .none
            self.sectionHeader(title: "Why PAYBACK Protect?", cell: cell)
            return cell
        }
        let cell = (insuranceTableView.dequeueReusableCell(withIdentifier: Cells.insuranceProtectCellNibID, for: indexPath) as? InsuranceProtectCell)
        cell?.cellViewModel = insuranceProtectDataSource[indexPath.row - 1]
        return cell!
    }
    
    fileprivate func addTempData() {
        let data1 = InsuranceProtectCellModel(insuranceTitle: "Best Insurance Solutions", insuranceDetail: "With top insurance provided on board, we have variety of solutions for you.")
        insuranceProtectDataSource.append(data1!)
        
        let data2 = InsuranceProtectCellModel(insuranceTitle: "Best Insurance Solutions Best Insurance Solutions Best Insurance Solutions", insuranceDetail: "With top insurance provided on board, we have variety of  solutions for you With top insurance provided on board, we have variety of  solutions for you With top insurance provided on board, we have variety of  solutions for you")
        insuranceProtectDataSource.append(data2!)
        
        let data3 = InsuranceProtectCellModel(insuranceTitle: "Best Insurance Solutions Best Insurance Solutions Best Insurance Solutions Best Insurance Solutions", insuranceDetail: "With top insurance provided on board, we have variety of  solutions for you")
        insuranceProtectDataSource.append(data3!)
    }
    
    fileprivate func sectionHeader(title: String, cell: UITableViewCell) {
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.backgroundColor = .clear
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = ColorConstant.insurancePartnerTitleColor
        titleLabel.font = FontBook.Regular.of(size: 17.5)
        cell.addSubview(titleLabel)
        
        let underLineView = UIView(frame: .zero)
        underLineView.backgroundColor = ColorConstant.bottomLineColor
        underLineView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 16).isActive = true
        
        cell.addSubview(underLineView)
        underLineView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 25).isActive = true
        underLineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        underLineView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        underLineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        underLineView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -15)
    }
}
