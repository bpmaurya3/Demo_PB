//
//  InstantVoucherVC.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 5/21/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit

class InstantVoucherVC: BaseViewController {

    @IBOutlet weak private var navigationBarView: DesignableNav!
    
    @IBOutlet weak private var collectionView: UICollectionView!
    fileprivate var collectionViewCellTypes = [OnlinePartnerCellType]()
    var showCaseTuple: ShowCaseTuple?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        self.navigationBarView.title = showCaseTuple?.title ?? ""
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        print("InstantVoucherVC: Deinit called")
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
    
    private func registerCells() {
        collectionViewCellTypes = [.carouselCVCell, .onlinePartnerCell]
        self.collectionView.register(UINib(nibName: Cells.homeShowCaseCVCell, bundle: nil), forCellWithReuseIdentifier: Cells.homeShowCaseCVCell)
        self.collectionView.register(CarouselCVCell.self, forCellWithReuseIdentifier: Cells.carouselCVCell)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
    }
}

extension InstantVoucherVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionViewCellTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionViewCellTypes[section] {
        case .carouselCVCell:
            return 1
        default:
            return showCaseTuple?.items.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionViewCellTypes[indexPath.section] {
        case .carouselCVCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.carouselCVCell, for: indexPath) as? CarouselCVCell
            cell?.backgroundColor = ColorConstant.vcBGColor
            if let carousel = showCaseTuple?.carousels {
                cell?.carouselSlides = carousel
            }
            cell?.tapOnCarousel = { [weak self] (link, logoPath) in
                self?.redirectVC(redirectLink: link, redirectLogoUrl: logoPath)
            }
            return cell!
        case .onlinePartnerCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.homeShowCaseCVCell, for: indexPath) as? HomeShowCaseCVCell
            cell?.cellModel = showCaseTuple?.items[indexPath.item]
            cell?.buyNowClosure = { [weak self] (model) in
                if let url = model.redirectionURL, url != "" {
                    self?.redirectVC(redirectLink: url, redirectLogoUrl: model.itemImagePath ?? "")
                }
            }
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

extension InstantVoucherVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionViewCellTypes[indexPath.section] {
        case .carouselCVCell:
            guard let tuple = self.showCaseTuple, !tuple.carousels.isEmpty else {
                return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 0)
            }
            let cellHeight = Carousel_Height // ratio as per UX (750*336)
            return CGSize(width: ScreenSize.SCREEN_WIDTH, height: cellHeight)
        case .onlinePartnerCell:
            let cellWidth = ScreenSize.SCREEN_WIDTH / 2 - 0.5
            let cellHeight = cellWidth * 3 / 2.8 // ratio as per UX (375*250)
            
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
    
}
