//
//  TransactionSuccVC.swift
//  PayBack
//
//  Created by Mohsin Surani on 08/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class TransactionSuccVC: BaseViewController {
    
    @IBOutlet weak private var shopButton: DesignableButton!
    @IBOutlet weak private var tranSuccLabel: UILabel!
    @IBOutlet weak private var payCreditLabel: UILabel!
    
    fileprivate let memberDashBoardNWController = MemberDashBoardNWController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.fetch()
    }
    
    @IBAction func shopAction(_ sender: Any) {
        if let viewController = self.getPreviousViewController(of: "RewardsCatalogueVC") {
            self.navigationController?.popToViewController(viewController, animated: true)
        } else if let rewardsCatalogueVC = RewardsCatalogueVC.storyboardInstance(storyBoardName: "Burn") as? RewardsCatalogueVC {
            self.navigationController?.pushViewController(rewardsCatalogueVC, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("TransactionSuccVC deinit called")
    }
    private func fetch() {
        if self.checkConnection() {
            self.memberDashBoardNWController
                .onTokenExpired {
                    print("Get Member DashBoard - Token")
                }
                .onError { (error) in
                    print("Get Member DashBoard - Fail: \(error)")
                }
                .onSuccess {[weak self] _ in
                    print("Get Member DashBoard - Success")
                    self?.setupLogedInUserNavigationBarItems()
                }
                .getMemberDetails()
        }
    }
}
