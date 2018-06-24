//
//  PBBaseViewController.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/22/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
import ReachabilitySwift
import MapKit
import Contacts

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    var loginSuccess: () -> Void = { }
    var loginError: (String) -> Void = { _ in }
    var isUserLogedIn: Bool = false
    var cartActionStatus: Bool = false
    var redirectUrl: String?
    var partnerlogoUrl: String?
    private var destinationPoints: GoogleDirection?
    
    var AlertPopupForEditProfileClosure: () -> Void = {  }

    var profileView: CustomNavigationBarItems!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @objc  func willEnterForeground() { }
    
    func userLogedOutforcefully() {
        UserProfileUtilities.clearUserDetails()
        UserProfileUtilities.clearUserDefault()
        self.updateUserProfile()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUserProfile()
    }
    fileprivate func updateUserProfile() {
        isUserLogedIn = UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged)
        setupLogedInUserNavigationBarItems()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    internal func setupLogedInUserNavigationBarItems() {
       leftBarButtonItems()
       rightBarButtonItems()
    }
    fileprivate func leftBarButtonItems() {
        
        let leftMenu = leftMenuIcon()
        let logoBarItem = homeLogo()
        
        navigationItem.leftBarButtonItems = [leftMenu, logoBarItem]
    }
    
    fileprivate func rightBarButtonItems() {
        let profile: UIBarButtonItem = profileButton()
        let search: UIBarButtonItem = searchButton()
        //let wish: UIBarButtonItem = cartButton()
        if isUserLogedIn {
             let userPro: UIBarButtonItem = userProfile()
             navigationItem.rightBarButtonItems = [userPro, profile, search]//, wish]
        } else {
            navigationItem.rightBarButtonItems = [profile, search]//, wish]
        }
    }
    // signinPOPUp Loged In Status
    func userLogedIn(status: Bool) {
        print("User LogedIn Status")
        
    }
    fileprivate func userLogedInForWishList(status: Bool) {
        if status && self.cartActionStatus {
            self.wishList()
            self.cartActionStatus = false
        }
    }
   
    fileprivate func logedInSuccessStatusUpdate(isUserLogedIn: Bool) {
        self.isUserLogedIn = UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged)
        //self.getMemberDetails(isLoader: true)
        DispatchQueue.main.async {
            self.setupLogedInUserNavigationBarItems()
            if self.cartActionStatus {
                self.userLogedInForWishList(status: isUserLogedIn)
            } else {
                self.userLogedIn(status: isUserLogedIn)
            }
        }
    }
    func connectionSuccess() {
        print("net connection successfull")
    }
}

extension BaseViewController {
    
