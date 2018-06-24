//
//  PBOfferContentCVCell.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 19/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBOfferContentCVCell: UICollectionViewCell {
    
    var loadMoreClosure: () -> Void = {}
    var loadMoreInfo: LoadMoreInfo = (0, 0, false, "")
    var distanceActionClosure: ((UIButton) -> Void) = { _ in }

    var categoryType: CategoryType = .none {
        didSet {
            setupOfferView()
        }
    }
    var redirectUrlClosure: ((String, String) -> Void)? = { _, _ in }
    @discardableResult
    func redirectUrl(closure: @escaping ((String, String) -> Void) ) -> Self {
        self.redirectUrlClosure = closure
        return self
    }
    
    let offerzoneNwController = OfferZoneNWController()
    let insuranceNwController = ExploreNWController()
    let paybackPlusNwController = PaybackPlusNWController()
    
    internal var cellModel: ([CouponsRechargeCellModel]) = [] {
        didSet {
            self.offerTableView.loadMoreInfo = loadMoreInfo
            self.offerTableView.cellModel = cellModel
        }
    }
    
    private var helpCenterCellModel: [PBHelpCentreDetailTVCellModel]? {
        didSet {
            guard let cellModel = helpCenterCellModel else {
                return
            }
            self.helpCentreTableView.sourceData = cellModel
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellModel.removeAll()
    }
    internal var helpCenterUserData: HelpCenter.AccordionDetails? {
        didSet {
            guard let quesAnsData = helpCenterUserData?.quesAnsValues  else {
                return
            }
            var detailCellModel = [PBHelpCentreDetailTVCellModel]()
            var i = 0
            for quesAns in quesAnsData {
                detailCellModel.append(PBHelpCentreDetailTVCellModel(question: quesAns.quest, answer: quesAns.ans, isCollabsHidden: i == 0 ? false : true, index: i))
                i += 1
            }
             helpCenterCellModel = detailCellModel
        }
    }
    
    lazy var offerTableView: PBOfferTableView = {
        let view = PBOfferTableView()
        view.redirectUrl(closure: { [weak self] (redirectUrl, redirectLogoUrl) in
            if let strongSelf = self, let closure = strongSelf.redirectUrlClosure {
                closure(redirectUrl, redirectLogoUrl)
            }
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        view.loadMoreClosure = { [weak self] in
            self?.loadMoreClosure()
        }
        view.distanceActionClosure = self.distanceActionClosure
        return view
    }()
    
    lazy var helpCentreTableView: PBHelpCentreTableView = {
        let view = PBHelpCentreTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print(" PBOfferContentCVCell deinit called")
    }
    
    private func setupOfferView() {
        backgroundColor = .clear
        switch categoryType {
        case .helpCentre:
            self.addSubview(self.helpCentreTableView)
            self.addConstraintsWithFormat("H:|[v0]|", views: self.helpCentreTableView)
            self.addConstraintsWithFormat("V:|[v0]|", views: self.helpCentreTableView)
        default:
            self.addSubview(self.offerTableView)
            offerTableView.categoryType = categoryType
            self.addConstraintsWithFormat("H:|[v0]|", views: self.offerTableView)
            self.addConstraintsWithFormat("V:|[v0]|", views: self.offerTableView)
        }
        
    }
}
