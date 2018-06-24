//
//  MyOrdersVC.swift
//  PayBack
//
//  Created by Dinakaran M on 18/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class MyOrdersVC: BaseViewController {

    @IBOutlet weak private var navigationView: DesignableNav!
    @IBOutlet weak fileprivate var collectionView: UICollectionView!
    fileprivate var viewModel: MyCartVM!
    fileprivate let mycartNwController = MyCartNetworkController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorConstant.vcBGColor
        
        navigationView.title = "MY ORDERS"
        collectionView.register(BaseMycartCVCell.self, forCellWithReuseIdentifier: "BaseMycartCVCell")
        viewModel = MyCartVM(networkController: mycartNwController)
        viewModel.bindToMyCartViewModels = {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        if self.checkConnection() {
            connectionSuccess()
        }
    }
    
    override func connectionSuccess() {
        self.startActivityIndicator()
        self.viewModel
            .onTokenExpired { [weak self] in
                self?.signInPopUp()
                self?.stopActivityIndicator()
            }
            .onSuccess { [weak self] in
                self?.stopActivityIndicator()
            }
            .onError {[weak self] in
                self?.stopActivityIndicator()
            }
            .fetchMyOrder()
    }
    override func userLogedIn(status: Bool) {
        if status {
            connectionSuccess()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("Deinit called - MyOrdersVC")
    }
}

extension MyOrdersVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BaseMycartCVCell", for: indexPath) as? BaseMycartCVCell
        cell?.backgroundColor = .clear
        cell?.tabSelectionType = self.viewModel.configuration.tabSelectionType
        cell?.cellType = self.viewModel.configuration.cellType
        cell?.cellModel = self.viewModel.dataSource
        cell?.trackActionHandler = { [weak self] data in
            print("track clicked \(data)")
            self?.navigateToTrackOrder(withTrackData: data)
        }
        return cell!
    }
    func updateSignInPopUp(typeCodeMsg: String) {
        self.showErrorView(errorMsg: "\(typeCodeMsg) - please try to SignIn")
        self.signInPopUp()
    }
}

extension MyOrdersVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MyOrdersVC {
    fileprivate func navigateToTrackOrder(withTrackData data: MyOrderTVCellModel) {
        let storyBoard = UIStoryboard(name: "Profile", bundle: nil)
        let trackOrderVC = storyBoard.instantiateViewController(withIdentifier: "TrackOrderVC") as? TrackOrderVC
        trackOrderVC?.orderBatchID = data.orderBatchId!
        trackOrderVC?.orderID = data.orderId!
        self.navigationController?.pushViewController(trackOrderVC!, animated: true)
    }
}
