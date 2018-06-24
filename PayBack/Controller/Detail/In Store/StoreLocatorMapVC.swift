//
//  StoreLocatorMapVC.swift
//  PayBack
//
//  Created by Dinakaran M on 12/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Contacts
import GoogleMaps
import GooglePlaces
import MapKit
import SDWebImage
import UIKit

class StoreLocatorMapVC: BaseViewController {
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak private var filteredCountLabel: UILabel!
    @IBOutlet weak private var paybackMapView: UIView!
    @IBOutlet weak private var storeImage: UIImageView!
    @IBOutlet weak fileprivate var distanceButton: UIButton!
    @IBOutlet weak fileprivate var locationDetailsView: UIView!
    @IBOutlet weak private var storeEarnPoints: UILabel!
    @IBOutlet weak private var storeMsg: UILabel!
    @IBOutlet weak private var storePlace: UILabel!
    @IBOutlet weak private var storeName: UILabel!
    @IBOutlet weak private var fetchStoreButton: UIButton!
    
    private var filterVC: StoreLocatorFilterVC?
    
    fileprivate let defaultLocation = CLLocation(latitude: CLLocationDegrees(18.5339457), longitude: CLLocationDegrees(73.8269989))
    fileprivate var filterCount = 0
    fileprivate var filteredData: [String: String] = [:]
    
    fileprivate var selectedAnotationLocation: CLLocation?
    fileprivate var currentUserLocation: CLLocation?
    var viewModel: InStoreListVM!
    private var markerModel = [InstoreListTVCellModel]()
    fileprivate var selectedMarkerModel: InstoreListTVCellModel?
    
    @IBAction func distanceButtonAction(_ sender: Any) {
        print("clicked Distance")
        if let currLoc = currentUserLocation, let selectedLoc = selectedAnotationLocation {
            self.showPopover(currentLocation: currLoc, selectedLocation: selectedLoc, sender: sender)
        }
    }
    
    @IBAction func openMap(_ sender: Any) {
        if let url = selectedMarkerModel?.url {
            self.redirectVC(redirectLink: url, redirectLogoUrl: selectedMarkerModel?.imageUrl ?? "")
        }
    }
    @IBAction func fetchStoreAction(_ sender: Any) {
        if self.filterVC == nil {
            guard let filterVC = StoreLocatorFilterVC.storyboardInstance(storyBoardName: "InStore") as? StoreLocatorFilterVC else {
                return
            }
            self.filterVC = filterVC
            filterVC.selectedPartners = {[weak self](filterDict) in
                self?.filteredData = filterDict
                self?.viewModel.filteredData = filterDict
                print(filterDict)
                self?.applyFilter()
            }
            
        }
        filterVC?.filterDataSource = self.viewModel.getFilterModel()
        filterVC?.filteredData = self.filteredData
        self.navigationController?.pushViewController(filterVC!, animated: true)
    }
    
    private func resetMap() {
        self.mapView?.removeFromSuperview()
        self.mapView = nil
        self.originMarker = nil
        self.routePolyLine = nil
        self.destinationPoints = nil
    }
    
    var mapView: GMSMapView!
    var zoomLevel: Float = 13.0
    var dataProvider = GoogleDataProvider()
    var originMarker: GMSMarker!
    var routePolyLine: GMSPolyline!
    var destinationPoints: GoogleDirection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storeName.textColor = ColorConstant.textColorBlack
        self.storeName.font = FontBook.Bold.ofTVCellTitleSize()
        
        self.distanceButton.titleLabel?.textColor = ColorConstant.textColorGray
        self.distanceButton.titleLabel?.font = FontBook.Regular.ofTVCellSubTitleSize()
        
        self.storeMsg.textColor = ColorConstant.textColorGray
        self.storeMsg.font = FontBook.Regular.ofTVCellSubTitleSize()
        
        self.storePlace.textColor = ColorConstant.textColorGray
        self.storePlace.font = FontBook.Regular.ofTVCellSubTitleSize()
        
