//
//  BaseMycartCVCell.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/21/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class BaseMycartCVCell: UICollectionViewCell {
    var crossClosure: (MyCartTVCellModel) -> Void = { _ in }
    var moveToWishClosure: (MyCartTVCellModel) -> Void = { _ in }
    
    internal let mycartCellID = "MyCartTVCell"
    internal let myOrderCellID = "MyOrderTVCell"
    var tabSelectionType: MyCartCellType = MyCartCellType.none
    var cellType: MyCartCellType = MyCartCellType.none {
        didSet {
            if cellType == .noCartCell {
                self.addEmptyView()
                return
            }
            self.addtableView()
        }
    }
    
    var cellModel: [Any] = [Any]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var trackActionHandler: ((MyOrderTVCellModel) -> Void )?
    
    internal lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .singleLine
        tv.tableFooterView = UIView()
        tv.estimatedRowHeight = 100
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    internal lazy var emptyView: EmptyOrderView = {
        let tv = EmptyOrderView(frame: .zero, style: .plain)
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func addEmptyView() {
        DispatchQueue.main.async {
            self.tableView.removeFromSuperview()
            self.emptyView.tabSelectionType = self.tabSelectionType
            self.addSubview(self.emptyView)
            self.addConstraintsWithFormat("H:|[v0]|", views: self.emptyView)
            self.addConstraintsWithFormat("V:|[v0]|", views: self.emptyView)
        }
    }
    
    func addtableView() {
        DispatchQueue.main.async {
            self.emptyView.removeFromSuperview()
            self.addSubview(self.tableView)
            self.addConstraintsWithFormat("H:|-6-[v0]-6-|", views: self.tableView)
            self.addConstraintsWithFormat("V:|[v0]|", views: self.tableView)
        }
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "MyCartTVCell", bundle: nil), forCellReuseIdentifier: mycartCellID)
        tableView.register(UINib(nibName: "MyOrderTVCell", bundle: nil), forCellReuseIdentifier: myOrderCellID)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {}
}

extension BaseMycartCVCell: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch cellType {
        case .myCartCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: mycartCellID, for: indexPath) as? MyCartTVCell, cellModel.count > indexPath.section else {
                return UITableViewCell()
            }
            configurMyCartCell(cell: cell)
            cell.addBorderToCellSubviews()
            cell.cellModel = cellModel[indexPath.section] as? MyCartTVCellModel
            return cell
        case .myOrderCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: myOrderCellID, for: indexPath) as? MyOrderTVCell, cellModel.count > indexPath.section else {
                return UITableViewCell()
            }
            cell.addBorderToCellSubviews()
            cell.cellModel = cellModel[indexPath.section] as? MyOrderTVCellModel
            cell.setTrackButtonTag(tag: indexPath.section)
            cell.trackActionHandler = { [weak self] index in
                if let strongSelf = self, let trackHandler = strongSelf.trackActionHandler, let cellModel = strongSelf.cellModel[index] as? MyOrderTVCellModel {
                    trackHandler(cellModel)
                }
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}
extension BaseMycartCVCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7.5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 7.5))
        view.backgroundColor = .clear
        return view
        
    }
}

extension BaseMycartCVCell {
    fileprivate func configurMyCartCell(cell: MyCartTVCell) {
        cell.crossClosure = { [unowned self] (model) in
            self.crossClosure(model)
        }
        cell.moveToWishClosure = { (model) in
            
        }
    }
}
