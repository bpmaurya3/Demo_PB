//
//  InstoreListTVCell.swift
//  PayBack
//
//  Created by Dinakaran M on 12/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMaps
import MapKit

class InstoreListTVCell: UITableViewCell {

    var distanceActionClosure: ((UIButton) -> Void) = { _ in }
    
    @IBOutlet weak private var containerView: UIView!
    @IBAction func distanceAction(_ sender: UIButton) {
        print("Map Icon Clicked \(sender.tag)")
        self.distanceActionClosure(sender)
    }
    
    @IBOutlet weak fileprivate var distanceButton: UIButton!
    @IBOutlet weak private var StoreImage: UIImageView!
    @IBOutlet weak private var StoreEarnPoints: UILabel!
    @IBOutlet weak private var StoreMessage: UILabel!
    @IBOutlet weak private var StoreName: UILabel!
    @IBOutlet weak private var StorePlace: UILabel!
    @IBOutlet weak private var imageBorderView: UIView!
    @IBOutlet weak var addressHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    fileprivate let overlayView: UIView = {
        let overlayView = UIView(frame: .zero)
        overlayView.backgroundColor = UIColor(hex: "000000")
        overlayView.alpha = 0.7
        return overlayView
    }()
    var isOfferZone = false
    var sourceData: InstoreListTVCellModel? {
        didSet {
            guard let sourceData = sourceData else {
                return
            }
            self.parseData(forInstoreListItems: sourceData)
        }
    }
    var offerCellModel: CouponsRechargeCellModel? {
        didSet {
            guard let cellModel = offerCellModel else {
                return
            }
            self.parseOffersData(inStoreListData: cellModel)
        }
    }
    private func parseOffersData(inStoreListData: CouponsRechargeCellModel) {
       
        if let imageurl = inStoreListData.thumbnailPath {
            StoreImage.downloadImageFromUrl(urlString: imageurl)
        }
        
        self.distanceButton.setImage(#imageLiteral(resourceName: "kilometer"), for: .normal)
        
        if let earnPointMsg = inStoreListData.termsAndCondition {
            self.StoreEarnPoints.text = earnPointMsg
        }
        //        self.StoreEarnPoints.text = ""
        if let storeMsg = inStoreListData.subTitle {
            self.StoreMessage.text = storeMsg
        }
        //        self.StoreMessage.text = ""
        if let name = inStoreListData.title {
            self.StoreName.text = name
        }
        if let distance = inStoreListData.storeDistance {
            self.distanceButton.setTitle(distance, for: .normal)
        }
        self.addressHeightConstraint.constant = 0
        self.overlayView.isHidden = true
    }
    private func parseData(forInstoreListItems InStoreListData: InstoreListTVCellModel) {
        if let image = InStoreListData.image {
            StoreImage.image = image
        }
        if let imageurl = InStoreListData.imageUrl {
            StoreImage.downloadImageFromUrl(urlString: imageurl)
        }
        if let icon = InStoreListData.mapIcon {
            self.distanceButton.setImage(icon, for: .normal)
        }
        if let earnPointMsg = InStoreListData.earnPointMsg {
            self.StoreEarnPoints.text = earnPointMsg
        }
//        self.StoreEarnPoints.text = ""
        if let storeMsg = InStoreListData.storeMsg {
            self.StoreMessage.text = storeMsg
        }
//        self.StoreMessage.text = ""
        if let name = InStoreListData.storeName {
            self.StoreName.text = name
        }
        if let distance = InStoreListData.storeDistance {
            self.distanceButton.setTitle(distance, for: .normal)
        }
        if !isOfferZone {
            guard let storePlace = InStoreListData.storeAddress, storePlace != "" else {
                self.StorePlace.text = ""
                if let location = InStoreListData.storeLocations?.first {
                    if let lat = location.latitude as NSString?, let long = location.longitude as NSString? {
                        let loc = CLLocation(latitude: lat.doubleValue as CLLocationDegrees, longitude: long.doubleValue as CLLocationDegrees)
                        reverseGeocodeCoordinate(coordinate: loc.coordinate)
                    }
                }
                return
            }
            self.StorePlace.text = storePlace
        } else {
            self.addressHeightConstraint.constant = 0
        }
        
        if let display = InStoreListData.isOverLayDisplay {
            self.overlayView.isHidden = !display
        } else {
            self.overlayView.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.StoreImage.image = nil
        self.overlayView.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.backgroundColor = .white
        
        self.imageBorderView.layer.borderWidth = 1
        self.imageBorderView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.StoreName.textColor = ColorConstant.textColorBlack
        self.StoreName.font = FontBook.Bold.ofTVCellTitleSize()
        
        self.distanceButton.titleLabel?.textColor = ColorConstant.textColorGray
        self.distanceButton.titleLabel?.font = FontBook.Regular.ofTVCellSubTitleSize()
        
        self.StoreMessage.textColor = ColorConstant.textColorGray
        self.StoreMessage.font = FontBook.Regular.ofTVCellSubTitleSize()
        
        self.StorePlace.textColor = ColorConstant.textColorGray
        self.StorePlace.font = FontBook.Regular.ofTVCellSubTitleSize()
        
        self.StoreEarnPoints.textColor = ColorConstant.textColorPink
        self.StoreEarnPoints.font = FontBook.Regular.ofTVCellSubTitleSize()
        
        addSubview(overlayView)
        self.overlayView.isHidden = true
        self.addConstraintsWithFormat("H:|[v0]|", views: overlayView)
        self.addConstraintsWithFormat("V:|[v0]|", views: overlayView)
    }
    deinit {
        print("Denit - InstoreListTVCell ")
    }
}
extension InstoreListTVCell {
    @discardableResult
    func set(distanceButtonTag tag: Int) -> Self {
        self.distanceButton.tag = tag
        
        return self
    }
    
    // GeoCoder - find address of current location
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { [weak self] response, _ in
           
            guard let address = response?.firstResult() else {
                self?.StorePlace.text = ""
                return
            }
            let lines = address.lines
            self?.StorePlace.text = lines?.joined(separator: "\n")
            self?.sourceData?.storeAddress = lines?.joined(separator: "\n")
        }
    }
}
class InstoreListTVCellModel: NSObject {
    var imageUrl: String?
    var earnPointMsg: String?
    var storeMsg: String?
    var storeName: String?
    var storeDistance: String?
    var storeAddress: String?
    var mapIcon: UIImage?
    var storeLocations: [Location]?
    var isOverLayDisplay: Bool?
    var image: UIImage?
    var url: String?
    