        self.storeEarnPoints.textColor = ColorConstant.textColorPink
        self.storeEarnPoints.font = FontBook.Regular.ofTVCellSubTitleSize()
        self.filteredCountLabel.textColor = ColorConstant.textColorWhite
        self.filteredCountLabel.backgroundColor = ColorConstant.primaryColorPink
        
        imageContainerView.layer.borderWidth = 1
        imageContainerView.layer.borderColor = UIColor.lightGray.cgColor
        locationDetailsView.isHidden = true
    }
    
    private func setupViews() {
        if let loc = LocationManager.sharedLocationManager.currectUserLocation {
            currentUserLocation = loc
        }
        markerModel = viewModel.getStoreList()
        if markerModel.isEmpty, let currentLoc = currentUserLocation {
            let filter = getFilter()
            fetchData(atLocation: currentLoc, filter: filter)
        }
        self.setupMapView()
        if let currLoc = currentUserLocation {
            setupLocationMarker(coordinate: currLoc.coordinate)
        }
        filterCount = viewModel.filterCount
        filteredCountLabel.text = "\(filterCount)"
        self.filteredCountLabel.isHidden = self.filterCount == 0 ? true : false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadMap()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMap), name: Notification.Name(LocationFound), object: nil)
        self.navigationController?.isNavigationBarHidden = false
    }
    @objc private func reloadMap() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(LocationFound), object: nil)
        self.resetMap()
        setupViews()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(LocationFound), object: nil)
    }
    func setupMapView() {
       
        var mapV = GMSMapView.map(withFrame: paybackMapView.bounds, camera: GMSCameraPosition())
        if let currLoc = currentUserLocation {
            let camera = GMSCameraPosition.camera(withLatitude: currLoc.coordinate.latitude,
                                                  longitude: currLoc.coordinate.longitude,
                                                  zoom: zoomLevel)
            mapV = GMSMapView.map(withFrame: paybackMapView.bounds, camera: camera)
        }
        
        //        mapV.delegate = self
        mapView = mapV
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mapView.isMyLocationEnabled = true
        paybackMapView.addSubview(mapView)
        mapView.isHidden = true
        //        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: self.paybackMapView.center.y + 50, right: 10)
        
        locationDetailsView.isHidden = true
        
        let tagGuesture = UITapGestureRecognizer(target: self, action: #selector(self.showDetailsViewController))
        locationDetailsView.addGestureRecognizer(tagGuesture)
        
    }
    
    @objc func showDetailsViewController() {
        //        let storyBoard = UIStoryboard(name: "InStore", bundle: nil)
        //        let storeDetailVC = storyBoard.instantiateViewController(withIdentifier: "StoreDetailsViewController") as? StoreDetailsVC
        //        self.navigationController?.pushViewController(storeDetailVC!, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func userLogedIn(status: Bool) {
        guard status else {
            return
        }
        if status, let link = redirectUrl, link != "" {
            self.redirectVC(redirectLink: link, redirectLogoUrl: self.partnerlogoUrl)
        } else {
            self.redirectUrl = ""
            self.partnerlogoUrl = ""
        }
    }
    func updateSelectedAnotationDetails(marker: GMSMarker) {
        let location = Location(latitude: "\(marker.position.latitude)", longitude: "\(marker.position.longitude)")
        var markerItemModel: InstoreListTVCellModel?
        for (index, item) in markerModel.enumerated() {
            if let locs = item.storeLocations, let loc = locs.first {
                if loc == location {
                    markerItemModel = markerModel[index]
                    break
                }
            }
        }
        if let model = markerItemModel {
            self.selectedMarkerModel = model
            locationDetailsView.isHidden = false
            storeImage.downloadImageFromUrl(urlString: model.imageUrl ?? "")
            storeMsg.text = model.storeMsg ?? "Earn on your food spends"
            storeName.text = model.storeName ?? "Chaayos"
            if let address = model.storeAddress {
                storePlace.text = address
            } else {
                reverseGeocodeCoordinate(coordinate: marker.position)
            }
            storeEarnPoints.text = model.earnPointMsg ?? ""//Earn upto 8 points per Rs. 100 spent"
            distanceButton.setTitle( model.storeDistance ?? "4 KM", for: .normal)
        }
    }
    deinit {
        print("Deinit - StoreLocatorMapVC")
        NotificationCenter.default.removeObserver(self, name: Notification.Name(LocationFound), object: nil)
    }
    
    // GeoCoder - find address of current location
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { [weak self] response, _ in
            
            guard let address = response?.firstResult() else {
                self?.storePlace.text = ""
                return
            }
            let lines = address.lines
            self?.storePlace.text = lines?.joined(separator: "\n")
            self?.locationDetailsView.layoutIfNeeded()
        }
    }
}

