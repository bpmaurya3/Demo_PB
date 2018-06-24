//
//  InsuranceCategoriesVC.swift
//  PayBack
//
//  Created by Valtech Macmini on 26/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class InsuranceCategoriesVC: BaseViewController {
    
    let collectionViewCellId = "CVCellId"
    fileprivate var noDataText = ""
    fileprivate var viewPageStack: [String: [String: Any]]!

    var insuranceTypeTag: String?
    var insuranceCatModel: ShopClickCellViewModel? {
        didSet {
            setData()
        }
    }
    let categoryType: CategoryType = .insuranceDetail
    
    let insuranceNwController = ExploreNWController()

    @IBOutlet weak fileprivate var customSegment: CustomSegmentView!
    @IBOutlet weak fileprivate var collectionView: UICollectionView!
    @IBOutlet weak fileprivate var navView: DesignableNav!

    fileprivate var segmentTitles: [SegmentCollectionViewCellModel] = [] {
        didSet {
            let config = SegmentCVConfiguration()
                .set(title: segmentTitles)
                .set(numberOfItemsPerScreen: segmentTitles.count < 2 ? 1 : 2)
                .set(isImageIconHidden: false)
                .set(selectedIndex: 0)
                .set(selectedIndexBottomLineColor: ColorConstant.segmentSelectedBottomLineColor)
                .set(segmentItemSpacing: 1)
            
            customSegment.configuration = config
            
            customSegment.configuration?.selectedCompletion = { [weak self] (segmentModel, index) in
                self?.switchTabs(index)
            }
            collectionView.reloadData()
        }
    }
    var defaultSelectedIndex = 0 {
        didSet {
            customSegment.selectSegmentAtIndex(defaultSelectedIndex)
        }
    }
    fileprivate var cellModel: [CouponsRechargeCellModel] = [] {
        didSet {
            if cellModel.isEmpty {
                noDataText = StringConstant.No_Data_Found
            }
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewPageStack = [:]
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PBOfferContentCVCell.self, forCellWithReuseIdentifier: collectionViewCellId)
        collectionView.isScrollEnabled = true
        collectionView.bounces = false
        if let title = insuranceCatModel?.title {
            navView.title = title
        }
        if self.checkConnection() {
            connectionSuccess()
        }
    }
    
    private func setData() {
        fetchInsuranceSegmentImages()
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
    override func connectionSuccess() {
        if segmentTitles.isEmpty {
            self.setData()
            return
        }
        self.switchTabs(customSegment.configuration?.selectedIndex ?? 0)
    }
    deinit {
        print(" InsuranceCategoriesVC deinit called")
    }
}

extension InsuranceCategoriesVC {
    fileprivate func fetchInsuranceSegmentImages() {
        guard  let tag = insuranceCatModel?.filterTag else {
            return
        }
        self.startActivityIndicator()
        insuranceNwController
            .onInsuranceSubTypesSuccessHandler { [weak self] (segmentItem) in
                self?.stopActivityIndicator()
                self?.segmentTitles = segmentItem
            }
            .onInsuranceSubTypesError { [weak self] (error) in
                self?.stopActivityIndicator()
                print("\(error)")
            }
            .fetchInsuranceSubTypes(tag: tag)
    }
    fileprivate func fetchInsuranceDetails(withCategory categoryTag: String ) {
        guard self.checkConnection() else {
            return
        }
        self.startActivityIndicator()
        insuranceNwController
            .onInsuranceDetailSuccess(success: { [weak self](insuranceDetails) in
                self?.stopActivityIndicator()
                self?.cellModel = insuranceDetails
                self?.storeDataInDictionary(self?.cellModel, categoryTag: categoryTag)
            })
            .onInsuranceDetailError { [weak self] _ in
                self?.stopActivityIndicator()
                self?.cellModel = []
                self?.storeDataInDictionary(self?.cellModel, categoryTag: categoryTag)
            }
            .fetchInsuranceDetail(tag: categoryTag)
    }
}
extension InsuranceCategoriesVC {
    fileprivate func storeDataInDictionary(_ cellModel: [CouponsRechargeCellModel]?, categoryTag: String) {
        var stack: [String: Any] = [:]
        if let model = cellModel {
            let firstTenModel = Array(model.prefix(10))
            stack["model"] = firstTenModel
        }
        viewPageStack[categoryTag] = stack
    }
    
    fileprivate func switchTabs(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        let categoryTag = segmentTitles[indexPath.item].itemId!

        if let pageStack = viewPageStack, let stack = pageStack[categoryTag], let model = stack["model"] as? [CouponsRechargeCellModel], !model.isEmpty {
                self.cellModel = model
        } else {
            self.fetchInsuranceDetails(withCategory: categoryTag)
        }
    }
    
    fileprivate func scrollSegment(to index: Int) {
        customSegment?.selectSegmentAtIndex(index)
    }
}

extension InsuranceCategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellId, for: indexPath) as? PBOfferContentCVCell
        cell?.redirectUrl(closure: { [weak self] (redirectUrl, partnerLogo) in
            print(redirectUrl)
            self?.redirectVC(redirectLink: redirectUrl, redirectLogoUrl: partnerLogo)
        })
        cell?.backgroundColor = .clear
        return cell!
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PBOfferContentCVCell else {
            return
        }
        cell.categoryType = categoryType
        cell.loadMoreInfo = (0, 0, false, noDataText)
        cell.cellModel = cellModel
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.move().x / self.view.frame.width
        scrollSegment(to: Int(index))
    }
}
