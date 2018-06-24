//
//  AppDelegate.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/22/17.
//  Copyright © 2017 Valtech. All rights reserved.
//
import GoogleMaps
import GooglePlaces
import UIKit
import Pushwoosh
import UserNotifications
import FBSDKCoreKit
import FacebookCore
import GoogleMobileAds
import Firebase

// TODO: Replace Facebook App Id in info.plist. Also add final bundle identifier in the facebook dashboard under setting.
// TODO: replace GoogleService-info.plist with client account plist

var APP_DEL = UIApplication.shared.delegate as? AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    fileprivate let memberDashBoardNWController = MemberDashBoardNWController()
    
    func createMain_Left_Right_MenuView() {
        // create viewController code...
        let rootController = Utilities.rootViewController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
 
        self.window?.backgroundColor = UIColor(red: 236.0 / 255, green: 238.0 / 255, blue: 241.0 / 255, alpha: 1.0)
        self.window?.rootViewController = rootController
        self.window?.makeKeyAndVisible()
        
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        LocationManager.sharedLocationManager.initializeLocationManager()
        ReachabilityManager.shared.startMonitoring()

        // Override point for customization after application launch.
        self.createMain_Left_Right_MenuView()
        self.enablePushwoosh()
        // Google Map - And Need To Register Bundle Identifier in Google Console
        GMSServices.provideAPIKey(providerAPIKey)
        GMSPlacesClient.provideAPIKey(providerAPIKey)
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3940256099942544~1458002511")

        if UserProfileUtilities.getBoolValueFromUserDefaultsForKey(forKey: kIsUserLoged) {
            self.memberDashBoardDataUpdate()
        }
       
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
        Fabric.sharedSDK().debug = true
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
        FBSDKAppEvents.activateApp()
        AppEventsLogger.activate()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        ReachabilityManager.shared.stopMonitoring()
    }
    
}
// MARK: Push Notification
extension AppDelegate: PushNotificationDelegate {
    fileprivate func enablePushwoosh() {
        //set custom delegate for push handling, in our case AppDelegate
        PushNotificationManager.push().delegate = self
        
        //set default Pushwoosh delegate for iOS10 foreground push handling
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = PushNotificationManager.push().notificationCenterDelegate
        }
        // track application open statistics
        PushNotificationManager.push().sendAppOpen()
        
        // register for push notifications!
        PushNotificationManager.push().registerForPushNotifications()
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushNotificationManager.push().handlePushRegistration(deviceToken as Data?)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        PushNotificationManager.push().handlePushRegistrationFailure(error)
    }
    func onDidRegisterForRemoteNotifications(withDeviceToken token: String!) {
        print("Pushwoosh Device Token : \(token)")
    }
    func onDidFailToRegisterForRemoteNotificationsWithError(_ error: Error!) {
        print("Pushwoosh Did Failed to register : \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if #available(iOS 10.0, *) {
            completionHandler(UIBackgroundFetchResult.noData)
        } else {
            PushNotificationManager.push().handlePushReceived(userInfo)
            completionHandler(UIBackgroundFetchResult.noData)
        }
    }
    //this event is fired when the push gets received
    func onPushReceived(_ pushManager: PushNotificationManager!, withNotification pushNotification: [AnyHashable : Any]!, onStart: Bool) {
        print("Push notification received: \(pushNotification)")
        // shows a push is received. Implement passive reaction to a push here, such as UI update or data download.
    }
    //this event is fired when user taps the notification
    func onPushAccepted(_ pushManager: PushNotificationManager!, withNotification pushNotification: [AnyHashable : Any]!, onStart: Bool) {
        print("Push notification accepted: \(pushNotification)")
        // shows a user tapped the notification. Implement user interaction, such as showing push details
        if let toModule = pushNotification["to"] as? String {
            print("\(toModule)")
            self.pushVC(toModule: toModule)
        }
    }
    // PushNavigation Action Implementation
    fileprivate func pushVC(toModule module: String) {
        var controller: BaseViewController!
        switch module {
        case "Home":
            controller = ExtendedHomeVC.storyboardInstance(storyBoardName: "Main") as? ExtendedHomeVC
        case "Earn":
            controller = EarnLandingVC.storyboardInstance(storyBoardName: "Earn") as? EarnLandingVC
        case "Burn":
            controller = BurnLandingVC.storyboardInstance(storyBoardName: "Burn") as? BurnLandingVC
        case "OfferLanding":
            controller = OfferLandingVC.storyboardInstance(storyBoardName: "OfferZone") as? OfferLandingVC
        case "ProductList":
            controller = ProductListVC.storyboardInstance(storyBoardName: "Burn") as? ProductListVC
        case "OnlineOffers":
            let onlineOfferController = OnlineOffersVC.storyboardInstance(storyBoardName: "OfferZone") as? OnlineOffersVC
            onlineOfferController?.categoryType = .onlineOffer
            controller = onlineOfferController
        default:
            break
        }
        guard let rootVC = APP_DEL?.window?.rootViewController as? SlideMenuController, let rootNVC = rootVC.mainViewController  else {
            print("not found")
            return
        }
       
        if let topVC = rootNVC.topViewController, topVC.className == controller.className {
            rootNVC.popViewController(animated: false)
        }
//        else
//            if let existedVC = rootNVC.getPreviousViewController(of: controller.className), existedVC.className == controller.className {
//            rootNVC.popToRootViewController(animated: false)
//        }
        rootNVC.pushViewController(controller!, animated: false)
    }
    
    fileprivate func memberDashBoardDataUpdate() {
        self.memberDashBoardNWController
            .getMemberDetails()
    }
}
