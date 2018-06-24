//
//  PopOverVC.swift
//  PayBack
//
//  Created by valtechadmin on 4/18/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit

class PopOverVC: UIViewController {

  @IBOutlet weak private var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPopoverInfo(_ info: String?) {
        guard let text = info else {
            return
        }
        if infoLabel != nil {
            infoLabel.text = text
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
