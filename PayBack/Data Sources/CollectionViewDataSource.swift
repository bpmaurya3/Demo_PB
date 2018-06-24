//
//  CollectionViewDataSource.swift
//  MVVMDemo
//
//  Created by Bhuvanendra Pratap Maurya on 11/30/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewDataSource<Cell: UICollectionViewCell, ViewModel>: NSObject, UICollectionViewDataSource {
    
    private var cellIdentifier: String!
    private var items: [ViewModel]!
    var configureCell: (Cell, ViewModel) -> Void
    var borderNeed: Bool = true
    
    init(cellIdentifier: String, items: [ViewModel], configureCell: @escaping (Cell, ViewModel) -> Void) {
        
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? Cell, self.items.count > indexPath.item else {
            return UICollectionViewCell()
        }
        let item = self.items[indexPath.item]
        self.configureCell(cell, item)

        if borderNeed {
            self.addCellLayer(cell: cell, index: indexPath.row)
        }
        return cell
    }
    
    fileprivate func addCellLayer(cell: Cell, index: Int) {
        cell.layer.addBorder(edge: .left, color: (index == 0) ? .white : .lightGray, thickness: 1)
    }
}
