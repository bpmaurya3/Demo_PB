//
//  SignUpVC.swift
//  PayBack
//
//  Created by Mohsin Surani on 09/01/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit

class SignUpVC: BaseViewController {
    @IBOutlet weak fileprivate var pageTitleLabel: UILabel!
    @IBOutlet weak fileprivate var tableview: UITableView!
    @IBOutlet weak fileprivate var signInButton: UIButton!
    @IBOutlet weak fileprivate var skipButton: UIButton!
    fileprivate var pageTitle: String = "Simple Ways to Signup for Payback!" {
        didSet {
            self.pageTitleLabel.text = pageTitle.uppercased()
        }
    }
    fileprivate var infoDataSource = [ShopClickCellViewModel]() {
        didSet {
            self.tableview.reloadData()
        }
    }
    fileprivate var partnersDatasource = [ShopClickCellViewModel]() {
        didSet {
            self.tableview.reloadData()
        }
    }
    fileprivate let signupCellId = "SignUpCell"
    fileprivate let signupFetcher = SignupFetcher()
    fileprivate let onlinePartnerFetcher = OnlinePartnerFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableViewAutomaticDimension
        registerCells()
     
        skipButton.setAttributedTitle(.getUnderLineText(string: "skip", color: .black), for: .normal)
        signInButton.setAttributedTitle(.getUnderLineText(string: "Sign in", color: .black), for: .normal)
        
        self.fetchVerticalGrid()
        
        let when = DispatchTime.now() + 0.15
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.fetchOnlineParner()
        }
    }
    
    private func registerCells() {
        tableview.register(SignUpCell.self, forCellReuseIdentifier: signupCellId)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    @IBAction func skipAction(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signinClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("SignUpVC deinit called")
    }
}
extension SignUpVC {
    fileprivate func fetchVerticalGrid() {
        signupFetcher
            .onSuccess { [weak self](model) in
                if let title = model.imageGridWithTitle?.title {
                    self?.pageTitle = title
                }
                var cellModelArray = [ShopClickCellViewModel]()
                guard let grids = model.imageGridWithTitle?.imageGridDetails else {
                    return
                }
                for grid in grids {
                    cellModelArray.append(ShopClickCellViewModel(withSignupGrid: grid))
                }
                self?.infoDataSource = cellModelArray
            }
            .onError { (error) in
                print("\(error)")
            }
            .fetch()
    }
    func fetchOnlineParner() {
        onlinePartnerFetcher
            .onSuccess(success: { [weak self] (otherPartnerData) in
                var cellModelArray = [ShopClickCellViewModel]()
                guard let tiles = otherPartnerData.partnerDetails else {
                    return
                }
                for partner in tiles {
                    cellModelArray.append(ShopClickCellViewModel(withSignupParners: partner))
                }
                self?.partnersDatasource = cellModelArray
            })
            .onError(error: { (error) in
                print("\(error)")
            })
            .fetch(onlinePartnerFor: .signupPartner)
    }
}

extension SignUpVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoDataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == infoDataSource.count {
             return configureHeaderCell(indexPath: indexPath)
        }
        return configureInstructionCell(indexPath: indexPath)
    }
}

extension SignUpVC {
    fileprivate func configureInstructionCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let infoImageView = UIImageView()
        infoImageView.clipsToBounds = true
        infoImageView.contentMode = .scaleAspectFit
        infoImageView.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(infoImageView)
        
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.font = FontBook.Regular.ofHeaderSize()
        cell.addSubview(infoLabel)
        
        let widthHeight: CGFloat = (DeviceType.IS_IPAD) ? 140 : 100
        
        infoImageView.widthAnchor.constraint(equalToConstant: widthHeight).isActive = true
        infoImageView.heightAnchor.constraint(equalToConstant: widthHeight).isActive = true
        infoImageView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
        infoImageView.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: 0).isActive = true
        
        infoLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 10).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
        infoLabel.topAnchor.constraint(equalTo: infoImageView.bottomAnchor, constant: 10).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -10).isActive = true
        
        infoImageView.image = infoDataSource[indexPath.row].image
        if let imagePath = infoDataSource[indexPath.row].imagePath {
            infoImageView.downloadImageFromUrl(urlString: imagePath)
        }
        infoLabel.text = infoDataSource[indexPath.row].title
        return cell
    }
    
    fileprivate func configureHeaderCell(indexPath: IndexPath) -> SignUpCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: signupCellId, for: indexPath) as? SignUpCell
        cell?.cellModel = partnersDatasource
        cell?.selectionStyle = .none
        cell?.selectedPartnerSite(closure: { [weak self] (partnerSiteUrl, partnerLogo) in
            self?.redirectVC(redirectLink: partnerSiteUrl, redirectLogoUrl: partnerLogo)
        })
        return cell!
    }

}
