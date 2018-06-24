//
//  ReviewVC.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/16/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class ReviewVC: BaseViewController {    
    @IBOutlet weak private var navigationView: DesignableNav!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationView.title = "Write Reviews"
        // Do any additional setup after loading the view.
    }
    deinit {
        print("Deinit - ReviewVC")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
