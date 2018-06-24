//
//  MyCartVC.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/4/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class MyCartVC: BaseViewController {
    @IBOutlet weak private var navigationView: DesignableNav!
    @IBOutlet weak fileprivate var segmentHeightConstraint: NSLayoutConstraint!
    fileprivate var cellHeight: CGFloat = 0.0
    @IBOutlet weak fileprivate var collectionView: UICollectionView!
    @IBOutlet weak fileprivate var segmentView: CustomSegmentView!
    @IBOutlet weak private var segmentControl: UISegmentedControl!
    @IBOutlet weak fileprivate var bottomSegmentHeighConstraint: NSLayoutConstraint!
    
    internal var viewModel: MyCartVM!
    fileprivate let mycartNwController = MyCartNetworkController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorConstant.vcBGColor
        collectionView.backgroundColor = .clear
        collectionView.register(BaseMycartCVCell.self, forCellWithReuseIdentifier: "BaseMycartCVCell")
        
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        self.bottomSegmentHeighConstraint.constant = 0
        viewModel = MyCartVM(networkController: mycartNwController)
        viewModel.bindToMyCartViewModels = {
            DispatchQueue.main.async {
                self.bottomSegmentHeighConstraint.constant = self.segmentView.configuration?.selectedIndex == 0 ? 0 : self.viewModel.dataSource.isEmpty ? 0 : 49

//                self.bottomSegmentHeighConstraint.constant = self.viewModel.dataSource.isEmpty ? 0 : 49
                self.collectionView.reloadData()
            }
        }
        setupSegmentView()
    }
    override func viewDidDisappear(_ animated: Bool) {
        segmentControl.selectedSegmentIndex = UISegmentedControlNoSegment
        setSegmentSelectedIndexTintColor(sender: segmentControl)
        super.viewDidDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    private func setNavigtionTitle(at index: Int) {
        self.navigationView.title = index == 0 ? "MY ORDERS" : "MY CART"
    }
    private func setupSegmentView() {
       
        let segmentTitle1 = SegmentCollectionViewCellModel(image: UIImage(), title: "My Orders", itemId: 1)
        let segmentTitle2 = SegmentCollectionViewCellModel(image: UIImage(), title: "My Cart", itemId: 2)
        
        let titles = [segmentTitle1, segmentTitle2]
        
        let config = SegmentCVConfiguration()
            .set(title: titles)
            .set(numberOfItemsPerScreen: 2)
            .set(isImageIconHidden: true)
            .set(segmentItemSpacing: 1)
            .set(selectedIndex: 1)
        
        segmentView.configuration = config
        
        segmentView.configuration?.selectedCompletion = { [weak self] (segmentModel, index) in
            print("\(index)")
            if let strongSelf = self {
                strongSelf.switchTabs(index)
            }
        }
        
        self.segmentControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: UIControlState.selected)
        self.segmentControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: UIControlState.normal)
        
        scrollCollectionView(at: 1, withAnimation: false)
        
        if let index = segmentView.configuration?.selectedIndex {
            self.setNavigtionTitle(at: index)
        }
    }
    
    private func switchTabs(_ index: Int) {
        scrollCollectionView(at: index, withAnimation: true)
        self.setNavigtionTitle(at: index)
    }
    
    private func scrollCollectionView(at index: Int, withAnimation: Bool) {
       self.viewModel.configuration.set(cellType: .none)
        DispatchQueue.global().async {
            if index == 0 {
                self.viewModel
                    .onTokenExpired { [weak self] in
                        self?.signInPopUp()
                    }
                    .fetchMyOrder()
            } else {
                self.viewModel.fetchMyCart()
            }
        }
        let indexPath = IndexPath(item: index, section: 0)
        let when1 = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: when1) { [weak self] in
            self?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: withAnimation)
        }

    }
    
    override func userLogedIn(status: Bool) {
        if status {
            self.scrollCollectionView(at: segmentView.configuration?.selectedIndex ?? 0, withAnimation: false)
        }
    }
    // MARK: Actions
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setSegmentSelectedIndexTintColor(sender: UISegmentedControl) {
        let sortedViews = sender.subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x })
        
        for (index, view) in sortedViews.enumerated() {
            if index == sender.selectedSegmentIndex {
                view.tintColor = ColorConstant.shopNowButtonBGColor
            } else {
                view.tintColor = UIColor.lightGray
            }
        }
    }
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        print("Selected Index \(sender.selectedSegmentIndex)")
        setSegmentSelectedIndexTintColor(sender: sender)
        if sender.selectedSegmentIndex == 0 {
            if let viewController = self.getPreviousViewController(of: "RewardsCatalogueVC") {
                self.navigationController?.popToViewController(viewController, animated: true)
            } else {
                let rewardsCatalogueVC = RewardsCatalogueVC.storyboardInstance(storyBoardName: "Burn") as? RewardsCatalogueVC
                self.navigationController?.pushViewController(rewardsCatalogueVC!, animated: true)
            }
        }
    }
}

extension MyCartVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BaseMycartCVCell", for: indexPath) as? BaseMycartCVCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .clear
        cell.tabSelectionType = self.viewModel.configuration.tabSelectionType
        cell.cellType = self.viewModel.configuration.cellType
        cell.cellModel = self.viewModel.dataSource
        cell.trackActionHandler = { [weak self] index in
            print("track clicked \(index)")
            self?.navigateToTrackOrder(data: index)
        }
        cell.crossClosure = { [weak self] (model) in
            self?.viewModel.deleteCellModel(model: model)
        }
        return cell
    }
}

extension MyCartVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.move().x / view.frame.width
        segmentView.selectSegmentAtIndex(Int(index))
    }
}
extension MyCartVC {
    fileprivate func navigateToTrackOrder(data: MyOrderTVCellModel) {
        guard let trackVC = TrackOrderVC.storyboardInstance(storyBoardName: "Profile") as? TrackOrderVC else {
            return
        }
        if let orderid = data.orderId {
            trackVC.orderID = orderid
        }
        if let orderBatchId = data.orderBatchId {
            trackVC.orderBatchID = orderBatchId
        }
        self.navigationController?.pushViewController(trackVC, animated: true)
    }
}
