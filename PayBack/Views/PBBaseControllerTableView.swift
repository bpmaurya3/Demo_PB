//
//  PBBaseControllerTableView.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/30/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

class PBBaseControllerTableView: UIView, UITableViewDataSource, UITableViewDelegate {
    fileprivate var cellHeight: CGFloat = 0.0
    
    var didSelectAtIndexPath: ((IndexPath) -> Void ) = { _ in }
    
    internal var staticDatas: [LandingTilesGridCellModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private func setupViews() {
        self.backgroundColor = ColorConstant.vcBGColor
        
        addSubview(tableView)
        
        tableView.register(PBBaseControllerTableViewCell.self, forCellReuseIdentifier: Cells.pbBaseControllerTableViewCell)
        
        self.addConstraintsWithFormat("H:|[v0]|", views: tableView)
        self.addConstraintsWithFormat("V:|[v0]-8-|", views: tableView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if bounds.height > bounds.width {
            cellHeight = (tableView.frame.height) / 4
        } else {
            cellHeight = (tableView.frame.height) / 2
        }
        tableView.backgroundColor = ColorConstant.vcBGColor
        tableView.reloadData()
    }
}

extension PBBaseControllerTableView {
    func numberOfSections(in tableView: UITableView) -> Int {
        return staticDatas.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.pbBaseControllerTableViewCell, for: indexPath) as? PBBaseControllerTableViewCell
        cell?.staticData = staticDatas[indexPath.section]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectAtIndexPath(indexPath)
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0
//    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 7))
//        view.backgroundColor = ColorConstant.vcBGColor
//        return view
//    }
}

internal class PBBaseControllerTableViewCell: UITableViewCell {
    var isInterItemSpacingRequired = false
    var staticData: LandingTilesGridCellModel? {
        didSet {
            self.parseData(forStaticData: staticData!)
        }
    }
    
    private lazy var backgroundImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var opacityView: UIView = {
       let view = UIView()
        view.backgroundColor = ColorConstant.secondaryNavigationBGColor
        view.isOpaque = true
        view.alpha = 0.5
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(hex: "#e6116d")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.clear
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var title: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = FontBook.Regular.of(size: 22.5)
        label.textColor = .white
        label.textAlignment = .left
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        self.backgroundColor = ColorConstant.vcBGColor
        self.addSubview(self.backgroundImageView)
        self.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: self.backgroundImageView)
        self.addConstraintsWithFormat("V:|-8-[v0]|", views: self.backgroundImageView)
        
        self.addSubview(self.opacityView)
        self.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: self.opacityView)
        self.addConstraintsWithFormat("V:|-8-[v0]|", views: self.opacityView)
        
        self.addSubview(iconImageView)
        iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 46.5).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 40.5).isActive = true
        
        iconImageView.addSubview(iconImage)
        iconImage.contentMode = .scaleAspectFit
        iconImage.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        iconImage.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: 0).isActive = true
        iconImage.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor, constant: 0).isActive = true
        
        self.addSubview(title)
        title.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 22.5).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }
    
    private func parseData(forStaticData staticData: LandingTilesGridCellModel) {
        if let allow = staticData.allowBgLayout {
            self.opacityView.backgroundColor = allow ? ColorConstant.secondaryNavigationBGColor : .clear
        }
        if let image = staticData.slideImage {
            self.backgroundImageView.image = image
        }
        
        if let iconImage = staticData.iconImage {
            self.iconImageView.isHidden = false
            self.iconImage.image = iconImage
        } else {
            self.iconImageView.isHidden = true
        }
        
        if let title = staticData.title {
            self.title.text = title
        }
        
        if let imageUrl = staticData.imagePath {
            self.backgroundImageView.downloadImageFromUrl(urlString: imageUrl, imageType: .homeTiles)
        }
        if let imageUrl = staticData.iconImagePath {
            self.iconImageView.isHidden = false
            self.iconImage.downloadImageFromUrl(urlString: imageUrl)
        } else {
            self.iconImageView.isHidden = true
        }
    }
}
