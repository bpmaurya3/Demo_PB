//
//  LocationManager.swift
//  PayBack
//
//  Created by valtechadmin on 4/26/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation
import MapKit

class LocationManager: NSObject {
    
    static let sharedLocationManager = LocationManager()
    var currectUserLocation: CLLocation!
    var isLocationEnabled: Bool = false
    private var locationManager = CLLocationManager()
    
//    override init() {
//        super.init()
//        initializeLocationManager()
//    }
    
     func initializeLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 5000
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func loacationServiceEnabled() -> Bool {
        guard CLLocationManager.locationServicesEnabled() else {
            return false
        }
        return [.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus())
    }
    
    func openLocationSetting() {
        if !LocationManager.sharedLocationManager.isLocationEnabled {
            if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                // If general location settings are disabled then open general location settings
                UIApplication.shared.openURL(url)
            }
        } else {
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                UIApplication.shared.openURL(settingsURL as URL)
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("CurrentLoc: \(location.coordinate)")
            currectUserLocation = location
            NotificationCenter.default.post(name: NSNotification.Name(LocationFound), object: nil)
        }
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
            isLocationEnabled = false
            currectUserLocation = nil
        case .denied:
            print("User denied access to location.")
            isLocationEnabled = false
            currectUserLocation = nil
            // Display the map using the default location.
        //            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
            isLocationEnabled = false
            currectUserLocation = nil
        case .authorizedAlways:
            isLocationEnabled = true
            fallthrough
        case .authorizedWhenInUse:
            isLocationEnabled = true
            print("Location status is OK.")
        }
    }
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
