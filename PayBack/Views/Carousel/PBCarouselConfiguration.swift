//
//  PBCarouselConfiguration.swift
//  PBCarousel
//
//  Created by Valtech on 8/16/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

final internal class PBCarouselConfiguration {
    
    private(set) var collectionViewBounce = false
    private(set) var pageControllNumberOfPage = 0
    private(set) var timeInterval = 5.0
    private(set) var isTimerScrollEnabled = false
    private(set) var isTimerScrollRepeats = false
    private(set) var isHeroCarousel = false
    
    private(set) var collectionViewCellName = CarouselIdentifier.none
    
    @discardableResult
    func set(collectionViewBounce: Bool) -> Self {
        self.collectionViewBounce = collectionViewBounce
        
        return self
    }
    
    @discardableResult
    func set(pageControllNumberOfPage: Int) -> Self {
        self.pageControllNumberOfPage = pageControllNumberOfPage
        
        return self
    }
    
    @discardableResult
    func set(timeInterval: TimeInterval) -> Self {
        self.timeInterval = timeInterval
        
        return self
    }
    
    @discardableResult
    func set(isTimerScrollEnabled: Bool) -> Self {
        self.isTimerScrollEnabled = isTimerScrollEnabled
        
        return self
    }
    
    @discardableResult
    func set(isTimerScrollRepeats: Bool) -> Self {
        self.isTimerScrollRepeats = isTimerScrollRepeats
        
        return self
    }
    
    @discardableResult
    func set(isHeroCarousel: Bool) -> Self {
        self.isHeroCarousel = isHeroCarousel
        
        return self
    }
    
    @discardableResult
    func set(collectionViewCellName: CarouselIdentifier) -> Self {
        self.collectionViewCellName = collectionViewCellName
        
        return self
    }
}