    fileprivate func leftMenuIcon() -> UIBarButtonItem {
        let image = UIImage(named: "hamburgericon") ?? UIImage()
        let leftMenuBtn = UIButton(type: .custom)
        leftMenuBtn.setImage(image, for: .normal)
        leftMenuBtn.frame.size = image.size
        leftMenuBtn.frame.size.width = 30
        leftMenuBtn.frame.size.height = 40
        leftMenuBtn.addTarget(self, action: #selector(self.toggleLeft), for: .touchUpInside)
        leftMenuBtn.backgroundColor = UIColor.clear
        return UIBarButtonItem(customView: leftMenuBtn)
    }
    
    fileprivate func homeLogo() -> UIBarButtonItem {
        let screenSize = UIScreen.main.bounds
        
        let Logo = UINib(nibName: "CustomNavigationBarItems", bundle: nil).instantiate(withOwner: nil, options: nil)[2] as? HomeLogo
       
        Logo?.frame.size = screenSize.width == 320 ? CGSize(width: 60, height: 30) : CGSize(width: 90, height: 30)
        Logo?
            .update(widthconstraints: screenSize.width == 320 ? 60 : 90)
            .set(homeLogo: UIImage(named: "paybacklogo")!)
                
        Logo?.logoTapClosure = { [weak self] in
            if isProfileEditing {
                self?.openAlertPopupForEditProfile()
                self?.onAlertPopupForEditProfile(success: { [weak self] in
                    self?.logoAction()
                })
                return
            }
            self?.logoAction()
        }
        return UIBarButtonItem(customView: Logo!)
    }
    
    fileprivate func userProfile() -> UIBarButtonItem {
        let userProfile = UINib(nibName: "CustomNavigationBarItems", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as? UserProfileBarItems
        let userDetails = UserProfileUtilities.getUserDetails()
        let firstName = userDetails?.FirstName
        let lastname = userDetails?.LastName
        let points = userDetails?.TotalPoints
        if let Fname = firstName, let Lname = lastname {
            userProfile?.update(username: "\(Fname) \(Lname)")
            profileView.update(profileIconText: "\(Fname.first!)\(Lname.first!)")
        }
        if let point = points {
            userProfile?
                .update(userPoints: "\(point) \(StringConstant.pointsSymbol)")
        }
        if UIDevice.current.iPhones_5series_SE || UIDevice.current.iphone_4series {
            userProfile?.frame.size.width = DeviceType.IS_IPAD ? 120 : 60
            userProfile?.frame.size.height = 30
        } else {
            userProfile?.frame.size.width = DeviceType.IS_IPAD ? 120 : 60
            userProfile?.frame.size.height = 30
        }
        //userProfile?.backgroundColor = UIColor.green
        userProfile?.userProfileTapClosure = { [weak self] in
            print("User Profile clicked")
            self?.toggleRight()
            self?.slideMenuController()?.userlogOutStatus(status: { [weak self] (isUserLogout) in
                if isUserLogout {
                    DispatchQueue.main.async {
                        self?.isUserLogedIn = UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged)
                        self?.userLogedIn(status: false)
                        self?.setupLogedInUserNavigationBarItems()
                    }
                }
            })
        }
        return UIBarButtonItem(customView: (userProfile)!)
    }
    
    fileprivate func profileButton() -> UIBarButtonItem {
        profileView = UINib(nibName: "CustomNavigationBarItems", bundle: nil).instantiate(withOwner: nil, options: nil).first as? CustomNavigationBarItems
        let image = UIImage(named: "profileicon") ?? UIImage()
        profileView?
            .display(isDeviderDisplay: false)
            .set(notificationText: "333")
            .display(isNotificationDisplay: true)
            .set(centerXConstraints:  10.0)
            .set(profileIconImage: image)
            .set(buttonTag: 100)
        if UIDevice.current.iPhones_5series_SE || UIDevice.current.iphone_4series {
            profileView?.frame.size.width = 35
            profileView?.frame.size.height = 20
        } else {
            profileView?.frame.size.width = 45
            profileView?.frame.size.height = 30
        }
        profileView?.backgroundColor = UIColor.clear
        
        profileView?.userProfileTapClosure = { [weak self] in
            self?.profileIconAction()
        }
        return UIBarButtonItem(customView: profileView!)
    }
    
    fileprivate func searchButton() -> UIBarButtonItem {
        let searchButton = UINib(nibName: "CustomNavigationBarItems", bundle: nil).instantiate(withOwner: nil, options: nil).first as? CustomNavigationBarItems
        
        searchButton?
            .display(isDeviderDisplay: true)
            .display(isNotificationDisplay: true)
            .set(centerXConstraints:  10.0)
            .set(profileIconImage: UIImage(named: "searchicon")!)
            .set(buttonTag: 101)
        if UIDevice.current.iPhones_5series_SE || UIDevice.current.iphone_4series {
            searchButton?.frame.size.width = 35
            searchButton?.frame.size.height = 20
        } else {
            searchButton?.frame.size.width = 45
            searchButton?.frame.size.height = 30
        }
      
        searchButton?.searchTapClosure = { [weak self] in
            if isProfileEditing {
                self?.openAlertPopupForEditProfile()
                self?.onAlertPopupForEditProfile(success: { [weak self] in
                    self?.searchAction()
                })
                return
            }
            self?.searchAction()
        }
        searchButton?.backgroundColor = UIColor.clear
        return UIBarButtonItem(customView: searchButton!)
    }
    
    fileprivate func cartButton() -> UIBarButtonItem {
        let wishlistView = UINib(nibName: "CustomNavigationBarItems", bundle: nil).instantiate(withOwner: nil, options: nil).first as? CustomNavigationBarItems
        
        wishlistView?
            .display(isDeviderDisplay: true)
            .display(isNotificationDisplay: true)
            .set(notificationText: "44")
            .set(centerXConstraints: 10.0)
            .set(profileIconImage: UIImage(named: "shoppingcart")!)
            .set(buttonTag: 102)
        if UIDevice.current.iPhones_5series_SE || UIDevice.current.iphone_4series {
            wishlistView?.frame.size.width = 35
            wishlistView?.frame.size.height = 20
        } else {
            wishlistView?.frame.size.width = 45
            wishlistView?.frame.size.height = 30
        }
        wishlistView?.backgroundColor = UIColor.clear
        
        wishlistView?.cartTapClosure = { [weak self] in
            if UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged) {
                self?.wishList()
            } else {
                self?.signInPopUp()
                self?.cartActionStatus = true
            }
        }
        return UIBarButtonItem(customView: wishlistView!)
    }
}

