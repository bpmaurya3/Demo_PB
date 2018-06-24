//
//  PBHelpCentreDetailViewController.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 15/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBHelpCentreDetailViewController: BaseViewController {
    
    let collectionViewCellId = "CVCellId"
    
    @IBOutlet weak private var callus: DesignableButton!
    @IBOutlet weak private var needmoreLabel: UILabel!
    @IBOutlet weak private var writetous: DesignableButton!
    @IBOutlet weak private var navigationView: DesignableNav!
    @IBOutlet weak fileprivate var collectionView: UICollectionView!
    @IBOutlet weak fileprivate var segmentView: CustomSegmentView!
    @IBOutlet weak fileprivate var helpView: UIView!
    @IBOutlet weak fileprivate var mFirstSupportViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak fileprivate var scrollView: UIScrollView!
    
    var categoryType: CategoryType = .helpCentre
    var defaultSelectedIndex = 0
    var helpCenterData: HelpCenter?
    var isWriteClickedData: NSMutableArray = []
    var cameFirstTime: Bool = false
    
    fileprivate var writeView: WriteToUsView?
    private var writeToUsFetcher: WriteToUsFetcher!
    
    fileprivate var segmentTitles: [SegmentCollectionViewCellModel] = [] {
        didSet {
            let font: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 12 : 24
            let segmentConfig = SegmentCVConfiguration()
                .set(title: segmentTitles)
                .set(numberOfItemsPerScreen: 4)
                .set(isImageIconHidden: true)
                .set(fontandsize: FontBook.Regular.of(size: font))
                .set(selectedIndex: defaultSelectedIndex)
                .set(deviderColor: .clear)
                .set(textColor: ColorConstant.textColorPointTitle)
                .set(selectedIndexTextColor: ColorConstant.textTitleColorPink)
            
            segmentView.configuration = segmentConfig
            
            segmentView.configuration?.selectedCompletion = { [weak self] (segmentModel, index) in
                if let strongSelf = self {
                    strongSelf.switchTabs(index)
                }
            }
            
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.reloadData()
            //perform(#selector(switchTabs(_:)), with: defaultSelectedIndex, afterDelay: 0.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.helpView.isHidden = true
        registerCells()
        self.perform(#selector(fetchSegmentItems), with: nil, afterDelay: 0.05)
        needmoreLabel.textColor = ColorConstant.textColorBlue
        needmoreLabel.font = FontBook.Regular.of(size: 15.0)
        writetous.backgroundColor = ColorConstant.buttonBackgroundColorPink
        writetous.titleLabel?.textColor = ColorConstant.textColorWhite
        writetous.titleLabel?.font = FontBook.Regular.of(size: 11.0)
        callus.backgroundColor = ColorConstant.buttonBackgroundColorPink
        callus.titleLabel?.textColor = ColorConstant.textColorWhite
        callus.titleLabel?.font = FontBook.Regular.of(size: 11.0)
        
        writeToUsFetcher = WriteToUsFetcher()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addWriteToUsView()
    }
    
    private func addWriteToUsView() {
        guard let writeView = Bundle.main.loadNibNamed("WriteToUsView", owner: self, options: nil)?.first as? WriteToUsView else {
            return
        }
        writeView.setViewsToHide(thankYouHide: true, model: nil)

        scrollView.addSubview(writeView)
        writeView.frame = CGRect(x: 0, y: scrollView.frame.height - writeView.frame.height, width: scrollView.frame.width, height: writeView.frame.height)
        
        writeView.mobileTextFieldAction = { [weak self] (y, height) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.scrollView.setContentOffset(CGPoint(x: 0, y: y + height + 30), animated: false)

            strongSelf.scrollView.contentSize = CGSize(width: 1, height: strongSelf.scrollView.frame.height)
            strongSelf.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: y + height + 350, right: 0)

            strongSelf.scrollView.scrollRectToVisible(CGRect(x: 0, y: writeView.frame.origin.y + y + 0, width: writeView.frame.width, height: 35), animated: false)
        }
        
        writeView.textViewAction = { [weak self] (y, height) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.scrollView.setContentOffset(CGPoint(x: 0, y: y + height + 30), animated: false)
            
            strongSelf.scrollView.contentSize = CGSize(width: 1, height: strongSelf.scrollView.frame.height)
            strongSelf.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: y + height + 350, right: 0)
            strongSelf.scrollView.scrollRectToVisible(CGRect(x: 0, y: writeView.frame.origin.y + y - height, width: writeView.frame.width, height: 35), animated: false)
        }
        
        writeView.cancelActionHandler = { [weak self] in
            self?.scrollView.isHidden = true
        }
        
        writeView.submitActionHandler = { [weak self] (email, mobileNo, message) in
            self?.submitActionCall(email: email, mobileNo: mobileNo, message: message)
        }
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        self.scrollView.addGestureRecognizer(singleTap)
        self.writeView = writeView
    }
    
    @objc func handleTap() {
        self.scrollView.isHidden = true
        writeView?.resetFields()
        self.view.endEditing(false)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let writeView = self.writeView else {
            return true
        }
        let position = touch.location(in: self.scrollView).y
        if position >= writeView.frame.origin.y {
            return false
        }
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillDisappear() {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        handleTap()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print(" PBHelpCentreDetailViewController deinit called")
    }
    
    func registerCells() {
        collectionView.register(PBOfferContentCVCell.self, forCellWithReuseIdentifier: collectionViewCellId)
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func submitActionCall(email: String?, mobileNo: String?, message: String) {
        let toEmail: String? = nil//"bhuvanendrapratap.maurya@valtech.co.in"
        self.startActivityIndicator()
        writeToUsFetcher
            .onSuccess { [weak self](response) in
                self?.stopActivityIndicator()
                self?.writeView?.setViewsToHide(thankYouHide: false, model: response)
            }
            .onError { [weak self](error) in
                self?.stopActivityIndicator()
                self?.showErrorView(errorMsg: error)
            }
            .sendFeedBack(email: email, mobileNo: mobileNo, message: message, toEmail: toEmail)
    }
}

extension PBHelpCentreDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard var cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellId, for: indexPath) as? PBOfferContentCVCell else {
            return UICollectionViewCell()
        }

        for subview in collectionView.subviews where subview == cell {
            subview.removeFromSuperview()
            cell = (collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellId, for: indexPath) as? PBOfferContentCVCell)!
        }
        
        if cell.frame.origin.y < 0 {
            cell.frame.origin.y = 0
        }
        cell.backgroundColor = .clear
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PBOfferContentCVCell else {
            return
        }
        cell.categoryType = categoryType        
        if let userdata = helpCenterData?.accordionDetails {
            cell.helpCenterUserData = userdata[indexPath.item]
        }
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
        if scrollView == collectionView {
            let index = targetContentOffset.move().x / self.view.frame.width
            scrollSegment(to: Int(index))
        }
    }
}

extension PBHelpCentreDetailViewController {
    
    @objc func switchTabs(_ index: Int) {
//        if index > 0 {
//            defaultSelectedIndex = index
//        }
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: !cameFirstTime)
        cameFirstTime = false
    }
    
    func scrollSegment(to index: Int) {
        segmentView?.selectSegmentAtIndex(index)
    }
    
    @IBAction func writeUsButtonAction(_ sender: Any) {
        scrollView.isHidden = false
        writeView?.setViewsToHide(thankYouHide: true, model: nil)
    }

    @IBAction func callUsButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        // TODO: Need Phone to call customer care
        guard let url: URL = URL(string: "TEL://1234567890") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
             UIApplication.shared.openURL(url)
        }
    }

    @objc fileprivate func fetchSegmentItems() {
        guard let userRelatedData = helpCenterData?.accordionDetails  else {
            return
        }
        var segmentCellModel = [SegmentCollectionViewCellModel]()
        for userData in userRelatedData {
            segmentCellModel.append(SegmentCollectionViewCellModel(title: userData.title, itemId: 0))
        }
        self.segmentTitles = segmentCellModel
    }
}
