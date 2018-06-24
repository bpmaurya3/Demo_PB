//
//  OtherOnlinePartnersVC.swift
//  PayBack
//
//  Created by Mohsin Surani on 05/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class OtherOnlinePartnersVC: BaseViewController {
    var viewModel: OnlinePartnerVM!
    
    @IBOutlet weak private var onlinePartnerCollectionView: UICollectionView!
    fileprivate var collectionViewCellTypes = [OnlinePartnerCellType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        self.view.backgroundColor = ColorConstant.vcBGColor
        viewModel = OnlinePartnerVM()
        viewModel.bindToCarouselViewModels = { [unowned self] in
            self.onlinePartnerCollectionView.reloadData()
        }
        viewModel.bindToTilesViewModels = { [unowned self] in
            self.onlinePartnerCollectionView.reloadData()
        }
        if self.checkConnection() {
            networkCall()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.checkConnection(withErrorViewYPosition: 0) {
            refreshableAPIs()
        }
    }
    
    override func connectionSuccess() {
        networkCall()
        refreshableAPIs()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        self.viewModel.invalidateObservers()
        print("OtherOnlinePartnersVC Deinit called")
    }
    
    override func willEnterForeground() {
        refreshableAPIs()
    }
    
    private func registerCells() {
        collectionViewCellTypes = [.carouselCVCell, .onlinePartnerCell]
        
        self.onlinePartnerCollectionView.register(UINib(nibName: Cells.onlinePartnerCell, bundle: nil), forCellWithReuseIdentifier: Cells.onlinePartnerCell)
        self.onlinePartnerCollectionView.register(CarouselCVCell.self, forCellWithReuseIdentifier: Cells.carouselCVCell)
        self.onlinePartnerCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")

    }
    private func refreshableAPIs() {
        DispatchQueue.global().async {
            self.viewModel.fetchCarousel(carouselFor: .otherOnlinePartner)
        }
        
    }
    private func networkCall() {
        let when = DispatchTime.now() + 0.15
        DispatchQueue.global().asyncAfter(deadline: when, execute: {
            self.viewModel.fetchOtherOnlineParnerData(partnerFor: .otherOnlinePartner)
        })
    }
}

extension OtherOnlinePartnersVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionViewCellTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionViewCellTypes[section] {
        case .carouselCVCell:
            return 1
        default:
            return viewModel.tilesViewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionViewCellTypes[indexPath.section] {
        case .carouselCVCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.carouselCVCell, for: indexPath) as? CarouselCVCell
            cell?.backgroundColor = ColorConstant.vcBGColor
            cell?.carouselSlides = viewModel.carouselViewModel
            cell?.tapOnCarousel = { [weak self] (link, logoPath) in
                self?.redirectVC(redirectLink: link, redirectLogoUrl: logoPath)
            }
            return cell!
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.onlinePartnerCell, for: indexPath) as? OnlinePartnerCell
            cell?.otherOnLinePartnerModel = viewModel.tilesViewModel[indexPath.row]
            return cell!
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0, kind == UICollectionElementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            
            footerView.backgroundColor = ColorConstant.collectionViewBGColor
            return footerView
        }
        return UICollectionReusableView()
    }
    
}

extension OtherOnlinePartnersVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionViewCellTypes[indexPath.section] {
        case .carouselCVCell:
            guard self.viewModel.carouselViewModel != nil else {
                return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 0)
            }
            let cellHeight = Carousel_Height // ratio as per UX (750*336)
            return CGSize(width: ScreenSize.SCREEN_WIDTH, height: cellHeight)
        case .onlinePartnerCell:
            let cellWidth = ScreenSize.SCREEN_WIDTH / 2 - 0.5
            let cellHeight = cellWidth * 2 / 3 // ratio as per UX (375*250)
            
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: self.view.frame.size.width, height: 10)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section != 0 else {
            return
        }
        if let partnerDetails = self.viewModel.otherPartner?.partnerDetails {
            let partnerDetail = partnerDetails[indexPath.item]
            if  partnerDetail.isIntermdPgReq ?? false {
                pushToPartnerDetails(index: indexPath.item)
            } else {
                if let link = partnerDetail.linkUrl, link != "" {
                    redirectVC(redirectLink: link, redirectLogoUrl: partnerDetail.logoImage ?? "")
                }
            }
        }
    }
    
    fileprivate func pushToPartnerDetails(index: Int) {
       if let partnerDetailsVC = PartnerDetailsVC.storyboardInstance(storyBoardName: "Earn") as? PartnerDetailsVC {
            partnerDetailsVC.onlinePartner = (viewModel.otherPartner, index) as? (OtherPartner, Int)
            self.navigationController?.pushViewController(partnerDetailsVC, animated: true)
        }
    }
}