extension BaseViewController {
    fileprivate func logoAction() {
        self.slideMenuController()?.popToRootViewController(close: true)
    }
    fileprivate func searchAction() {
        let topVC = self.navigationController?.topViewController
        if topVC is SearchVC {
            print("already in Presented")
        } else {
            let isExist = self.getPreviousViewController(of: "SearchVC")
            isExist?.removeFromParentViewController()
            
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let searchVC = mainStoryBoard.instantiateViewController(withIdentifier: "SearchVC") as? SearchVC
            self.navigationController?.pushViewController(searchVC!, animated: true)
        }
    }
    fileprivate func wishList() {
        let topVC = self.navigationController?.topViewController
        if topVC is MyCartVC {
            print("already in Presented")
        } else if let controller = self.getPreviousViewController(of: "MyCartVC") {
            self.navigationController?.popToViewController(controller, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MyCartVC") as? MyCartVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    fileprivate func profileIconAction() {
            self.toggleRight()
    }
    func signInPopUp() {
        guard let signInVC = SignInVC.storyboardInstance(storyBoardName: "SignIn") as? SignInVC else {
            return
        }
        signInVC.updateLogedInStatus(status: { [weak self] (isUserLogedIn) in
            if isUserLogedIn {
                 self?.logedInSuccessStatusUpdate(isUserLogedIn: isUserLogedIn)
                self?.loginSuccess()
            } else {
                self?.loginError("")
            }
        })
        signInVC.updatePopToRootVC(closure: { [weak self] (status) in
            if status {
                self?.cartActionStatus = false
                self?.userLogedOutforcefully()
                self?.popToRootViewController()
                self?.userLogedIn(status: false)
            }
        })
        signInVC.modalPresentationCapturesStatusBarAppearance = true
        self.present(signInVC, animated: true, completion: nil)
    }
    func popToRootViewController() {
        self.closeRight()
        self.closeLeft()
        // Only Required page - Redirect into Home Screen after LogOut
        if let topVC = self.slideMenuController()?.topViewController() {
            let VCname = NSStringFromClass(topVC.classForCoder)
            let className = VCname.components(separatedBy: ".")
            
            let objContain: Bool = rightMenuVC.contains(where: { $0 == className[1] })
            if objContain {
                self.slideMenuController()?.popToRootViewController(close: true)
            }
        }
        //self.slideMenuController()?.popToRootViewController(close: true)
    }
}
extension BaseViewController {
    @discardableResult
    func onLoginSuccess(success: @escaping () -> Void) -> Self {
        self.loginSuccess = success
        return self
    }
    @discardableResult
    func onLoginError(error: @escaping (String) -> Void) -> Self {
        self.loginError = error
        return self
    }
    @discardableResult
    func onAlertPopupForEditProfile(success: @escaping () -> Void) -> Self {
        self.AlertPopupForEditProfileClosure = success
        return self
    }
}
// MARK: Error View
extension BaseViewController {
    // connection error check
    func isNetworkAvailable() -> Bool {
        if let isReachable = Reachability()?.isReachable, isReachable == true {
            return isReachable
        }
        return false
    }
    func checkConnection(withErrorViewYPosition position: CGFloat = 64) -> Bool {
        if let isReachable = Reachability()?.isReachable, isReachable == true {
            return isReachable
        }
        openConnectionErrorVC(position: position)
        return (Reachability()?.isReachable)!
    }
    func openConnectionErrorVC(position: CGFloat) {
        //if !self.checkConnection() {
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self, let connectionView = Bundle.main.loadNibNamed("ConnectionErrorView", owner: strongSelf, options: nil)?.first as? ConnectionErrorView {
                    if #available(iOS 11.0, *) {
                        connectionView.frame = CGRect(x: 0, y: 0, width: strongSelf.view.frame.width, height: strongSelf.view.frame.height)
                    } else {
                        connectionView.frame = CGRect(x: 0, y: position, width: strongSelf.view.frame.width, height: strongSelf.view.frame.height)
                    }
                    strongSelf.view.addSubview(connectionView)
                    connectionView.connectionSuccess = { [weak self] in
                        self?.connectionSuccess()
                        connectionView.removeFromSuperview()
                    }
                }
            }
       // }
    }
    
