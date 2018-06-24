//
//  PBOnBoardController.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/22/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class OnBoardVC: UIViewController {
    @IBOutlet weak private var carousel: PBCarousel!
    @IBOutlet weak private var skupBut: UIButton!
    
    //swiftlint:disable redundant_optional_initialization
    var timer: Timer? = nil
    //swiftlint:enable redundant_optional_initialization
    
    fileprivate lazy var onboardFetcher: CarouselFetcher = {
        return CarouselFetcher()
    }()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.skupBut.isHidden = true
        setupCarousel()
        if BaseViewController().checkConnection() {
            fetchOnboardData()
        } else {
            self.setupErrorView(detail: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        carousel = nil
        print("PBOnboarding deinit called")
    }
    
    // MARK: Helper Func
    
    private func setupNavigation() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupErrorView(detail: String?) {
        let connectionView = Bundle.main.loadNibNamed("ConnectionErrorView", owner: self, options: nil)?.first as? ConnectionErrorView
        connectionView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        if let detail = detail {
            connectionView?.setDetail(detail: detail)
        }
        self.view.addSubview(connectionView!)
        connectionView?.connectionSuccess = { [weak self] in
            connectionView?.removeFromSuperview()
            self?.fetchOnboardData()
        }
    }
    private func fetchOnboardData() {
        self.startActivityIndicator()
        onboardFetcher
            .onSuccess { [weak self] (onboardData, isExpired) in
                self?.stopActivityIndicator()
                // TBD isExpired scenario handled
                if isExpired {
                    self?.skipAction(isExpired)
                } else {
                    self?.carousel.slides = onboardData
                }
            }
            .onError { [weak self] (error) in
                self?.stopActivityIndicator()
                print("\(error)")
                self?.setupErrorView(detail: StringConstant.timeOutMessage)
            }
            .fetchOnboard()
    }
    
    private func setupCarousel() {
        
        let configuration = PBCarouselConfiguration()
            .set(collectionViewBounce: true)
            .set(collectionViewCellName: .tutorialCarousel)
        
        carousel.confugure(withConfiguration: configuration)
        
        self.carousel.lastIndex = { [weak self] (index) in
            if let strongSelf = self, index == strongSelf.carousel.slides.count - 1 {
                strongSelf.setupTimer()
            }
        }
    }
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(skipAction(_:)), userInfo: nil, repeats: false)
    }
    
    // MARK: Actions
    
    @IBAction func skipAction(_ sender: Any) {
       // self.setHomeViewController()
        guard let signInVC = SignInVC.storyboardInstance(storyBoardName: "SignIn") as? SignInVC else {
            return
        }
        signInVC.updateLogedInStatus(status: { [weak self] (isUserLogedIn) in
            if isUserLogedIn {
               self?.setHomeViewController()
            }
        })
        signInVC.updatePopToRootVC(closure: { [weak self] (status) in
            if status {
                self?.setHomeViewController()
            }
        })
        signInVC.modalPresentationCapturesStatusBarAppearance = true
        self.present(signInVC, animated: true, completion: nil)
    }
    
    func setHomeViewController() {
        let homeViewController = ExtendedHomeVC.storyboardInstance(storyBoardName: "Main") as? ExtendedHomeVC
        self.slideMenuController()?.changeToRootMainViewController(homeViewController!, close: true)
    }
}

extension OnBoardVC: SlideMenuControllerDelegate {
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
