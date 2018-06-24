//
//  EarnBaseOnlinePartnersVC.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/31/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

enum TabIndex: Int {
    case firstChildTab = 0
    case secondChildTab = 1
}

class EarnBaseOnlinePartnersVC: BaseViewController {
    
    @IBOutlet weak fileprivate var segmentView: CustomSegmentView!
    @IBOutlet weak fileprivate var collectionView: UICollectionView!
    @IBOutlet weak private var navigationView: DesignableNav!
    @IBOutlet weak private var backButton: UIBarButtonItem!
    var defaultSelectedIndex = 0
    
    lazy var onlinePartnersVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "OnlinePartnersViewController")
        return firstChildTabVC
    }()
    
    lazy var otherOnlinePartnersVC: UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherOnlinePartnersVC")
        return secondChildTabVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isScrollEnabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("EarnBaseOnlinePartnersVC Deinit called")
    }
   
    private func setupSegmentView() {
        
        let segmentTitle1 = SegmentCollectionViewCellModel(image: UIImage(named: "shoponlinenormal"), title: NSLocalizedString("Shop Online \nVia PayBack", comment: "Online partner segment title"), itemId: 1, selectedImage: UIImage(named: "shoponlineselected"))
        let segmentTitle2 = SegmentCollectionViewCellModel(image: UIImage(named: "otheronlinenormal"), title: NSLocalizedString("Other Online \nBrands", comment: "Online partner segment title"), itemId: 2, selectedImage: UIImage(named: "otheronlineselected"))
        
        let titles = [segmentTitle1, segmentTitle2]
        
        let segmentConfig = SegmentCVConfiguration()
            .set(title: titles)
            .set(numberOfItemsPerScreen: 2)
            .set(isImageIconHidden: false)
            .set(isSelectedImageIconHidden: false)
            .set(selectedIndex: defaultSelectedIndex)
            .set(segmentItemSpacing: 1)
        segmentView.configuration = segmentConfig
        
        segmentView.configuration?.selectedCompletion = { [weak self] (segmentModel, index) in
            if let strongSelf = self {
                strongSelf.switchTabs(index)
            }
        }
        //segmentView.configuration?.set(selectedIndex: defaultSelectedIndex)
    }
    
    // MARK: Actions
   
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    fileprivate func setNavigtionTitle(at index: Int) {
        self.navigationView.title = index == 0 ? "ONLINE BRANDS" : "OTHER ONLINE BRANDS"
    }
}

extension EarnBaseOnlinePartnersVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
       displayCurrentTab(indexPath.item, cell: cell)
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.move().x / view.frame.width
        segmentView.selectSegmentAtIndex(Int(index))
    }
    
}
extension EarnBaseOnlinePartnersVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension EarnBaseOnlinePartnersVC {

    fileprivate func switchTabs(_ index: Int) {
        DispatchQueue.main.async {
            self.setNavigtionTitle(at: index)
        }
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    fileprivate func displayCurrentTab(_ tabIndex: Int, cell: UICollectionViewCell) {
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            
            vc.view.frame = cell.bounds
            cell.addSubview(vc.view)
        }
    }
    
    fileprivate func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.firstChildTab.rawValue :
            vc = onlinePartnersVC
        case TabIndex.secondChildTab.rawValue :
            vc = otherOnlinePartnersVC
        default:
            return nil
        }
        return vc
    }

}
