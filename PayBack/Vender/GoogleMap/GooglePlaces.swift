//
//  GooglePlaces.swift
//  PayBack
//
//  Created by Dinakaran M on 14/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
import GooglePlaces
import SwiftyJSON
class GooglePlace: NSObject {
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let placeType: String
    var photoReference: String?
    var photo: UIImage?
    var icon: UIImage?
    var iconReference: String?
    
    init(dictionary: [String: AnyObject], acceptedTypes: [String]) {
        let json = JSON(dictionary)
        name = (json["name"].stringValue)
        address = (json["vicinity"].stringValue)
        iconReference = json["icon"].stringValue
        let lat = json["geometry"]["location"]["lat"].doubleValue as CLLocationDegrees
        let lng = json["geometry"]["location"]["lng"].doubleValue as CLLocationDegrees
        coordinate = CLLocationCoordinate2DMake(lat, lng)
        photoReference = json["photos"][0]["photo_reference"].string
        var foundType = "restaurant"
        let possibleTypes = !acceptedTypes.isEmpty ? acceptedTypes : ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
        for type in (json["types"].arrayObject as? [String])! {
            if possibleTypes.contains(type) {
                foundType = type
                break
            }
        }
        placeType = foundType
    }
}