extension StoreLocatorMapVC {
    private func fetchData(atLocation location: CLLocation, filter params: StoreLocaterFilterParameters) {
        viewModel.onSuccess {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {[weak self] in
                self?.markerModel = (self?.viewModel.getStoreList())!
                self?.resetMap()
                self?.setupMapView()
                self?.setupLocationMarker(coordinate: location.coordinate)
                self?.filteredCountLabel.text = "\(self?.viewModel.filterCount ?? 0)"
                self?.filteredCountLabel.isHidden = self?.filterCount == 0 ? true : false
            })
            }
            .onError { (error) in
                print(error)
            }
            .fetchInStoreListNear(currentLocation: location.coordinate, filterParameters: params)
    }
}

// MARK: GMSMapViewDelegate
extension StoreLocatorMapVC: GMSMapViewDelegate {
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        self.mapView.isMyLocationEnabled = true
        if let loc = mapView.myLocation {
            currentUserLocation = loc
            LocationManager.sharedLocationManager.currectUserLocation = loc
        } else {
            currentUserLocation = defaultLocation
        }
        let allFilter = viewModel.getFilterModel()
        for dataSource in allFilter {
            for items in dataSource.value {
                items.state = false
            }
        }
        viewModel.filterCount = 0
        var filteredDataSourse: [String:String] = [:]
        for item in viewModel.getSelectedFilterDataModel() {
            filteredDataSourse[item.key] = ""
        }
        filteredData = filteredDataSourse
        viewModel.filteredData = filteredDataSourse
        if let currLoc = currentUserLocation {
            let filter = getFilter()
            fetchData(atLocation: currLoc, filter: filter)
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let destination = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
        self.locationDetailsView.isHidden = true
        if let currLoc = currentUserLocation {
            drawPath(startLocation: currLoc, endLocation: destination)
        }
        selectedAnotationLocation = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
        //        currentUserLocation = destination
        self.updateSelectedAnotationDetails(marker: marker)
        return false
    }
    
    //    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
    //        let view = Bundle.main.loadNibNamed("InfoWindow", owner: self, options: nil)?[0] as? InfoWindow
    ////        view?.address.text = marker.title //self.destinationPoints?.endAddress
    ////        view?.distance.text = "distance : \(self.destinationPoints?.distance ?? "0")"
    //        view?.backgroundColor = .red
    //        return view!
    ////        return UIView()
    //    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        // showPopover(base: mapView)
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        locationDetailsView.isHidden = true
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
    }
}

// MARK: CLLocationManagerDelegate
extension StoreLocatorMapVC: CLLocationManagerDelegate {
    
    func setupLocationMarker(coordinate: CLLocationCoordinate2D) {
        if originMarker != nil {
            originMarker.map = nil
        }
//        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
//                                              longitude: coordinate.longitude,
//                                              zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            //mapView.camera = camera
        } else {
            //mapView.animate(to: camera)
        }
        fetchNearbyPlaces(coordinate:coordinate)
        //        originMarker = GMSMarker(position: coordinate)
        //        originMarker.map = mapView
        //        originMarker.icon = #imageLiteral(resourceName: "anotationicon")
        
