//
//  BurnLandingVC.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/28/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class BurnLandingVC: BaseViewController {

    @IBOutlet weak fileprivate var baseStaticTableView: PBBaseControllerTableView!
    
    let tilesFetcher = LandingTilesGridFetcher()
    var tempViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        if self.checkConnection() {
            fetchTiles()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func connectionSuccess() {
        fetchTiles()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("BurnLandingVC: Deinit called")
    }
    
    private func setupViews() {
        baseStaticTableView.didSelectAtIndexPath = { [weak self] (indexPath) in
            let isUserLogedInStatus = UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged)
            switch indexPath.section {
            case 1:
                self?.performSegue(withIdentifier: "RewardsCatalogueVC", sender: nil)
            case 3:
                let instoreVC = InStorePartnersVC.storyboardInstance(storyBoardName: "InStore") as? InStorePartnersVC
                self?.navigationController?.pushViewController(instoreVC!, animated: true)
            case 0:
                let burn_VoucherWorld = PoliciesVC.storyboardInstance(storyBoardName: "Profile") as? PoliciesVC
                burn_VoucherWorld?.type = .voucherWorld
                if isUserLogedInStatus {
                    self?.navigationController?.pushViewController(burn_VoucherWorld!, animated: true)
                } else {
                    self?.signInAction(viewController: burn_VoucherWorld)
                }
            case 2:
                self?.performSegue(withIdentifier: "OnlinePartnersVC", sender: nil)
            default:
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OnlinePartnersVC", let destinationController = segue.destination as? OnlinePartnersVC {
            destinationController.landingType = .burnProduct
        }
    }
    
    func signInAction(viewController: UIViewController? = nil) {
        self
            .onLoginSuccess { [weak self] in
                if let vc = viewController {
                    self?.tempViewController = vc
                }
                //                self?.setView()
                //                self?.slideMenuController()?.closeLeft()
                self?.stopActivityIndicator()
                if let viewController = self?.tempViewController {
                    self?.slideMenuController()?.changeMainViewController(viewController, close: true)
                    self?.tempViewController = nil
                }
            }
            .onLoginError(error: { [weak self] (error) in
                self?.stopActivityIndicator()
                self?.showErrorView(errorMsg: error)
            })
            .signInPopUp()
    }
}

extension BurnLandingVC {
    fileprivate func fetchTiles() {
        self.startActivityIndicator()
        tilesFetcher
            .onSuccess { [weak self] (tiles) in
                self?.stopActivityIndicator()
                self?.baseStaticTableView.staticDatas = tiles
            }
            .onError { [weak self] (error) in
                self?.stopActivityIndicator()
                print("\(error)")
            }
            .fetchBurn()
    }
}