    func openErrorView(withMessage message: String) {
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self, let connectionView = Bundle.main.loadNibNamed("ConnectionErrorView", owner: strongSelf, options: nil)?.first as? ConnectionErrorView {
                if #available(iOS 11.0, *) {
                    connectionView.frame = CGRect(x: 0, y: 0, width: strongSelf.view.frame.width, height: strongSelf.view.frame.height)
                } else {
                    connectionView.frame = CGRect(x: 0, y: 64, width: strongSelf.view.frame.width, height: strongSelf.view.frame.height)
                }
                connectionView.setDetail(detail: message)
                strongSelf.view.addSubview(connectionView)
                connectionView.connectionSuccess = { [weak self] in
                    self?.connectionSuccess()
                    connectionView.removeFromSuperview()
                }
            }
        }
    }
}
// Redirection ViewController
extension BaseViewController {
    func redirectVC(redirectLink: String, redirectLogoUrl: String? = "") {
        let redirectLink = redirectLink.trimmingCharacters(in: .whitespacesAndNewlines)
        guard redirectLink != "" else {
            return
        }
        if UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged) {
            if let vc = RedirectionVC.storyboardInstance(storyBoardName: "Main") as? RedirectionVC {
                vc.redirectUrl = Utilities.getTheRedirectURLwithLCN(urlStrint: redirectLink)
                vc.partnerlogoUrl = redirectLogoUrl
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            self.redirectUrl = redirectLink
            self.partnerlogoUrl = redirectLogoUrl
            self.signInPopUp()
        }
    }
}
extension BaseViewController {
     func openMap(_ storeLocations: [Location], sender: Any) {
        guard let location = storeLocations.first else {
            return
        }
        
        guard let lat = location.latitude, let latitude = Double(lat), let long = location.longitude, let longitude = Double(long) else {
            return
        }
        let destination = CLLocation(latitude: latitude, longitude: longitude)
        
        let dataProvider = GoogleDataProvider()
        guard let currentLoc = LocationManager.sharedLocationManager.currectUserLocation else {
            return
        }
        dataProvider.fetchDirection(startLocation: currentLoc, endLocation: destination) { [weak self] (directionPoints) in
            if self?.destinationPoints != nil {
                self?.destinationPoints = nil
            }
            self?.destinationPoints = directionPoints
            
            DispatchQueue.main.async {[weak self] in
                self?.showPopover(currentLocation: currentLoc, selectedLocation: destination, sender: sender)
            }
        }
    }
    
