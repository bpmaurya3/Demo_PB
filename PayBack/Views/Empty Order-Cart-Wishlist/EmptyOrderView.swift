//
//  EmptyOrderView.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/20/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class EmptyOrderView: UITableView, UITableViewDataSource, UITableViewDelegate {
    fileprivate let noCartUpperCellID = "NoCartUpperTVCell"
    fileprivate let noCartLowerCellID = "NoCartLowerTVCell"
    
    var tabSelectionType: MyCartCellType = MyCartCellType.none {
        didSet {
            delegate = self
            dataSource = self
            self.reloadData()
        }
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.registerCells()
        separatorStyle = .none
        tableFooterView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerCells() {
        register(UINib(nibName: "NoCartUpperTVCell", bundle: nil), forCellReuseIdentifier: noCartUpperCellID)
        register(UINib(nibName: "NoCartLowerTVCell", bundle: nil), forCellReuseIdentifier: noCartLowerCellID)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return assignAppropriateCell(indexPath: indexPath)
    }
}
extension EmptyOrderView {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateCellHeightForNoCart(indexPath: indexPath)
    }
}

extension EmptyOrderView {
    
    fileprivate func assignAppropriateCell(indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case NoCartCell.NoCartUpperTVCell.rawValue:
            if let cell = self.dequeueReusableCell(withIdentifier: noCartUpperCellID, for: indexPath) as? NoCartUpperTVCell {
                switch tabSelectionType {
                case .myCartCell:
                    cell.cellModel = NoCartUpperTVCellModel(iconImage: #imageLiteral(resourceName: "emptycart"), title: "No products in the cart", descriptionString: "Empty Shoping cart looks boring!\nGive your shopping cart a makeover now!")
                case .myOrderCell:
                    cell.cellModel = NoCartUpperTVCellModel(iconImage: #imageLiteral(resourceName: "emptyorder"), title: "No wishes?", descriptionString: "There's a lot that you can have your handon. Take a look!")
                case .whishListCell:
                    cell.cellModel = NoCartUpperTVCellModel(iconImage: #imageLiteral(resourceName: "wishlistempty"), title: "No products in the wishlist", descriptionString: "More wishes, please?\nWe promise we'll try to helpyou fulfill all of them.")
                default:
                    break
                }
                return cell
            }
            return UITableViewCell()
        case NoCartCell.NoCartLowerTVCell.rawValue:
            if let cell = self.dequeueReusableCell(withIdentifier: noCartLowerCellID, for: indexPath) as? NoCartLowerTVCell {
                cell.title = tabSelectionType == .myCartCell ? "Here are some wishes we saved up for you!" : tabSelectionType == .myOrderCell ? "Here are some amazing things to tempt you!" : "Here's what we are dreaming of!"
                return cell
            }
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    fileprivate func calculateCellHeightForNoCart(indexPath: IndexPath) -> CGFloat {
        
        let tableViewHeight = self.frame.height < 559 ? 559 : self.frame.height
        //        if let orientation = orientation, orientation.isLandscape {
        //            tableViewHeight = tableView.frame.width
        //        }
        
        switch indexPath.section {
        case NoCartCell.NoCartUpperTVCell.rawValue:
            return tableViewHeight / 2
        case NoCartCell.NoCartLowerTVCell.rawValue:
            return tableViewHeight / 2
        default:
            return tableViewHeight / 2
        }
    }
}
