//
//  ExploreLandingVC.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/28/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ExploreLandingVC: BaseViewController {
    
    @IBOutlet weak fileprivate var baseStaticTableView: PBBaseControllerTableView!
    
    let tilesFetcher = LandingTilesGridFetcher()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorConstant.vcBGColor
        setupViews()
        if self.checkConnection() {
            connectionSuccess()
        }
    }

    override func connectionSuccess() {
        fetchTiles()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupViews() {
        baseStaticTableView.didSelectAtIndexPath = { [weak self] (indexPath) in
            switch indexPath.section {
            case 0:
                let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
                let paybackPlusController = profileStoryboard.instantiateViewController(withIdentifier: "UpGradePayBackPlusVC") as? UpGradePayBackPlusVC
                self?.navigationController?.pushViewController(paybackPlusController!, animated: true)
            case 1:
                self?.performSegue(withIdentifier: "InsuranceVC", sender: nil)
            case 2:
                if let onlinePartner = OnlinePartnersVC.storyboardInstance(storyBoardName: "Burn") as? OnlinePartnersVC {
                    onlinePartner.landingType = .carporateRewards
                    self?.navigationController?.pushViewController(onlinePartner, animated: true)
                }
            case 3:
                let explore_Payback = ExplorePaybackViewController.storyboardInstance(storyBoardName: "Explore") as? ExplorePaybackViewController
                self?.navigationController?.pushViewController(explore_Payback!, animated: true)
            default:
                break
            }
        }
    }
    
    deinit {
        print("Explore Landing VC deinit called")
    }
}

extension ExploreLandingVC {
    fileprivate func fetchTiles() {
        tilesFetcher
            .onSuccess { [weak self] (tiles) in
                self?.baseStaticTableView.staticDatas = tiles
            }
            .onError { (error) in
                print("\(error)")
            }
            .fetchExplore()
    }
}