    func showPopover(currentLocation: CLLocation, selectedLocation: CLLocation, sender: Any) {
        let alertController = UIAlertController(title: "Start Navigation", message: "Please chose any one?", preferredStyle: .actionSheet)
        
        let gooleMapAction = UIAlertAction(title: "Google map", style: .default, handler: { _ in
            //            if let direction = self.destinationPoints {
            let sourceLatitude = currentLocation.coordinate.latitude //(direction.startLocation_lat)!
            let sourceLogtitude = currentLocation.coordinate.longitude //(direction.startLocation_lng)!
            let latitude = selectedLocation.coordinate.latitude //(direction.endLocation_lat)!
            let longitude = selectedLocation.coordinate.longitude//(direction.endLocation_lng)!
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string:
                        "comgooglemaps://?saddr=\(sourceLatitude),\(sourceLogtitude)&daddr=\(latitude),\(longitude)&directionsmode=driving")! as URL)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(URL(string: "comgooglemaps://?saddr=\(sourceLatitude),\(sourceLogtitude)&daddr=\(latitude),\(longitude)&directionsmode=driving")!)
                }
                self.destinationPoints = nil
            } else {
                // Can't use com.google.maps://
                let alertMessage = UIAlertController(title: "Google Map Unavailable", message: "Please Install from AppStore", preferredStyle: .alert)
                alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertMessage, animated: true, completion: nil)
            }
            //}
        })
        alertController.addAction(gooleMapAction)
        
        let appleMap = UIAlertAction(title: "Apple Map", style: .default, handler: { _ in
            if let direction = self.destinationPoints {
                let sourceCoordinate = CLLocationCoordinate2DMake(Double(currentLocation.coordinate.latitude), Double(currentLocation.coordinate.longitude))
                let sourceAddress = [String(describing: CNPostalAddress()): (direction.startAddress)!]
                let mapItem1 = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinate, addressDictionary:sourceAddress))
                
                let destinationCoordinate = CLLocationCoordinate2DMake(Double(selectedLocation.coordinate.latitude), Double(selectedLocation.coordinate.longitude))
                let destinationAddress = [String(describing: CNPostalAddress()): (direction.endAddress)!]
                
                let mapItem2 = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: destinationAddress))
                
                let mapItem = [mapItem1, mapItem2]
                let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                MKMapItem.openMaps(with: mapItem, launchOptions: options)
                self.destinationPoints = nil
            }
        })
        alertController.addAction(appleMap)
        
        let defaultAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = sender as? UIView
            presenter.sourceRect = CGRect(x: (sender as AnyObject).bounds.midX, y: (sender as AnyObject).bounds.midY, width: 0, height: 0)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
extension BaseViewController {
     func openAlertPopupForEditProfile() {
        guard let window = UIApplication.shared.keyWindow, let popUpView = Bundle.main.loadNibNamed(alertPopUpID, owner: self, options: nil)?.first as? AlertPopUp else {
            return
        }
        
        popUpView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        window.addSubview(popUpView)
        let config = PopUpConfiguration()
            .set(hideConfirmButton: true)
            .set(hideOkButton: false)
            .set(okText: "Save")
            .set(hideCancelButton: false)
            .set(titleText: NSLocalizedString(StringConstant.editProfileAlertTitle, comment: StringConstant.editProfileAlertTitle))
            .set(desText: NSLocalizedString(StringConstant.editProfileAlertDesc, comment: StringConstant.editProfileAlertDesc))
        
        popUpView.initWithConfiguration(configuration: config)
        popUpView.OkActionHandler = { [weak self] in
            print("ok clicked")
            popUpView.removeFromSuperview()
            if let topController = self?.slideMenuController()?.topViewController(), topController.className == "MyAccountVC" {
                if let controller = topController as? MyAccountVC, controller.currentViewController?.className == "MyProfileViewController", let profileController = controller.currentViewController as? MyProfileViewController {
                    self?.slideMenuController()?.closeLeft()
                    profileController.updateMemberDetails()
                    profileController.editProfileSavePopupActionClosure = { (status) in
                        isProfileEditing = false
                        self?.AlertPopupForEditProfileClosure()
                    }
                }
            }
        }
        popUpView.cancelActionHandler = {[weak self] in
            print("Cancel clicked")
            popUpView.removeFromSuperview()
            isProfileEditing = false
            self?.AlertPopupForEditProfileClosure()
        }
    }
}
extension ExtendedHomeVC : SlideMenuControllerDelegate {
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
