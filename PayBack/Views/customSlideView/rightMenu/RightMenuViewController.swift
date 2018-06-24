//
//  RightMenuViewController.swift
//  PayBack
//
//  Created by Dinakaran M on 31/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
class RightMenuViewController: BaseViewController {
    
    typealias UpdateLogoutStatusClosur = ((Bool) -> Void)
    var logoutStatus: UpdateLogoutStatusClosur = { _ in }
    var tempViewController: UIViewController?
    @discardableResult
    func updateLogOutStatus(status: @escaping UpdateLogoutStatusClosur) -> Self {
        self.logoutStatus = status
        return self
    }
    
    typealias UpdateLogInStatusClosur = ((Bool) -> Void)
    var logedInStatus: UpdateLogInStatusClosur = { _ in }
    @discardableResult
    func updateLogInStatus(status: @escaping UpdateLogInStatusClosur) -> Self {
        self.logedInStatus = status
        return self
    }
    
    typealias UpdateLoginSkipActionClosur = ((Bool) -> Void)
    var loginSkipStatus: UpdateLoginSkipActionClosur = { _ in }
    @discardableResult
    func updateLogInSkipActionStatus(status: @escaping UpdateLoginSkipActionClosur) -> Self {
        self.loginSkipStatus = status
        return self
    }
    
    @IBOutlet weak fileprivate var superViewTop: NSLayoutConstraint!
    @IBOutlet weak fileprivate var profilePoints: UILabel!
    @IBOutlet weak fileprivate var profileName: UILabel!
    @IBOutlet weak fileprivate var profileHeaderView: UIView!
    @IBOutlet weak fileprivate var profileImage: UIButton!
    @IBOutlet weak fileprivate var tableview: UITableView!
    @IBOutlet weak fileprivate var signoutButton: UIButton!
    
    @IBOutlet weak fileprivate var mainView: UIView!
    @IBOutlet weak fileprivate var mainViewTopConstraint: NSLayoutConstraint!
    
    fileprivate let cellIdentifier = "RightMenuCustomCell"
    fileprivate let cellRightMenuIdentifier = "rightMenuDivider"
    
