//
//  PoliciesVC.swift
//  PayBack
//
//  Created by Dinakaran M on 18/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
import WebKit

class PoliciesVC: BaseViewController {
  
    @IBOutlet weak private var navigationView: DesignableNav!
    var type: StaticWebContentType = .none
    fileprivate var staticWebCntText = ""
    fileprivate var webView: WKWebView!
    
    var urlToBeOpen: String?
    
    fileprivate var staticWebContentFetcher: StaticWebContentFetcher!
    fileprivate var voucherWorldFetcher: VoucherWorldFetcher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationTitle()
        self.staticWebContentFetcher = StaticWebContentFetcher()
        self.voucherWorldFetcher = VoucherWorldFetcher()
        if self.checkConnection() {
            connectionSuccess()
        }
    }
    override func connectionSuccess() {
        guard urlToBeOpen != nil else {
            fetchStaticWebContent()
            return
        }
        loadWebView()
    }
    
    private func loadWebView() {
        guard let urlString = urlToBeOpen, let url = URL(string: urlString) else {
            print("URL is incorrect: \(urlToBeOpen ?? "")")
            return
        }
        self.webView = WKWebView(frame: .zero)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.navigationDelegate = self
        
        self.view.addSubview(webView)
        self.webView.topAnchor.constraint(equalTo: self.navigationView.bottomAnchor).isActive = true
        self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        let request = URLRequest(url: url)
        self.startActivityIndicator()
        webView.load(request)
    }
    private func setupNavigationTitle() {
        switch type {
        case .policies:
            staticWebCntText = "privacy_policy"
            navigationView.title = "PRIVACY POLICY"
        case .voucherWorld:
            staticWebCntText = "Voucher_World"
            navigationView.title = "INSTANT VOUCHERS"
        case .termsAndConditions:
            staticWebCntText = "Terms_Conditions"
            navigationView.title = "TERMS & CONDITIONS"
        case .reviews:
            staticWebCntText = "write_reviews"
            navigationView.title = "Write Reviews"
        case .none:
            break
        }
    }
    
    func getVoucherWorldURLToken(url: String) {
        voucherWorldFetcher
            .onSuccess { [weak self] (model) in
                if let encryptedKey = model.encryptedKey {
                    let finalUrl = url + "?tokendata=\(encryptedKey)"
                    self?.urlToBeOpen = RequestFactory.getFullURL(urlString: finalUrl)
                    self?.loadWebView()
                }
            }
            .onError { (error) in
                print(error)
            }
            .fetchVoucherWorld()
    }
}

extension PoliciesVC {
    fileprivate func fetchStaticWebContent() {
        self.startActivityIndicator()
        staticWebContentFetcher
            .onSuccess { [weak self] (contentModel) in
                self?.stopActivityIndicator()
                guard let staticContentElements = contentModel.staticWebContentElements else {
                    self?.showErrorView(errorMsg: StringConstant.API_Response_Error)
                    return
                }
                for content in staticContentElements where content.staticWebCntText == self?.staticWebCntText {
                    if let url = content.staticWebCntURL {
                        if self?.type == .voucherWorld {
                            self?.getVoucherWorldURLToken(url: url)
                            return
                        }
                        self?.urlToBeOpen = RequestFactory.getFullURL(urlString: url)
                        self?.loadWebView()
                    }
                }
            }
            .onError { [weak self] (error) in
                self?.stopActivityIndicator()
                self?.showErrorView(errorMsg: error)
            }
            .fetchStaticWebContent()
    }
}

extension PoliciesVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.stopActivityIndicator()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.stopActivityIndicator()
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.stopActivityIndicator()
    }
}
