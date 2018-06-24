//
//  MyAccountVC.swift
//  PayBack
//
//  Created by Dinakaran M on 18/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class MyAccountVC: BaseViewController {
    
    enum TabIndex: Int {
        case firstChildTab = 0
        case secondChildTab = 1
    }
    
    @IBOutlet weak private var navigationView: DesignableNav!
    
    @IBOutlet weak fileprivate var containerView: UIView!
    @IBOutlet weak private var segmentView: CustomSegmentView!
    var defaultSelectedIndex: Int = 0
    var currentViewController: UIViewController?
    fileprivate let memberDashBoardNWController = MemberDashBoardNWController()

    lazy var myProfileVC: UIViewController? = {
        let myProfile = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyProfileViewController
        myProfile?.updateEditprofileStatus(closure: { [weak self] (status) in
            if status {
                    self?.memberDashBoardNWController
                        .onTokenExpired { [weak self] in
                            print("Get Member DashBoard - Token")
                            myProfile?.editProfileSavePopupActionClosure(false)
                        }
                        .onError { [weak self] _ in
                            print("Get Member DashBoard - Fail")
                            myProfile?.editProfileSavePopupActionClosure(false)
                        }
                        .onSuccess {[weak self]( _ ) in
                            print("Get Member DashBoard - Success")
                            self?.setupLogedInUserNavigationBarItems()
                            myProfile?.editProfileSavePopupActionClosure(true)
                        }
                        .getMemberDetails()
                }
        })
        myProfile?.updateInvalidToken(closure: { [weak self] (InvalidTokenMsg) in
            self?.showErrorView(errorMsg: "\(InvalidTokenMsg) - please try to SignIn")
            self?.userSinInPopUp()
        })
        return myProfile!
    }()
    func userSinInPopUp() {
        self.signInPopUp()
    }
    override func userLogedIn(status: Bool) {
        print("My Account User Loged In Success")
    }
    lazy var myCards: UIViewController? = {
        let myCards = self.storyboard?.instantiateViewController(withIdentifier: "MyCardsViewController") as? MyCardsViewController
        return myCards!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentView()
        displayCurrentTab(defaultSelectedIndex)
        navigationView.isAddedInMyProfile = true
        navigationView.onBack {[weak self] in
            self?.backAction()
        }

        // Do any additional setup after loading the view.
    }
    private func setupSegmentView() {
        let segmentTitle1 = SegmentCollectionViewCellModel(image: nil, title: NSLocalizedString("My Profile", comment: "MyAccount-Profile Segment title"), itemId: 1)
        let segmentTitle2 = SegmentCollectionViewCellModel(image: nil, title: NSLocalizedString("My Cards", comment: "MyAccount-Cards Segment title"), itemId: 2)
        
        let titles = [segmentTitle1, segmentTitle2]
        
        let config = SegmentCVConfiguration()
            .set(title: titles)
            .set(numberOfItemsPerScreen: 2)
            .set(isImageIconHidden: true)
            .set(segmentItemSpacing: 1)
        
        segmentView.configuration = config
        
        segmentView.configuration?.selectedCompletion = { [weak self] (segmentModel, index) in
            if let strongSelf = self {
                strongSelf.displayCurrentTab(index)
            }
        }
        
        segmentView.configuration?.set(selectedIndex: defaultSelectedIndex)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        print("MyAccount Deinit called")
    }
}
extension MyAccountVC {
    fileprivate func backAction() {
        if isProfileEditing {
            self.openAlertPopupForEditProfile()
            self.onAlertPopupForEditProfile { [weak self] in
                self?.backAction()
            }
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    fileprivate func displayCurrentTab(_ tabIndex: Int) {
        if isProfileEditing, tabIndex == 1 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.segmentView.selectSegmentAtIndex(0)
            }
            self.openAlertPopupForEditProfile()
            self.onAlertPopupForEditProfile { [weak self] in
                self?.displayCurrentTab(tabIndex)
                self?.segmentView.selectSegmentAtIndex(1)
            }
            return
        }
        if let currentVC = self.currentViewController {
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParentViewController()
        }
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            vc.view.frame = containerView.bounds
            containerView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    fileprivate func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.firstChildTab.rawValue :
            vc = myProfileVC
        case TabIndex.secondChildTab.rawValue :
            vc = myCards
        default:
            return nil
        }
        
        return vc
    }
    
}
