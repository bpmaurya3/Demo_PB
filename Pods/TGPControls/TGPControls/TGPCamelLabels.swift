//    @file:    TGPCamelLabels.swift
//    @project: TGPControls
//
//    @author:  Xavier Schott
//              mailto://xschott@gmail.com
//              http://thegothicparty.com
//              tel://+18089383634
//
//    @license: http://opensource.org/licenses/MIT
//    Copyright (c) 2017, Xavier Schott
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

import UIKit

@IBDesignable
public class TGPCamelLabels: UIControl {

    let validAttributes = [NSLayoutAttribute.top.rawValue,      //  3
                           NSLayoutAttribute.centerY.rawValue,  // 10
                           NSLayoutAttribute.bottom.rawValue]   //  4
    
    // Only used if labels.count < 1
    @IBInspectable public var tickCount: Int {
        get {
            return names.count
        }
        set {
            // Put some order to tickCount: 1 >= count >=  128
           // let count = max(1, min(newValue, 128))
          //  debugNames(count: count)
            layoutTrack()
        }
    }
    
    // Only used if labels.count < 1
    @IBInspectable public var tickMinMax: CGPoint {
        get {
            return CGPoint(x: 1, y: 1)
        }
        set {
            // Put some order to tickCount: 1 >= count >=  128
          //  let count = max(1, min(newValue, 128))
            //debugNames(count: count)
            debugMinMaxNames(min: (newValue.x), max: (newValue.y))
            layoutTrack()
        }
    }

    @IBInspectable public var ticksDistance: CGFloat = 44.0 {
        didSet {
            ticksDistance = max(0, ticksDistance)
            layoutTrack()
        }
    }

    @IBInspectable public var value: CGFloat = 0 {
        didSet {
            //dockEffect(duration: animationDuration)
        }
    }

