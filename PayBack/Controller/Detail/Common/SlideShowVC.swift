//
//  SlideShowController.swift
//  PayBack
//
//  Created by Mohsin Surani on 15/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class SlideShowVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var images: [HeroBannerCellModel] = []
    
    var startIndex = 0
    var pagecontrol = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.dataSource = self
        self.delegate = self
        self.view.backgroundColor = .white
        // Create the first screen
        if let startingViewController = self.getItemController(startIndex) {
            setViewControllers([startingViewController], direction: .forward, animated: false, completion: nil)
        }
    }
    
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCloseButton()
        loadPageControl()
    }
    
    private func loadCloseButton() {
        let closeButton = UIButton()
        closeButton.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        closeButton.frame = CGRect(x: 20, y: 20, width: 40, height: 40)
        closeButton.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(closeButton)
    }
    
    private func loadPageControl() {
        pagecontrol.numberOfPages = images.count
        pagecontrol.hidesForSinglePage = true
        pagecontrol.frame = CGRect(x: 20, y: ScreenSize.SCREEN_HEIGHT - 50, width: ScreenSize.SCREEN_WIDTH - 40, height: 40)
        pagecontrol.pageIndicatorTintColor = ColorConstant.pageControlNormalColor
        pagecontrol.currentPageIndicatorTintColor = ColorConstant.pageControlSelectedColor
        UIApplication.shared.keyWindow?.addSubview(pagecontrol)
        self.pagecontrol.currentPage = startIndex
    }
    
    @objc func close(_ sender: UIButton) {
        sender.removeFromSuperview()
        pagecontrol.removeFromSuperview()
        dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    fileprivate func getItemController(_ itemIndex: Int) -> UIViewController? {
        
        if itemIndex < self.images.count {
            
            print(itemIndex)
            let result = SlideController()
            result.itemIndex = itemIndex
            result.imageUrl = self.images[itemIndex].imagePath
//            self.pagecontrol.currentPage = itemIndex
            return result
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let itemController = viewController as? SlideController else {
            return nil
        }
        
        if (itemController.itemIndex + 1) < self.images.count {
            return getItemController((itemController.itemIndex) + 1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let itemController = viewController as? SlideController else {
            return nil
        }
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex - 1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            guard let currentViewController = pageViewController.viewControllers![0] as? SlideController else {
                return
            }
            self.pagecontrol.currentPage = currentViewController.itemIndex
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("SlideShowVC deinit called")
    }

}
