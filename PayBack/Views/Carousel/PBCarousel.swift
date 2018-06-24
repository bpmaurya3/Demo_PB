//
//  PBCarousel.swift
//  Delego
//
//  Created by Valtech on 8/16/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

enum CarouselIdentifier: String {
    case tutorialCarousel = "OnBoardCVCell"
    case partnerDetailCarousel = "HeroBannerCVCell"
    case productDetailsCarouselCVCell = "ProductDetailsCarouselCVCell"
    case none = ""
}

final public class PBCarousel: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var lastIndex: ((Int) -> Void) = { _ in }
    var cellActionHandler: ((Int) -> Void) = { _ in }

    fileprivate var configuration = PBCarouselConfiguration()
    
    var slides: [BaseModel] = [] {
        didSet {
            pageControl.numberOfPages = slides.count
            pageControl.currentPage = 0
            if configuration.isHeroCarousel && slides.count > 1 {
                let first = slides.first
                let last = slides.last
                slides.insert(last!, at: 0)
                slides.append(first!)
                self.perform(#selector(scrollToItem), with: nil, afterDelay: 0.0)
            }
            
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.reloadData()
        }
    }
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.clipsToBounds = true
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = self.configuration.collectionViewBounce
        return cv
    }()
    
    public lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = self.configuration.pageControllNumberOfPage
        control.currentPage = 0
        control.hidesForSinglePage = true
        control.pageIndicatorTintColor = ColorConstant.pageControlNormalColor
        control.currentPageIndicatorTintColor = ColorConstant.pageControlSelectedColor
        return control
    }()
        
    func confugure(withConfiguration configuration: PBCarouselConfiguration) {
        self.configuration = configuration
        setupCarousel()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        //        setupCarousel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        setupCarousel()
    }
    
    private func setupCarousel() {
        self.backgroundColor = .clear
        
        self.addSubview(collectionView)
        self.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        self.addConstraintsWithFormat("V:|[v0]|", views: collectionView)

        self.addSubview(pageControl)
        self.addConstraintsWithFormat("H:|-20-[v0]-20-|", views: pageControl)
        self.addConstraintsWithFormat("V:[v0(25)]-5-|", views: pageControl)
        self.bringSubview(toFront: pageControl)
        pageControl.isUserInteractionEnabled = false
        
        configureTimerForAutomaticScroll()
        
        collectionView.register(UINib(nibName: "OnBoardCVCell", bundle: nil), forCellWithReuseIdentifier: CarouselIdentifier.tutorialCarousel.rawValue)
   
        collectionView.register(HeroBannerCVCell.self, forCellWithReuseIdentifier: CarouselIdentifier.partnerDetailCarousel.rawValue)
        collectionView.register(ProductDetailsCarouselCVCell.self, forCellWithReuseIdentifier: CarouselIdentifier.productDetailsCarouselCVCell.rawValue)
        
    }
    //swiftlint:disable cyclomatic_complexity
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch configuration.collectionViewCellName {
        
        case .tutorialCarousel:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselIdentifier.tutorialCarousel.rawValue, for: indexPath) as? OnBoardCVCell {
                if slides.isEmpty {
                    cell.slide = HeroBannerCellModel(image: #imageLiteral(resourceName: "placeholder"))
                } else if self.slides.count > indexPath.item {
                    cell.slide = self.slides[indexPath.item] as? HeroBannerCellModel
                }
                return cell
            }
            return UICollectionViewCell()

        case .partnerDetailCarousel:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselIdentifier.partnerDetailCarousel.rawValue, for: indexPath) as? HeroBannerCVCell else {
                return UICollectionViewCell()
            }
            if slides.isEmpty {
                cell.carouselHeaderCellModel = HeroBannerCellModel(image: #imageLiteral(resourceName: "placeholder"))
            } else if self.slides.count > indexPath.item {
                cell.carouselHeaderCellModel = self.slides[indexPath.item] as? HeroBannerCellModel
            }
            return cell
       
        case .productDetailsCarouselCVCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselIdentifier.productDetailsCarouselCVCell.rawValue, for: indexPath) as? ProductDetailsCarouselCVCell else {
                return UICollectionViewCell()
            }
            if slides.isEmpty {
                cell.carouselHeaderCellModel = HeroBannerCellModel(image: #imageLiteral(resourceName: "placeholder"))
            } else if self.slides.count > indexPath.item {
                cell.carouselHeaderCellModel = self.slides[indexPath.item] as? HeroBannerCellModel
            }
            return cell

        default:
             return UICollectionViewCell()
        }
    }
    //swiftlint:enable cyclomatic_complexity
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(slides.count)
        return self.slides.isEmpty ? 1 : self.slides.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !self.slides.isEmpty {
            cellActionHandler(pageControl.currentPage)
        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return size
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if configuration.isHeroCarousel == false {
//            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
//           pageControl.currentPage = Int(pageNumber)
//        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if configuration.isHeroCarousel {
            
            let  contentOffsetWhenFullyScrolledRight = CGFloat(collectionView.frame.size.width) * CGFloat(slides.count - 1)
            
            if scrollView.contentOffset.x == contentOffsetWhenFullyScrolledRight {
                
                // user is scrolling to the right from the last item to the 'fake' item 1.
                // reposition offset to show the 'real' item 1 at the left-hand end of the collection view
                let newIndexPath = IndexPath(item: 1, section: 0)
                
                collectionView.scrollToItem(at: newIndexPath, at: UICollectionViewScrollPosition.left, animated: false)
                
            } else if scrollView.contentOffset.x == 0 {
                
                // user is scrolling to the left from the first item to the fake 'item N'.
                // reposition offset to show the 'real' item N at the right end end of the collection view
                
                let newIndexPath = IndexPath(item: self.slides.count - 2, section: 0)
                
                collectionView.scrollToItem(at: newIndexPath, at: UICollectionViewScrollPosition.left, animated: false)
                
            }
            let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint)
            if let visibleIndex = visibleIndexPath?.item {
                let slide = self.slides[visibleIndex]
                let x = self.slides.index(of: slide)
                let y = x == 0 ? self.slides.count - 2 : x == slides.count ? 1 : x! - 1
                pageControl.currentPage = y
            }
        } else {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }
        lastIndex(Int(pageControl.currentPage))
    }
    
    @objc func scrollToItem() {
        self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
        
    }
    
    @objc func timerAction() {
        
        let indexPath = pageControl.currentPage == self.slides.count - 1 ? IndexPath(item: 0, section: 0) : IndexPath(item: pageControl.currentPage + 1, section: 0)
        
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
    }
    
    deinit {
        print("PBCarousel View deinit called")
    }
    
}

extension PBCarousel {
    
    fileprivate func configureTimerForAutomaticScroll() {
        if self.configuration.isTimerScrollEnabled {
            scrollThroughTimer(self.configuration.timeInterval, self.configuration.isTimerScrollRepeats)
        }
    }
    
    internal func scrollThroughTimer(_ timeInterval: TimeInterval = 5.0, _ repeats: Bool = true) {
        
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerAction), userInfo: nil, repeats: repeats)
    }
}