    @IBInspectable public var upFontName: String? = "Arial" {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var upFontSize: CGFloat = 14 {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var upFontColor: UIColor? = nil {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var downFontName: String? = "Arial" {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var downFontSize: CGFloat = 14 {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var downFontColor: UIColor? = nil {
        didSet {
            layoutTrack()
        }
    }

    // Label off-center to the left and right of the slider
    // expressed in label width. 0: none, -1/2: half outside, 1/2; half inside
    @IBInspectable public var offCenter: CGFloat = 0 {
        didSet {
            layoutTrack()
        }
    }

    // Label margins to the left and right of the slider
    @IBInspectable public var insets: NSInteger = 0 {
        didSet {
            layoutTrack()
        }
    }

    // Where should emphasized labels be drawn (10: centerY, 3: top, 4: bottom)
    // By default, emphasized labels are animated towards the top of the frame.
    // This creates the dock effect (camel). They can also be centered vertically, or move down (reverse effect).
    @IBInspectable public var emphasisLayout: Int = NSLayoutAttribute.top.rawValue {
        didSet {
            if !validAttributes.contains(emphasisLayout) {
                emphasisLayout = NSLayoutAttribute.top.rawValue
            }
            layoutTrack()
        }
    }

    // Where should regular labels be drawn (10: centerY, 3: top, 4: bottom)
    // By default, emphasized labels are animated towards the bottom of the frame.
    // This creates the dock effect (camel). They can also be centered vertically, or move up (reverse effect).
    @IBInspectable public var regularLayout: Int = NSLayoutAttribute.bottom.rawValue {
        didSet {
            if !validAttributes.contains(regularLayout) {
                regularLayout = NSLayoutAttribute.bottom.rawValue
            }
            layoutTrack()
        }
    }

    // MARK: @IBInspectable adapters

    public var emphasisLayoutAttribute: NSLayoutAttribute {
        get {
            return NSLayoutAttribute(rawValue: emphasisLayout) ?? .top
        }
        set {
            emphasisLayout = newValue.rawValue
        }
    }

    public var regularLayoutAttribute: NSLayoutAttribute {
        get {
            return NSLayoutAttribute(rawValue: regularLayout) ?? .bottom
        }
        set {
            regularLayout = newValue.rawValue
        }
    }

    // MARK: Properties
    
    public var names:[String] = [] { // Will dictate the number of ticks
        didSet {
            assert(!names.isEmpty)
            layoutTrack()
        }
    }

    // When bounds change, recalculate layout
    override public var bounds: CGRect {
        didSet {
            layoutTrack()
            setNeedsDisplay()
        }
    }

    public var animationDuration: TimeInterval = 0.15

    // Private
    var lastValue = NSNotFound
    var emphasizedLabels: [UILabel] = []
    var regularLabels: [UILabel] = []

    // MARK: UIView

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initProperties()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initProperties()
    }

    // clickthrough
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for view in subviews {
            if !view.isHidden &&
                view.alpha > 0.0 &&
                view.isUserInteractionEnabled &&
                view.point(inside: convert(point, to: view), with: event) {
                return true
            }
        }
        return false
    }

    // MARK: TGPCamelLabels

    func initProperties() {
     //   debugNames(count: 10)
      //  debugMinMaxNames(min: 1, max: 10)
        layoutTrack()
    }

    func debugNames(count: Int) {
        // Dynamic property, will create an array with labels, generally for debugging purposes
        var array: [String] = []
        for iterate in 1...count {
            array.append("\(iterate)K")
        }
        names = array
    }
    
    func debugMinMaxNames(min: CGFloat, max: CGFloat) {
        var array: [String] = []
        let commonAddition: CGFloat = (max - min)/9
        for iterate in stride(from: min, to: max, by: commonAddition) {
            array.append("\(removeZeroDecimal(nextValue: Float(iterate/1000)))k")
        }
        array.append("\(removeZeroDecimal(nextValue: Float(max/1000)))k")
        names = array
    }
    
    func removeZeroDecimal(nextValue: Float) -> String {
      var cleanValue = nextValue.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", nextValue) : String(format: "%.1f", nextValue)
        
        if nextValue.truncatingRemainder(dividingBy: 1) == 0 {
            cleanValue = String(format: "%.0f", nextValue)
        } else {
            cleanValue = string(fractionDigits: 2, value: nextValue)
        }
        return cleanValue
    }

    func string(fractionDigits:Int, value: Float) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
//        formatter.roundingMode = .halfEven
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    func layoutTrack() {

        func insetLabel(_ label: UILabel?, withInset inset: NSInteger, andMultiplier multiplier: CGFloat) {
            assert(label != nil)
            if let label = label {
                label.frame = {
                    var frame = label.frame
                    frame.origin.x += frame.size.width * multiplier
                    frame.origin.x += CGFloat(inset)
                    return frame
                }()
            }
        }

        for label in emphasizedLabels {
            label.removeFromSuperview()
        }
        emphasizedLabels = []
        for label in regularLabels {
            label.removeFromSuperview()
        }
        regularLabels = []

        let count = names.count
        if !names.isEmpty {
            var centerX = (bounds.width - (CGFloat(count - 1) * ticksDistance)) / 2.0
            let centerY = bounds.height / 2.0
            for name in names {
                let upLabel = UILabel()
                emphasizedLabels.append(upLabel)
                upLabel.text = name
                upLabel.textColor = UIColor(red: 49 / 255, green: 49 / 255, blue: 49 / 255, alpha: 1)
                upLabel.font = UIFont(name: "Roboto-Medium", size: 10)!
                //upLabel.sizeToFit()
                upLabel.minimumScaleFactor = 0.5
                upLabel.adjustsFontSizeToFitWidth = true
                upLabel.center = CGPoint(x: centerX, y: centerY)
                upLabel.frame = {
                    var frame = upLabel.frame
                    frame.origin.y = bounds.height - frame.height
                    return frame
                }()

                upLabel.alpha = 0.0
                addSubview(upLabel)

                let dnLabel = UILabel()
                regularLabels.append(dnLabel)
                dnLabel.text = name
                
                dnLabel.font = upLabel.font
                dnLabel.sizeToFit()
                dnLabel.adjustsFontSizeToFitWidth = true
                dnLabel.minimumScaleFactor = upLabel.minimumScaleFactor
                
                dnLabel.center = CGPoint(x: centerX, y: centerY)
                dnLabel.textColor = upLabel.textColor
                dnLabel.frame = {
                    var frame = dnLabel.frame
                    frame.origin.y = bounds.height - frame.height
                    return frame
                }()
                addSubview(dnLabel)

                centerX += ticksDistance
            }

            // Fix left and right label, if there are at least 2 labels
            if names.count > 1 {
                insetLabel(emphasizedLabels.first, withInset: insets, andMultiplier: offCenter)
                insetLabel(emphasizedLabels.last, withInset: -insets, andMultiplier: -offCenter)
                insetLabel(regularLabels.first, withInset: insets, andMultiplier: offCenter)
                insetLabel(regularLabels.last, withInset: -insets, andMultiplier: -offCenter)
            }

            //dockEffect(duration:0.0)
        }
    }

    func dockEffect(duration: TimeInterval) {
        let emphasized = Int(value)

        // Unlike the National Parks from which it is inspired, this Dock Effect
        // does not abruptly change from BOLD to plain. Instead, we have 2 sets of
        // labels, which are faded back and forth, in unisson.
        // - BOLD to plain
        // - Black to gray
        // - high to low
        // Each animation picks up where the previous left off
        let moveBlock:() -> Void = {
            // De-emphasize almost all
            for (idx, label) in self.emphasizedLabels.enumerated() where emphasized != idx {
                    self.verticalAlign(aView: label,
                                       alpha: 0,
                                       attribute: self.regularLayoutAttribute)
            }
            for (idx, label) in self.regularLabels.enumerated() where emphasized != idx {
                    self.verticalAlign(aView: label,
                                       alpha: 1,
                                       attribute: self.regularLayoutAttribute)
            }

            // Emphasize the selection
            if emphasized < self.emphasizedLabels.count {
                self.verticalAlign(aView: self.emphasizedLabels[emphasized],
                                   alpha: 1,
                                   attribute: self.emphasisLayoutAttribute)
            }
            if emphasized < self.regularLabels.count {
                self.verticalAlign(aView: self.regularLabels[emphasized],
                                   alpha: 0,
                                   attribute: self.emphasisLayoutAttribute)
            }
        }

        if duration > 0 {
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: [.beginFromCurrentState, .curveLinear],
                           animations: moveBlock,
                           completion: nil)
        } else {
            moveBlock()
        }
    }
    
    func verticalAlign(aView: UIView, alpha: CGFloat, attribute layout: NSLayoutAttribute) {
        switch layout {
        case .top:
            aView.frame = {
                var frame = aView.frame
                frame.origin.y = 0
                return frame
            }()

        case .bottom:
            aView.frame = {
                var frame = aView.frame
                frame.origin.y = bounds.height - frame.height
                return frame
            }()

        default: // .center
            aView.frame = {
                var frame = aView.frame
                frame.origin.y = (bounds.height - frame.height) / 2
                return frame
            }()
        }
        aView.alpha = alpha
    }
}

extension TGPCamelLabels: TGPControlsTicksProtocol {
    
    public func tgpTicksDistanceChanged(ticksDistance: CGFloat, sender: AnyObject) {
        self.ticksDistance = ticksDistance
    }
    
    public func tgpValueChanged(value: CGFloat) {
        print(value)
        self.value = value
        
    }
}
