//
//  PartnerDetailsVC.swift
//  PayBack
//
//  Created by Dinakaran M on 07/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
enum PartnerCell {
    case heroCarouselTVCell
    case AboutItemCell
    case OtherPartnerCell
}
class PartnerDetailsVC: BaseViewController {
    @IBOutlet weak fileprivate var navView: DesignableNav!
    
    var onlinePartner: (otherPartner: OtherPartner, index: Int)? {
        didSet {
            guard let onlinePartner = onlinePartner else {
                return
            }
            self.allOnlinePartner = onlinePartner.otherPartner
            
            self.dataSegregation(at: onlinePartner.index)
            
            var otherPartnerModelArray = [OtherPartnerCollectionCellModal]()
            
            guard let partnerDetails = onlinePartner.otherPartner.partnerDetails else {
                 self.otherPartnersdata = otherPartnerModelArray
                return
            }
            for partner in partnerDetails {
                otherPartnerModelArray.append(OtherPartnerCollectionCellModal(withPartnerDetails: partner))
            }
            self.otherPartnersdata = otherPartnerModelArray
        }
    }
    fileprivate var aboutSourceData: AboutItemCellModel?
    fileprivate var carouselSlides: [HeroBannerCellModel]?
    fileprivate var otherPartnersdata: [OtherPartnerCollectionCellModal] = [OtherPartnerCollectionCellModal]()
    fileprivate var allOnlinePartner: OtherPartner?
    fileprivate var tableViewCellType: [PartnerCell] = [PartnerCell]()
    @IBOutlet weak private var tableview: UITableView!
    fileprivate var pageTitle = "Partner Details" {
        didSet {
            if navView != nil {
                self.navView.title = pageTitle.uppercased()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.register(UINib(nibName: Cells.aboutItemCellId, bundle: nil), forCellReuseIdentifier: Cells.aboutItemCellId)
        self.tableview.register(CarouselTVCell.self, forCellReuseIdentifier: Cells.carouselTVCell)
        self.tableview.bounces = false
        tableViewCellType = [.heroCarouselTVCell, .AboutItemCell, .OtherPartnerCell]
        self.navView.title = pageTitle
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
        } else {
            self.redirectUrl = nil
            self.partnerlogoUrl = nil
        }
    }
}
extension PartnerDetailsVC {
    fileprivate func dataSegregation(at index: Int) {
        guard let onlinePartner = allOnlinePartner, let partnerDetails = onlinePartner.partnerDetails else {
            return
        }
        let partnerDetail = partnerDetails[index]
        pageTitle = partnerDetail.pageTitle ?? "Partner Details"
        aboutSourceData = AboutItemCellModel(logoUrl: partnerDetail.logoImage ?? "", discreption: partnerDetail.pageDescription, earnPointMsg: partnerDetail.ctaButtonText, earnPointLinkUrl: partnerDetail.ctaButtonLink, linkAccountMsg: partnerDetail.videotutorialText, videoLinkUrl: partnerDetail.videoTutorialLink)
        var cellModelArray = [HeroBannerCellModel]()
        guard let carouselElements = partnerDetail.pageCarouselElements, partnerDetail.pageCarouselExp == false else {
            self.carouselSlides = cellModelArray
            return
        }
        for carousel in carouselElements {
            cellModelArray.append(HeroBannerCellModel(withPartnerDetails: carousel, logoImagePath: partnerDetail.logoImage ?? ""))
        }
        self.carouselSlides = cellModelArray
    }
    fileprivate func selectOtherPartner(at index: Int) {
        self.dataSegregation(at: index)
        self.tableview.reloadSections([0, 1], with: .automatic)
    }
}

extension PartnerDetailsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewCellType.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewCellType[indexPath.section] {
        case PartnerCell.heroCarouselTVCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.carouselTVCell, for: indexPath) as? CarouselTVCell
            cell?.carouselSlides = carouselSlides
            cell?.tapOnCarousel = { [weak self] (link, logoPath) in
                self?.redirectVC(redirectLink: link, redirectLogoUrl: logoPath)
            }
            return cell!
        case PartnerCell.AboutItemCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.aboutItemCellId, for: indexPath) as? AboutPartnerTVCell
            cell?.aboutItemCell = aboutSourceData
            cell?.earnPointsClosure = { [weak self] in
                guard let strongSelf = self, let url = strongSelf.aboutSourceData?.earnPointLinkUrl else {
                    return
                }
                strongSelf.redirectVC(redirectLink: url, redirectLogoUrl: strongSelf.aboutSourceData?.logoUrl)
            }
            cell?.videoClosure = { [weak self] in
                guard let strongSelf = self, let url = strongSelf.aboutSourceData?.videoLinkUrl else {
                    return
                }
                strongSelf.redirectVC(redirectLink: url, redirectLogoUrl: strongSelf.aboutSourceData?.logoUrl)
            }
            return cell!
        case PartnerCell.OtherPartnerCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.otherpartnerCellId, for: indexPath) as? OtherPartnerTVCell
            cell?.sourceData = otherPartnersdata
            cell?.tapOtherPartnerClosure = { [weak self] index in
                self?.selectOtherPartner(at: index)
            }
            return cell!
        }
    }
}
extension PartnerDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return (carouselSlides == nil || (carouselSlides?.isEmpty)!) ? 0 : Carousel_Height //190
        }
        return UITableViewAutomaticDimension
    }
    
}
