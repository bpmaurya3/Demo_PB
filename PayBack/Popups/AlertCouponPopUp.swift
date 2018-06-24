//
//  AlertCouponPopUp.swift
//  PaybackPopup
//
//  Created by Mohsin.Surani on 18/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//
import QuartzCore
import UIKit

class AlertCouponPopUp: UIView, UIGestureRecognizerDelegate {

    @IBOutlet weak private var TitleLabel: UILabel!
    @IBOutlet weak private var CloseButton: UIButton!
    @IBOutlet weak private var DescriptionLabel: UILabel!
    @IBOutlet weak private var CodeLabel: UILabel!
    @IBOutlet weak private var CopyButton: UIButton!
    @IBOutlet weak private var InstructionLabel: UILabel!
    @IBOutlet weak private var popUpCouponView: UIView!
    
    func setTitleLabel(couponDecsreption: String) {
        self.DescriptionLabel.text = couponDecsreption
    }
    func setCouponCode(code: String) {
        self.CodeLabel.text = code
    }
    var copyOfferActionHandler: ((String) -> Void )?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async { [weak self] in
            self?.CodeLabel.layer.addDashedBorder(strokeColor: UIColor(hex: "acacac"), lineWidth: 1)
        }
        addGesture()
        DescriptionLabel.font = FontBook.Roboto.of(size: 11)
        DescriptionLabel.textColor = ColorConstant.couponCodeTextColor
        self.DescriptionLabel.text = ""

        TitleLabel.font = FontBook.Roboto.of(size: 15)
        TitleLabel.textColor = ColorConstant.textColorWhite

        CodeLabel.font = FontBook.Bold.of(size: 12)
        CodeLabel.textColor = ColorConstant.couponCodeTextColor
        
        CopyButton.titleLabel?.font = FontBook.Roboto.of(size: 13)
        CopyButton.titleLabel?.textColor = ColorConstant.textColorWhite
        CopyButton.backgroundColor = ColorConstant.buttonBackgroundColorPink
        
        InstructionLabel.font = FontBook.Arial.of(size: 10)
        InstructionLabel.textColor = ColorConstant.couponPopupInstructionTextColor
    }
    
    func initWithConfiguration(configuration: PopUpConfiguration) {
        
        setAllValues(title: configuration.titleCouponString, Description: configuration.descriptionCouponString, OfferCode: configuration.offerCouponString, CopyString: configuration.copyCodeString, InstructionString: configuration.instructionString)
        
        setAllColors(titleBackgroundColor: configuration.titleBackGroundColor, copyBackgroundColor: configuration.copyBackColor, instructionBackColor: configuration.instructionBackColor, popUpBackColor: configuration.popCouponBackgroundColor)
        
        setHideShowUI(hideInstruction: configuration.hideInstruction, hideClose: configuration.hideClose, hideDescription: configuration.hideDescriptionCoupon, hideCopyButton: configuration.hideCopy)
    }
    
   private func setAllValues(title: String, Description: String, OfferCode: String, CopyString: String, InstructionString: String) {
        
        TitleLabel.text = title
        DescriptionLabel.text = Description
        CodeLabel.text = OfferCode
        InstructionLabel.text = InstructionString.subString(upto: 100)
        self.CopyButton.setTitle(CopyString.uppercased(), for: .normal)
    }
    
    private func setAllColors(titleBackgroundColor: UIColor, copyBackgroundColor: UIColor, instructionBackColor: UIColor, popUpBackColor: UIColor) {
        
        CopyButton.backgroundColor = copyBackgroundColor
        InstructionLabel.backgroundColor = instructionBackColor
        TitleLabel.backgroundColor = titleBackgroundColor
        popUpCouponView.backgroundColor = popUpBackColor
    }
    
     private func setHideShowUI(hideInstruction: Bool, hideClose: Bool, hideDescription: Bool, hideCopyButton: Bool) {
        
        InstructionLabel.isHidden = hideInstruction
        CloseButton.isHidden = hideClose
        DescriptionLabel.isHidden = hideDescription
        CopyButton.isHidden = hideCopyButton
    }
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: .tapGestureActionForAlertCouponPopUp)
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
    @objc func tapGestureAction(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    @IBAction func copyOfferCodeClicked(_ sender: UIButton) {
        if CodeLabel.text != "" {
            sender.isUserInteractionEnabled = false
            if let handler = self.copyOfferActionHandler {
                handler(CodeLabel.text ?? "")
            }
            UIPasteboard.general.string = CodeLabel.text
            CopyButton.setTitle("Copied", for: .normal)
        }
    }
    
    @IBAction func closeCouponPopUp(_ sender: Any) {
         self.removeFromSuperview()
    }
    
    deinit {
        print(" AlertCouponPopUp deinit called")
    }
}
