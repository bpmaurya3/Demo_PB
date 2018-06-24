//
//  InStorePartnersVC.swift
//  PayBack
//
//  Created by Dinakaran M on 05/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
import MapKit

class InStorePartnersVC: BaseViewController {
    enum TabIndex: Int {
        case MapVC = 0
        case ListVC = 1
    }
    
    var defaultSelectedIndex = 1
    var currentViewController: UIViewController?
    
    lazy var viewModel: InStoreListVM = {
        let fetcher = InStoreListFetcher()
        let vm = InStoreListVM(withFetcher: fetcher)
        return vm
    }()
    
    lazy var ListTabVC: UIViewController? = {
        guard let listVC = self.storyboard?.instantiateViewController(withIdentifier: "StoreLocatorListViewController") as? StoreLocatorListVC else {
            return nil
        }
        listVC.viewModel = viewModel
        return listVC
    }()
    lazy var MapTabVC: UIViewController? = {
        guard let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "StoreLocatorMapViewController") as? StoreLocatorMapVC else {
            return nil
        }
        mapVC.viewModel = viewModel
        return mapVC
    }()
    
    var sourceData : [Any] = []
    @IBOutlet weak private var segmentControl: UISegmentedControl!
    @IBOutlet weak private var inStoreDataView: UIView!
    @IBOutlet weak private var inStoreContainerView: UIView!
    @IBOutlet weak private var errorView: UIView!
    @IBOutlet weak private var navView: DesignableNav!

    @IBOutlet weak private var enableLocationButton: UIButton!
    @IBOutlet weak private var errorviewsubtext: UILabel!
    @IBOutlet weak private var errorviewsubmsg: UILabel!
    @IBOutlet weak private var oopslabel: UILabel!
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        print("Selected Index \(sender.selectedSegmentIndex)")
        displayCurrentTab(sender.selectedSegmentIndex)
        defaultSelectedIndex = sender.selectedSegmentIndex
    }
    @IBAction func enableLocationButtonAction(_ sender: UIButton) {
        LocationManager.sharedLocationManager.openLocationSetting()
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oopslabel.textColor = ColorConstant.textColorBlack
        self.errorviewsubtext.textColor = ColorConstant.textColorGray
        self.errorviewsubmsg.textColor = ColorConstant.textColorGray
        self.segmentControl.backgroundColor = ColorConstant.backgroudColorWhite
        self.segmentControl.tintColor = ColorConstant.primaryColorPink
         NotificationCenter.default.addObserver(self, selector: #selector(appViewSetUp), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appViewSetUp()
    }
    
    @objc private  func appViewSetUp() {
        setupView()
        LocationManager.sharedLocationManager.initializeLocationManager()
        if LocationManager.sharedLocationManager.isLocationEnabled {
            enableLocationButton.isHidden = true
        } else {
            enableLocationButton.isHidden = false
            segmentControl.isHidden = true
            if let vc = viewControllerForSelectedSegmentIndex(defaultSelectedIndex) {
                remove(asChildViewController: vc)
            }
        }
    }
    private func setupView() {
        sourceData.append("Data1")
        if sourceData.isEmpty {
            segmentControl.isHidden = true
            errorView.isHidden = false
            inStoreContainerView.isHidden = true
            navView.title = NSLocalizedString("STORE LOCATOR", comment: "STORE LOCATOR")
        } else {
            errorView.isHidden = true
            segmentControl.isHidden = false
            inStoreContainerView.isHidden = false
            navView.title = NSLocalizedString("STORE LOCATOR", comment: "STORE LOCATOR")
        }
//        navView.backButton.isHidden = true
        self.segmentControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: UIControlState.selected)
        self.segmentControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: UIControlState.normal)
        self.segmentControl.removeBorders()
        self.segmentControl.selectedSegmentIndex = defaultSelectedIndex
        displayCurrentTab(defaultSelectedIndex)
    }
    private func displayCurrentTab(_ tabIndex: Int) {
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            vc.view.frame = self.inStoreContainerView.bounds
            self.inStoreContainerView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    private func remove(asChildViewController viewController: UIViewController?) {
        guard let vc = viewController else {
            return
        }
        // Notify Child View Controller
        vc.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        vc.view.removeFromSuperview()
        
        // Notify Child View Controller
        vc.removeFromParentViewController()
    }
    
    private func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.MapVC.rawValue :
            remove(asChildViewController: ListTabVC)
            vc = MapTabVC
        case TabIndex.ListVC.rawValue :
            remove(asChildViewController: MapTabVC)
            vc = ListTabVC
        default:
            return nil
        }
        return vc
    }
  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Deinit - InStorePartnersVC")
    }
}