    init(storeLogo: UIImage, earnPointMessage: String? = "Earn upto 8 points per Rs. 100 spent", storeMsg: String? = "Earn on your daily spends", storeName: String, storeDistance: String, storeAddress: String, mapIcon: UIImage? = UIImage(named: "kilometer"), location: [Location]? = nil, isOverLayDisplay: Bool) {
        self.image = storeLogo
        self.earnPointMsg = earnPointMessage
        self.storeMsg = storeMsg
        self.storeName = storeName
        self.storeDistance = storeDistance
        self.storeAddress = storeAddress
        self.mapIcon = mapIcon
        self.storeLocations = location
        self.isOverLayDisplay = isOverLayDisplay
    }
    init(withStoreDeal deal: InstoreListModel.Deals) {
        super.init()
        self.imageUrl = deal.image
        self.storeName = deal.brand
        self.earnPointMsg = deal.description
        self.storeMsg = deal.title
        let distance = deal.distance?.rounded(toPlaces: 1)
        self.storeDistance = distance != 1.0 || distance != 0 ? "\(distance!) Kms" : "\(distance!) Km"
        self.storeLocations = deal.locations
        self.url = deal.url
        if let location = deal.locations?.first {
            if let lat = location.latitude as NSString?, let long = location.longitude as NSString? {
                let loc = CLLocation(latitude: lat.doubleValue as CLLocationDegrees, longitude: long.doubleValue as CLLocationDegrees)
                reverseGeocodeCoordinate(coordinate: loc.coordinate)
            }
        }
    }
    // GeoCoder - find address of current location
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { [weak self] response, _ in
            
            guard let address = response?.firstResult() else {
                return
            }
            let lines = address.lines
            self?.storeAddress = lines?.joined(separator: "\n")
        }
    }
}
extension InstoreListTVCell {
    @discardableResult
    func update(containerBottomContraint constant: CGFloat) -> Self {
        self.containerViewBottomConstraint.constant = constant
        
        return self
    }
}
