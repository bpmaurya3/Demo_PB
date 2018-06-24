//
//  PayBackDropDown.swift
//  PayBackDropDown
//
//  Created by Bhuvanendra Pratap Maurya on 10/13/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

internal class PayBackDropDown: UIControl {
    
    fileprivate var title: UILabel!
    fileprivate var arrow: Arrow!
    fileprivate var table: UITableView!
    
    fileprivate(set) var selectedIndex: Int?
    internal var options = [String]()
    internal var hideOptionsWhenSelect = true
    internal var placeholder: String! {
        didSet {
            title.text = placeholder
            title.adjustsFontSizeToFitWidth = true
        }
    }
    internal var tint: UIColor? {
        didSet {
            title.textColor = textColor ?? tint
            arrow.backgroundColor = tint
        }
    }
    internal var arrowPadding: CGFloat = 4.0 {
        didSet {
            let size = arrow.superview!.frame.size.width - (arrowPadding * 2)
            arrow.frame = CGRect(x: arrowPadding, y: arrowPadding, width: size, height: size)
        }
    }
    
    // Text
    internal var font: String? {
        didSet {
            title.font = UIFont(name: font!, size: fontSize)
        }
    }
    internal var fontSize: CGFloat = 12.0 {
        didSet {
            title.font = title.font.withSize(fontSize)
        }
    }
    internal var textColor: UIColor? {
        didSet {
            title.textColor = textColor
        }
    }
    internal var textAlignment: NSTextAlignment? {
        didSet {
            title.textAlignment = textAlignment!
        }
    }
    
    internal var optionsFont: String?
    internal var optionsSize: CGFloat = 12.0
    internal var optionsTextColor: UIColor?
    internal var optionsTextAlignment: NSTextAlignment?
    
    // Border
    internal var cornerRadius: CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    internal var borderWidth: CGFloat = 0.5 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    internal var borderColor: UIColor = .black {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    internal var optionsCornerRadius: CGFloat = 3.0 {
        didSet {
            table.layer.cornerRadius = optionsCornerRadius
        }
    }
    internal var optionsBorderWidth: CGFloat = 0.5 {
        didSet {
            table.layer.borderWidth = optionsBorderWidth
        }
    }
    internal var optionsBorderColor: UIColor = .black {
        didSet {
            table.layer.borderColor = optionsBorderColor.cgColor
        }
    }
    
    // Table Configurations
    internal var tableHeight: CGFloat = 100.0
    internal var rowHeight: CGFloat = 30
    internal var rowBackgroundColor: UIColor?
    
    // Closures
    fileprivate var privatedidSelect: (String, Int) -> Void = { option, index in }
    fileprivate var privateTableWillAppear: () -> Void = { }
    fileprivate var privateTableDidAppear: () -> Void = { }
    fileprivate var privateTableWillDisappear: () -> Void = { }
    fileprivate var privateTableDidDisappear: () -> Void = { }
    
    // Init
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    deinit {
        print("PayBackDropDown: deinit called")
    }
    // Class methods
    @discardableResult
    internal func resign() -> Bool {
        if isSelected {
            hideTable()
        }
        return true
    }
    
    fileprivate func setup() {
        
        title = UILabel(frame: CGRect(x: 0,
                                      y: 0,
                                      width: (self.frame.width - self.frame.height),
                                      height: self.frame.height))
        title.textAlignment = .center
        self.addSubview(title)
        
        let arrowContainer = UIView(frame: CGRect(x: title.frame.maxX,
                                                  y: 0,
                                                  width: title.frame.height,
                                                  height: title.frame.height))
        arrowContainer.isUserInteractionEnabled = false
        self.addSubview(arrowContainer)
        
        arrow = Arrow(origin: CGPoint(x: arrowPadding,
                                      y: arrowPadding),
                      size: arrowContainer.frame.width - (arrowPadding * 2))
        arrow.backgroundColor = .black
        arrowContainer.addSubview(arrow)
        
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.addTarget(self, action: #selector(touch), for: .touchUpInside)
    }
    
    @objc fileprivate func touch() {
        isSelected = !isSelected
        isSelected ? showTable() : hideTable()
    }
}
extension PayBackDropDown {
    
    fileprivate func showTable() {
        
        privateTableWillAppear()
        
        table = UITableView(frame: CGRect(x: self.frame.minX,
                                          y: self.frame.minY,
                                          width: self.frame.width,
                                          height: self.frame.height))
        table.dataSource = self
        table.delegate = self
        table.alpha = 0
        table.layer.cornerRadius = optionsCornerRadius
        table.layer.borderWidth = optionsBorderWidth
        table.layer.borderColor = optionsBorderColor.cgColor
        table.rowHeight = rowHeight
        self.superview?.insertSubview(table, belowSubview: self)
        
        animateClassic()
    }
    
    private func animateClassic() {
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut, animations: {
                        
                        self.table.frame = CGRect(x: self.frame.minX,
                                                  y: self.frame.maxY + 5,
                                                  width: self.frame.width,
                                                  height: self.tableHeight)
                        self.table.alpha = 1
                        
                        self.arrow.position = .up
                        
        }, completion: { _ in
            self.privateTableDidAppear()
        })
    }
}
extension PayBackDropDown {
    fileprivate func hideTable() {
        
        privateTableWillDisappear()
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        self.table.frame = CGRect(x: self.frame.minX,
                                                  y: self.frame.minY,
                                                  width: self.frame.width,
                                                  height: 0)
                        self.table.alpha = 0
                        
                        self.arrow.position = .down
        },
                       completion: { _ in
                        self.table.removeFromSuperview()
                        self.isSelected = false
                        self.privateTableDidDisappear()
        })
    }
}