        /* let circle = GMSCircle.init(position: camera.target, radius: 0)
         circle.fillColor = UIColor.clear // UIColor(patternImage: UIImage(named: "currentlocation")!) //
         circle.strokeWidth = 0
         circle.strokeColor = UIColor.clear
         circle.map = mapView
         */
    }
    
}
// MARK: Customfuction
extension StoreLocatorMapVC {
    func drawPath(startLocation: CLLocation, endLocation: CLLocation) {
        dataProvider.fetchDirection(startLocation: startLocation, endLocation: endLocation) {[weak self] (directionPoints) in
            if self?.destinationPoints != nil {
                self?.destinationPoints = nil
            }
            self?.destinationPoints = directionPoints
            
            DispatchQueue.main.async { [weak self] in
                if self?.routePolyLine != nil {
                    self?.routePolyLine.map = nil
                }
                let path = GMSPath(fromEncodedPath: directionPoints.points!)
                self?.routePolyLine = GMSPolyline(path: path)
                self?.routePolyLine.strokeWidth = 6
                self?.routePolyLine.strokeColor = UIColor(red: 238 / 255, green: 0 / 255, blue: 107 / 255, alpha: 1.0)
                self?.routePolyLine.map = self?.mapView
                
                //                let styles = [GMSStrokeStyle.solidColor(.clear),
                //                              GMSStrokeStyle.solidColor(.red)]
                //                let scale = 1.0 / (self?.mapView.projection.points(forMeters: 1, at: (self?.mapView.camera.target)!))!
                //                let lengths: [NSNumber] = [NSNumber(value: Float(5 * scale)), NSNumber(value: Float(5.0 * scale))]
                //
                //                self?.routePolyLine.spans = GMSStyleSpans((self?.routePolyLine.path!)!, styles, lengths, GMSLengthKind.rhumb)
            }
        }
    }
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        var bounds = GMSCoordinateBounds()
        DispatchQueue.main.async { [weak self] in
            for place: InstoreListTVCellModel in (self?.markerModel)! {
                guard let locations = place.storeLocations else {
                    return
                }
                
                for location in locations {
                    guard let lat = location.latitude, let latitude = Double(lat), let long = location.longitude, let longitude = Double(long) else {
                        return
                    }
                    let loc = CLLocation(latitude: latitude, longitude: longitude)
                    let marker = GMSMarker(position: loc.coordinate)
                    marker.title = place.storeName
                    
                    //                        marker.snippet = place.storeAddress ?? ""
                    marker.map = self?.mapView
                    marker.infoWindowAnchor = CGPoint(x: 0.44, y: 0.45)
                    bounds = bounds.includingCoordinate(marker.position)
                }
                
                //                    let anotationImage = UIImageView(image: #imageLiteral(resourceName: "anotationicon"))
                //                    anotationImage.frame = CGRect(x: 0, y: 0, width: 35, height: 40)
                //
                //                    let imageView = UIImageView(image: #imageLiteral(resourceName: "anotationicon"))
                //                    imageView.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
                ////                    imageView.sd_setImage(with: URL(string: place.iconReference!), placeholderImage: #imageLiteral(resourceName: "anotationicon"))
                //                    anotationImage.addSubview(imageView)
                //                    imageView.center = anotationImage.center
                //
                //                    marker.iconView = anotationImage
                
            }
            let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
            self?.mapView.animate(with: update)
        }
    }
}

extension StoreLocatorMapVC {
    private func applyFilter() {
        if let currLoc = currentUserLocation {
            let filter = getFilter()
            fetchData(atLocation: currLoc, filter: filter)
        }
    }
    
    private func getFilter() -> StoreLocaterFilterParameters {
        let filteredData = self.viewModel.getSelectedFilterDataModel()
        let category = filteredData[StoreLocaterFilterKey.category.rawValue]
        let city = filteredData[StoreLocaterFilterKey.city.rawValue]
        let partner = filteredData[StoreLocaterFilterKey.partner.rawValue]
        let filter = StoreLocaterFilterParameters(category: category, city: city, partner: partner)
        if let catcount = category?.components(separatedBy: ",").count, let parcount = partner?.components(separatedBy: ",").count, let cicount = city?.components(separatedBy: ",").count {
            let a = (city?.isEmpty)! ? 0 :cicount
            let b = (category?.isEmpty)! ? 0 :catcount
            let c = (partner?.isEmpty)! ? 0 :parcount
            filterCount = a + b + c
            viewModel.filterCount = filterCount
        }
        return filter
    }
}
