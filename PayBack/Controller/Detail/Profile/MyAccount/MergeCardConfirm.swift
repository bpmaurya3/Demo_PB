//
//  MergeCardConfirm.swift
//  PayBack
//
//  Created by Dinakaran M on 06/10/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class MergeCardConfirm: UIViewController {

    typealias UpdateConfirmStatus = ((Bool) -> Void)
    var updateConfirm: UpdateConfirmStatus = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    deinit {
        print("Deinit - MergeCardConfirm called")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    @discardableResult
    func updateConfirmStatus(closure: @escaping UpdateConfirmStatus) -> Self {
        updateConfirm = closure
        return self
    }
    @IBAction func confirmAction(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
       self.updateConfirm(true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
