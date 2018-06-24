//
//  InsuranceViewController.swift
//  PayBack
//
//  Created by Valtech Macmini on 13/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class InsuranceViewController: PBBaseViewController {

    @IBOutlet weak fileprivate var insuranceTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        insuranceTableView.estimatedRowHeight = 100
        
        insuranceTableView.register(UINib(nibName: insuranceHeaderCellNibID, bundle: nil), forCellReuseIdentifier: insuranceHeaderCellNibID)
        insuranceTableView.register(UINib(nibName: insurancePartnerCellNibID, bundle: nil), forCellReuseIdentifier: insurancePartnerCellNibID)
        insuranceTableView.register(UINib(nibName: insuranceProtectCellNibID, bundle: nil), forCellReuseIdentifier: insuranceProtectCellNibID)
//        insuranceTableView.register(UINib(nibName: insuranceSegmentCellNibID, bundle: nil), forCellReuseIdentifier: insuranceSegmentCellNibID)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension InsuranceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 1:
            return 2
        case 2:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = (insuranceTableView.dequeueReusableCell(withIdentifier: insuranceHeaderCellNibID, for: indexPath) as? InsuranceHeaderCell)
            return cell!
        case 1:
            if indexPath.row == 0 {
                let cell = UITableViewCell()
                cell.addSubview(sectionHeader(title: "Our Partners"))
                return cell
            }
            let cell = (insuranceTableView.dequeueReusableCell(withIdentifier: insurancePartnerCellNibID, for: indexPath) as? InsurancePartnerCell)
            return cell!
        default:
            if indexPath.row == 0 {
                let cell = UITableViewCell()
                cell.addSubview(sectionHeader(title: "Why PAYBACK Protect?"))
                return cell
            }
            let cell = (insuranceTableView.dequeueReusableCell(withIdentifier: insuranceProtectCellNibID, for: indexPath) as? InsuranceProtectCell)
            return cell!
        }
    }
    
    private func sectionHeader(title: String) -> InsuranceSectionView {
        let sectionHeaderView = (Bundle.main.loadNibNamed(insuranceSectionViewNibID, owner: self, options: nil)![0] as? InsuranceSectionView)
        sectionHeaderView?.initWithText(title: title)
        return sectionHeaderView!
    }
}
extension InsuranceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1, 2:
            return 10
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180
        } else if indexPath.section == 1 && indexPath.row == 1 {
            return ScreenSize.SCREEN_WIDTH / 3
        }
        return UITableViewAutomaticDimension
    }
}
