//
//  RedirectionVC.swift
//  PayBack
//
//  Created by Dinakaran M on 11/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class RedirectionVC: BaseViewController {

    @IBOutlet weak private var backGroundImage: UIImageView!
    @IBOutlet weak private var paybackLogo: UIImageView!
    @IBOutlet weak private var partnerLogo: UIImageView!
    @IBOutlet weak private var loadingImage: UIImageView!
    @IBOutlet weak private var getSetLabel: UILabel!
    @IBOutlet weak private var aRewardingLabel: UILabel!
    @IBOutlet weak private var messageLabel: UILabel!
    var timerSelector: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSetLabel.textColor = ColorConstant.redirectionTitleColor
        getSetLabel.font = FontBook.Regular.of(size: 17.0)
        
        aRewardingLabel.textColor = ColorConstant.redirectionTitleColor
        aRewardingLabel.font = FontBook.Regular.of(size: 17.0)
        
        messageLabel.textColor = ColorConstant.redirectionDescriptionColor
        messageLabel.font = FontBook.Regular.of(size: 12.0)
        
        let image = UIImage.gifImageWithName("loadinggif")
        self.loadingImage.image = image
        
        if BaseViewController().checkConnection() {
            self.connectionSuccess()
        }
    }
    
    override func connectionSuccess() {
        self.setupRedirection()
    }
    
    func setupRedirection() {
        if let imagepath = partnerlogoUrl {
            self.partnerLogo.downloadImageFromUrl(urlString: imagepath)
        } else {
            self.partnerLogo.image = #imageLiteral(resourceName: "placeholder")
        }
        timerSelector = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(self.redirecToWeb), userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stopTimerSelector() {
        timerSelector?.invalidate()
        print("stoped redirection")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopTimerSelector()
    }
    
    deinit {
        timerSelector?.invalidate()
        print("Deinit Called - RedirectionVC")
    }
    
    @objc func redirecToWeb() {
        
        guard let url = redirectUrl?.getUrlLink() else {
            print("Error In Redirect Url: \(String(describing: redirectUrl))")
            self.showErrorViewInWindow(errorMsg: "Invalid URL")
            self.popViewController()
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: { [weak self] (_) in
                self?.perform(#selector(self?.popViewController), with: nil, afterDelay: 0.2)
            })
        } else {
            UIApplication.shared.openURL(url)
            self.perform(#selector(self.popViewController), with: nil, afterDelay: 0.25)
        }
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: false)
    }
}
