//
//  MyCardsViewController.swift
//  PayBack
//
//  Created by Dinakaran M on 04/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
class MyCardsViewController: BaseViewController {
    fileprivate let cellIdentifier = "MyCardsTVCell"
    var sourceData: [MyCardsTVCellModel] = []
    @IBOutlet weak fileprivate var tableview: UITableView!
    @IBOutlet weak fileprivate var mergecardButton: UIButton!
    var mergerCardConfirmVC: MergeCardConfirm?
    
    fileprivate var myCardAuthorableContentFetcher: MyCardAuthorableContentFetcher!
    
    @IBAction func mergeCardAction(_ sender: Any) {
        let selectedModel = self.sourceData.filter({ (modelData) -> Bool in
            if modelData.isSelected == true {
                if modelData.primaryTag == true {
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        })
        
        if !selectedModel.isEmpty {
            print("Merge card Action")
            let profileStoryBoard = UIStoryboard(name: "Profile", bundle: nil)
            if let mergerCardConfirmVC = profileStoryBoard.instantiateViewController(withIdentifier: "MergeCardConfirm") as? MergeCardConfirm {
                self.mergerCardConfirmVC = mergerCardConfirmVC
            } else {
                return
            }
            mergerCardConfirmVC?.modalPresentationStyle = .overFullScreen
            mergerCardConfirmVC?.modalTransitionStyle = .crossDissolve
            mergerCardConfirmVC?.updateConfirmStatus(closure: {[weak self](status) in
                if status {
                    for modelData in selectedModel {
                        if let index = self?.sourceData.index(of:modelData) {
                            self?.sourceData.remove(at: index)
                        }
                    }
                    self?.mergecardButton.isHidden = true
                    self?.tableview.reloadData()
                }
            })
            self.present(mergerCardConfirmVC!, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("cards")
        tableview.estimatedRowHeight = 100
        mergecardButton.backgroundColor = ColorConstant.buttonBackgroundColorPink
        mergecardButton.titleLabel?.font = FontBook.Regular.of(size: 17.0)
        mergecardButton.isHidden = true
    }
    fileprivate func fetch() {
        guard self.checkConnection(withErrorViewYPosition: 0) else {
            return
        }
        self.myCardAuthorableContentFetcher = MyCardAuthorableContentFetcher()
            .onSuccess(success: { [weak self] (cardContent) in
                guard let strongSelf = self, let content = cardContent.myCardDetails else {
                    _ = self?.openErrorView(withMessage: StringConstant.timeOutMessage)
                    return
                }
                strongSelf.setCardDetails(cardDetails: content)
            })
            .onError(error: { [weak self] (error) in
                self?.showErrorView(errorMsg: error)
            })
        self.myCardAuthorableContentFetcher.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
    override func connectionSuccess() {
        fetch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        print("MyCardsViewController Deinit called")
    }
}
extension MyCardsViewController {
    fileprivate func setCardDetails(cardDetails: MyCardContent.MyCardDetails) {
        sourceData.removeAll()
        if let userDetails = UserProfileUtilities.getUserDetails() {
            var name = "\(userDetails.FirstName ?? "")"
            let LCN = "\(userDetails.CardNumber ?? "")"
            var cardNumber: String = LCN.subString(upto: 16)
            let pointsAvailable = "\(userDetails.AvailablePoints ?? "")"
            if let showLCN = cardDetails.showLCN, showLCN == false {
                cardNumber = ""
            }
            if let showFirstName = cardDetails.showFirstName, showFirstName == false {
                name = ""
            }
            let data1 = MyCardsTVCellModel(holderName: name, cardNumber: cardNumber, points: pointsAvailable, primaryTag: false, indexID: 0, isSelected: false, imagePath: cardDetails.myCardImage)
            sourceData.append(data1)
            tableview.reloadData()
        }
    }
}
extension MyCardsViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sourceData.count > 1 {
            self.mergecardButton.isHidden = false
        }
        return sourceData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MyCardsTVCell else {
            return UITableViewCell()
        }
        
        cell.updateSelectedState(closure: {[weak self] (index, isEnabledStatus) in
            var filteredList = self?.sourceData.filter({ (modelData) -> Bool in
                if modelData.indexID == index {
                    return true
                } else {
                    return false
                }
            })
            if !(filteredList?.isEmpty)! {
                filteredList![0].isSelected = isEnabledStatus
            }
        })
        cell.updateViewTransaction(closure: {[weak self] (index) in
            let selectedModel = self?.sourceData.filter({ (modelData) -> Bool in
                if modelData.indexID == index {
                    return true
                } else {
                    return false
                }
            })
            if !(selectedModel?.isEmpty)! {
                let profileStoryBoard = UIStoryboard(name: "Profile", bundle: nil)
                let viewTransactionVC = profileStoryBoard.instantiateViewController(withIdentifier: "MyTransactionsVC") as? MyTransactionsVC
                self?.navigationController?.pushViewController(viewTransactionVC!, animated: true)
            }
        })
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MyCardsTVCell {
            cell.sourceData = sourceData[indexPath.row]
            cell.displayCheckButton(display: sourceData.count > 1 ? true : false)
        }
    }
}
extension MyCardsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
extension MyCardsViewController {
    fileprivate func mock() {
        let data2 = MyCardsTVCellModel(holderName: "", cardNumber: "123456789123456", points: "25896", primaryTag: false, indexID: 1, isSelected: false, imagePath: nil)
        let data3 = MyCardsTVCellModel(holderName: "Kavita Gupta", cardNumber: "123456789123456", points: "25896", primaryTag: false, indexID: 2, isSelected: false, imagePath: nil)
        let data4 = MyCardsTVCellModel(holderName: "Kavita Gupta", cardNumber: "123456789123456", points: "25896", primaryTag: false, indexID: 3, isSelected: false, imagePath: nil)
        let data5 = MyCardsTVCellModel(holderName: "Dinakaran M", cardNumber: "123456789123456", points: "25896", primaryTag: false, indexID: 4, isSelected: false, imagePath: nil)
        let data6 = MyCardsTVCellModel(holderName: "Kavita Gupta", cardNumber: "123456789123456", points: "25896", primaryTag: false, indexID: 5, isSelected: false, imagePath: nil)
        let data7 = MyCardsTVCellModel(holderName: "Dinakaran M", cardNumber: "123456789123456", points: "25896", primaryTag: false, indexID: 6, isSelected: false, imagePath: nil)
        
        sourceData.append(data2)
        sourceData.append(data3)
        sourceData.append(data4)
        sourceData.append(data5)
        sourceData.append(data6)
        sourceData.append(data7)
    }
}