extension PayBackDropDown {
    
    // Actions Methods
    internal func didSelect(completion: @escaping (_ option: String, _ index: Int) -> Void) {
        privatedidSelect = completion
    }
    
    internal func tableWillAppear(completion: @escaping () -> Void) {
        privateTableWillAppear = completion
    }
    
    internal func tableDidAppear(completion: @escaping () -> Void) {
        privateTableDidAppear = completion
    }
    
    internal func tableWillDisappear(completion: @escaping () -> Void) {
        privateTableWillDisappear = completion
    }
    
    internal func tableDidDisappear(completion: @escaping () -> Void) {
        privateTableDidDisappear = completion
    }
}

extension PayBackDropDown: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "UIDropDownCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        if rowBackgroundColor != nil {
            cell!.contentView.backgroundColor = rowBackgroundColor
        }
        
        cell!.textLabel!.font = UIFont(name: optionsFont ?? font ?? cell!.textLabel!.font.fontName, size: optionsSize)
        cell!.textLabel!.textColor = options[indexPath.row] == "Offer" ? .gray : optionsTextColor ?? tint ?? cell!.textLabel!.textColor
        cell!.textLabel!.textAlignment = optionsTextAlignment ?? cell!.textLabel!.textAlignment
        cell!.textLabel!.text = "\(options[indexPath.row])"
        cell!.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
        cell!.selectionStyle = .none
        
        return cell!
    }
}

extension PayBackDropDown: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if options[indexPath.row] == "Offer" {
            return
        }
        selectedIndex = (indexPath as NSIndexPath).row
        
        title.alpha = 0.0
        title.text = "\(self.options[(indexPath as NSIndexPath).row])"
        
        UIView.animate(withDuration: 0.6,
                       animations: { () -> Void in
                        self.title.alpha = 1.0
        })
        
        tableView.reloadData()
        
        if hideOptionsWhenSelect {
            hideTable()
        }
        
        privatedidSelect("\(self.options[indexPath.row])", selectedIndex ?? 0)
    }
}

// Arrow

enum Position {
    case left, down, right, up
}

class Arrow: UIView {
    
    var position: Position = .down {
        didSet {
            switch position {
            case .left:
                self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            case .down:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
            case .right:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            case .up:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        }
    }
    
    init(origin: CGPoint, size: CGFloat) {
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: size, height: size))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        // Get size
        let size = self.layer.frame.width
        
        // Create path
        let bezierPath = UIBezierPath()
        
        // Draw points
        let qSize = size / 4
        
        bezierPath.move(to: CGPoint(x: 0, y: qSize))
        bezierPath.addLine(to: CGPoint(x: size, y: qSize))
        bezierPath.addLine(to: CGPoint(x: size / 2, y: qSize * 3))
        bezierPath.addLine(to: CGPoint(x: 0, y: qSize))
        bezierPath.close()
        
        // Mask to path
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
}
