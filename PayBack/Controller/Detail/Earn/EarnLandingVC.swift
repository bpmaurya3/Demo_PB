//
//  EarnLandingVC.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/28/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class EarnLandingVC: BaseViewController {
    
    @IBOutlet weak fileprivate var baseStaticTableView: PBBaseControllerTableView!
    
    let tilesFetcher = LandingTilesGridFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorConstant.vcBGColor
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.checkConnection() {
            fetchTiles()
        }
    }
    
    override func connectionSuccess() {
        fetchTiles()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("EarnLandingVC deinit called")
    }
    
    private func setupViews() {        
        baseStaticTableView.didSelectAtIndexPath = { [weak self] (indexPath) in
            switch indexPath.section {
            case 0:
                if let instoreVC = InStorePartnersVC.storyboardInstance(storyBoardName: "InStore") as? InStorePartnersVC {
                    self?.navigationController?.pushViewController(instoreVC, animated: true)
                }
            case 1:
                self?.performSegue(withIdentifier: SegueIdentifier.baseOnlinePartners, sender: nil)
            case 2:
                if let onlinePartner = OnlinePartnersVC.storyboardInstance(storyBoardName: "Burn") as? OnlinePartnersVC {
                    onlinePartner.landingType = .bankingService
                    self?.navigationController?.pushViewController(onlinePartner, animated: true)
                }
            case 3:
                let isUserLogedInStatus = UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged)
                let burn_VoucherWorld = PoliciesVC.storyboardInstance(storyBoardName: "Profile") as? PoliciesVC
                burn_VoucherWorld?.type = .voucherWorld
                if isUserLogedInStatus {
                    self?.navigationController?.pushViewController(burn_VoucherWorld!, animated: true)
                } else {
                    self?.signInAction(viewController: burn_VoucherWorld)
                }
            case 4:
                let instantVouchers = PoliciesVC.storyboardInstance(storyBoardName: "Profile") as? PoliciesVC
                instantVouchers?.type = .reviews
                self?.navigationController?.pushViewController(instantVouchers!, animated: true)
               // self?.performSegue(withIdentifier: SegueIdentifier.reviewVC, sender: nil)
            case 5:
                //self?.performSegue(withIdentifier: SegueIdentifier.surveyVC, sender: nil)
                break
            default:
                break
            }
        }
    }
}

extension EarnLandingVC {
    fileprivate func fetchTiles() {
        tilesFetcher
            .onSuccess { [weak self] (tiles) in
                self?.baseStaticTableView.staticDatas = tiles
            }
            .onError { (error) in
                print("\(error)")
            }
            .fetchEarn()
    }
    
    fileprivate func signInAction(viewController: UIViewController? = nil) {
        var tempViewController: UIViewController?
        self
            .onLoginSuccess { [weak self] in
                if let vc = viewController {
                    tempViewController = vc
                }
                self?.stopActivityIndicator()
                if let viewController = tempViewController {
                    self?.slideMenuController()?.changeMainViewController(viewController, close: true)
                    tempViewController = nil
                }
            }
            .onLoginError(error: { [weak self] (error) in
                self?.stopActivityIndicator()
                self?.showErrorView(errorMsg: error)
            })
            .signInPopUp()
    }
}
