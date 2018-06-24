//
//  CALayer.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/1/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case UIRectEdge.right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor
        self.addSublayer(border)
    }
  
    func addDashedBorder(strokeColor: UIColor, lineWidth: CGFloat) {
        let strokeColor = strokeColor.cgColor
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = kCALineJoinRound
        
        shapeLayer.lineDashPattern = [5, 5] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height: shapeRect.height), cornerRadius: self.cornerRadius).cgPath
        
        self.addSublayer(shapeLayer)
    }
    
    func addTrianglePopOver(startingPoint: CGFloat, color: UIColor) {
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: startingPoint, y: 0))
        path.addLine(to: CGPoint(x: startingPoint + frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: startingPoint - frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: startingPoint, y: 0))
        path.close()
        
        let shape = CAShapeLayer()
        shape.fillColor = color.cgColor
        shape.path = path.cgPath
        self.addSublayer(shape)
    }
    
    func addTriangleLeftArrow(startingPoint: CGFloat, color: UIColor) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: startingPoint + frame.height / 2))
        path.addLine(to: CGPoint(x: startingPoint + frame.width, y: 0))
        path.addLine(to: CGPoint(x: startingPoint + frame.width, y: startingPoint + frame.height))
        path.close()
        
        let shape = CAShapeLayer()
        shape.fillColor = color.cgColor
        shape.path = path.cgPath
        self.addSublayer(shape)
    }
    
    func addBorderRect(color: UIColor, thickness: CGFloat) {
        self.borderWidth = thickness
        self.borderColor = color.cgColor
    }
}