    var sections = rightMenuSectionData {
        didSet {
            self.tableview.reloadData()
        }
    }
    let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
    let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
    let inStoreStoryboard = UIStoryboard(name: "InStore", bundle: nil)
    var signOutAuthenticator: SignOutAuthenticator!
    @IBAction func signOutAction(_ sender: Any) {
        self.tempViewController = nil
        if UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged) {
            print("SignOut Action")
            guard !isProfileEditing else {
                self.openAlertPopupForEditProfile()
                self.slideMenuController()?.closeRight()
                self.onAlertPopupForEditProfile { [weak self] in
                    if let topController = self?.slideMenuController()?.topViewController(), topController.className == "MyAccountVC" {
                        if let controller = topController as? MyAccountVC, controller.currentViewController?.className == "MyProfileViewController", let profileController = controller.currentViewController as? MyProfileViewController {
                            if profileController.editButton.title(for: .normal) == "SAVE CHANGES" {
                                isProfileEditing = true
                            }
                        }
                    }
                    self?.openAlertPopForLogOut()
                }
                return
            }
            self.openAlertPopForLogOut()
        } else {
            print("SignIn Action")
            self.signInAction()
        }
    }
    func signInAction(viewController: UIViewController? = nil) {
        self
            .onLoginSuccess { [weak self] in
                if let vc = viewController {
                    self?.tempViewController = vc
                }
                self?.setView()
                self?.slideMenuController()?.closeRight()
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
    
    private func openAlertPopForLogOut() {
        guard let window = UIApplication.shared.keyWindow, let popUpView = Bundle.main.loadNibNamed(alertPopUpID, owner: self, options: nil)?.first as? AlertPopUp else {
            return
        }
        
        popUpView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        window.addSubview(popUpView)
        let config = PopUpConfiguration()
            .set(hideConfirmButton: true)
            .set(hideOkButton: false)
            .set(okText: "YES")
            .set(hideCancelButton: false)
            .set(cancelText: "NO")
            .set(titleText: NSLocalizedString("Logout", comment: "Logout"))
            .set(desText: NSLocalizedString("Are you sure you want to logout?", comment: "logout confirmation"))
        
        popUpView.initWithConfiguration(configuration: config)
        popUpView.OkActionHandler = { [weak self] in
            print("ok clicked")
            popUpView.removeFromSuperview()
            self?.logOut()
            isProfileEditing = false
        }
        popUpView.cancelActionHandler = {
            print("Cancel clicked")
            popUpView.removeFromSuperview()
        }
    }
    func logOut() {
        signOutAuthenticator = SignOutAuthenticator()
        self.startActivityIndicator()
        self.signOutAuthenticator
            .onTokenExpired { [weak self] in
                self?.stopActivityIndicator()
                self?.updateUserLogoutState()
            }
            .onError(error: { [weak self] ( _ ) in
                self?.stopActivityIndicator()
                self?.updateUserLogoutState()
            })
            .onSuccess(success: { [weak self] ( _ ) in
                self?.stopActivityIndicator()
                self?.updateUserLogoutState()
            })
            .logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.profileHeaderView.backgroundColor = ColorConstant.rightMenuHeaderColorBlue
        self.profileName.textColor = ColorConstant.textColorWhite
        self.profileName.font = FontBook.Arial.of(size: 15.0)
        self.profilePoints.textColor = ColorConstant.textColorWhite
        self.profilePoints.font = FontBook.Bold.of(size: 15.0)
        self.signoutButton.titleLabel?.textColor = ColorConstant.textColorWhite
        self.signoutButton.backgroundColor = ColorConstant.buttonBackgroundColorPink
        self.signoutButton.titleLabel?.font = FontBook.Roboto.of(size: 11.0)
        self.mainView.backgroundColor = ColorConstant.leftRightMenuBgColor
        self.tableview.backgroundColor = ColorConstant.leftRightMenuBgColor
        if #available(iOS 11.0, *) {
            if DeviceType.IS_IPHONEX {
            self.mainViewTopConstraint.constant = 30
            }
        } else {
            self.mainViewTopConstraint.constant = 0
        }
    }
    deinit {
        print("RightMenuViewController: deinit called")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setView()
    }
    func setView() {
        self.updateLogedInUser()
        self.updateRightMenuStatus()
        self.updateSigInOutAction()
        self.tableview.reloadData()
    }
    func updateSigInOutAction() {
        if UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged) {
            self.signoutButton.setTitle("SIGN OUT", for: .normal)
        } else {
            self.signoutButton.setTitle("SIGN IN", for: .normal)
        }
    }
    func updateRightMenuStatus() {
        if #available(iOS 11, *) {} else {
            if (self.slideMenuController()?.isRightOpen())! {
                self.slideMenuController()?.openRight()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension RightMenuViewController {
    fileprivate func updateLogedInUser() {
        isUserLogedIn = UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged)
        if isUserLogedIn {
            let userDetails = UserProfileUtilities.getUserDetails()
            let firstName = userDetails?.FirstName
            let lastname = userDetails?.LastName
            if let points = userDetails?.TotalPoints {
                profilePoints.text = "\( points) \(StringConstant.pointsSymbol) "
                profilePoints.isHidden = false
            } else {
                profilePoints.text = ""
                profilePoints.isHidden = true
            }
            if let fname = firstName, let lname = lastname {
                profileName.text = "\(fname) \(lname)"
                let firstCharacter = "\(fname.first!)\(lname.first!)"
                self.configureProfileIcon(title: firstCharacter, borderColor: .white, borderWidth: 1)
            } else {
                profileName.text = ""
            }
            
        } else {
            profilePoints.text = ""
            profilePoints.isHidden = true
            profileName.text = "Welcome!"
            self.configureProfileIcon(image: #imageLiteral(resourceName: "profile_rmenu"))
        }
    }
    private func configureProfileIcon(title: String = "", image: UIImage? = nil, borderColor: UIColor = .clear, borderWidth: CGFloat = 0) {
        self.profileImage.isUserInteractionEnabled = false
        self.profileImage.setTitle(title, for: .normal)
        self.profileImage.setBackgroundImage(image, for: .normal)
        self.profileImage.setBackgroundImage(image, for: .highlighted)
        self.profileImage.setBackgroundImage(image, for: .selected)
        self.profileImage.layer.borderColor = borderColor.cgColor
        self.profileImage.layer.borderWidth = borderWidth
        self.profileImage.setTitleColor(.white, for: .normal)
        self.profileImage.setTitleColor(.white, for: .highlighted)
        self.profileImage.setTitleColor(.white, for: .selected)
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
    }
    
    fileprivate func updateUserLogoutState() {
        UserProfileUtilities.clearUserDetails()
        UserProfileUtilities.clearUserDefault()
        self.logoutStatus(true)
        self.closeRight()
        DispatchQueue.main.async {
            self.updateLogedInUser()
        }
        
        /*  Only Required page - Redirect into Home Screen after LogOut
         let topVC = self.slideMenuController()?.topViewController()
         let VCname = NSStringFromClass((topVC?.classForCoder)!)
         let className = VCname.components(separatedBy: ".")
         
         let objContain: Bool = rightMenuVC.contains(where: { $0 == className[1] })
         if objContain {
         self.slideMenuController()?.popToRootViewController(close: true)
         }*/
        // from all the controller redirecting into Home : PAYBMOB-276
        self.slideMenuController()?.popToRootViewController(close: true)
        DispatchQueue.main.async {
            self.parent?.stopActivityIndicator()
        }
    }
}
extension RightMenuViewController {
    //swiftlint:disable cyclomatic_complexity
    //swiftlint:disable function_body_length
    fileprivate func changeViewControllerSection(_ rightMenu: RightMenuSections) {
        guard !isProfileEditing else {
            self.openAlertPopupForEditProfile()
            self.slideMenuController()?.closeRight()
            self.onAlertPopupForEditProfile { [weak self] in
                self?.changeViewControllerSection(rightMenu)
            }
            return
        }
        let isUserLogedInStatus = UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged)
        switch rightMenu {
        case .myAccount:
            guard let myAccountVC = profileStoryboard.instantiateViewController(withIdentifier: "MyAccountVC") as? MyAccountVC else {
                return
            }
            if isUserLogedInStatus {
                self.slideMenuController()?.changeMainViewController(myAccountVC, close: true)
            } else {
                self.signInAction(viewController: myAccountVC)
            }
        case .myTransactions:
            let myTransactionVC = profileStoryboard.instantiateViewController(withIdentifier: "MyTransactionsVC") as? MyTransactionsVC
            if isUserLogedInStatus {
                self.slideMenuController()?.changeMainViewController(myTransactionVC!, close: true)
            } else {
                self.signInAction(viewController: myTransactionVC)
            }
        case .myOrders:
            let myOrdersVC = profileStoryboard.instantiateViewController(withIdentifier: "MyOrdersVC") as? MyOrdersVC
            if isUserLogedInStatus {
                self.slideMenuController()?.changeMainViewController(myOrdersVC!, close: true)
            } else {
                self.signInAction(viewController: myOrdersVC)
            }
        case .myWishlist:
            let myWishListVC = profileStoryboard.instantiateViewController(withIdentifier: "MyWhishlistVC") as? MyWhishlistVC
            
            if isUserLogedInStatus {
                self.slideMenuController()?.changeMainViewController(myWishListVC!, close: true)
            } else {
                self.signInAction(viewController: myWishListVC)
            }
        case .upgradetoPayBackPlus:
            let upgradetoPaybackVC = profileStoryboard.instantiateViewController(withIdentifier: "UpGradePayBackPlusVC") as? UpGradePayBackPlusVC
            if isUserLogedInStatus {
                self.slideMenuController()?.changeMainViewController(upgradetoPaybackVC!, close: true)
            } else {
                self.signInAction(viewController: upgradetoPaybackVC)
            }
        case .notification:
            let notificationVC = profileStoryboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
            if isUserLogedInStatus {
                self.slideMenuController()?.changeMainViewController(notificationVC!, close: true)
            } else {
                self.signInAction(viewController: notificationVC)
            }
        case .storeLocator:
            let inStorePartnersVC = inStoreStoryboard.instantiateViewController(withIdentifier: "InStorePartnersVC") as? InStorePartnersVC
            inStorePartnersVC?.defaultSelectedIndex = 0
            self.slideMenuController()?.changeMainViewController(inStorePartnersVC!, close: true)
        case .referaFriend:
            let referFriendController = profileStoryboard.instantiateViewController(withIdentifier: "PBReferViewController") as? PBReferViewController
            self.slideMenuController()?.changeMainViewController(referFriendController!, close: true)
        case .reteUs:
            let rateUSVC = profileStoryboard.instantiateViewController(withIdentifier: "RateUsVC") as? RateUsVC
            self.slideMenuController()?.changeMainViewController(rateUSVC!, close: true)
        case .helpCentre:
            let helpCentreVC = profileStoryboard.instantiateViewController(withIdentifier: "PBHelpCentreViewController") as? PBHelpCentreViewController
            self.slideMenuController()?.changeMainViewController(helpCentreVC!, close: true)
        case .policies:
            let policesVC = profileStoryboard.instantiateViewController(withIdentifier: "PoliciesVC") as? PoliciesVC
            policesVC?.type = .policies
            self.slideMenuController()?.changeMainViewController(policesVC!, close: true)
        case .termsAndConditions:
            let terms = profileStoryboard.instantiateViewController(withIdentifier: "PoliciesVC") as? PoliciesVC
            terms?.type = .termsAndConditions
            self.slideMenuController()?.changeMainViewController(terms!, close: true)
        case .none:
            break
        }
    }
    //swiftlint:enable cyclomatic_complexity
    //swiftlint:enable function_body_length
}

extension RightMenuViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  sections[section].items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RightMenuCustomCell
        cell?.cellModel = sections[indexPath.section].items[indexPath.row]
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DeviceType.IS_IPAD ? 55 : 44.0 //UITableViewAutomaticDimension
    }
}

extension RightMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectinRowAtIndexMenu = sections[indexPath.section].items[indexPath.row].itemId
        self.changeViewControllerSection(RightMenuSections(rawValue: sectinRowAtIndexMenu!)!)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 0 else {
            return UIView()
        }
        let headerDivider = tableView.dequeueReusableHeaderFooterView(withIdentifier: cellRightMenuIdentifier) as? RightMenuTableviewHeader ?? RightMenuTableviewHeader(reuseIdentifier: cellRightMenuIdentifier)
        return headerDivider
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 30.0
        }
    }
}
