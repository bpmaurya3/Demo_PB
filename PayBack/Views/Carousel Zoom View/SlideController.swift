//
//  SlideController.swift
//  PhotoSlideShow-Swift
//
//  Created by VillyG on 4/21/15.
//  Copyright (c) 2015 VillyG. All rights reserved.
//

import UIKit

class SlideController: UIViewController {
    
    var itemIndex: Int = -1
    var image: UIImage!
    var imageUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadScrollView()
    }
    
    func loadScrollView() {

        let scrollView: ImageScrollView = ImageScrollView()
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view = scrollView
        self.view.backgroundColor = .white
        scrollView.imageUrl = imageUrl
        scrollView.displayImage()
    }
    
    deinit {
        print("image scrollview deinit")
    }
}
