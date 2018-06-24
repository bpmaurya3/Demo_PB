//
//  GoogleDirection.swift
//  PayBack
//
//  Created by Dinakaran M on 14/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import SwiftyJSON
import UIKit

class GoogleDirection: NSObject {
    
    let routeOverviewPolyline: [String:JSON]?
    let points: String?
    let distance: String?
    let duration: String?
    let startAddress: String?
    let endAddress: String?
    let startLocation_lat: String?
    let startLocation_lng: String?
    let endLocation_lat: String?
    let endLocation_lng: String?
    
    init(routeDirection: JSON) {
        routeOverviewPolyline = routeDirection["overview_polyline"].dictionary
        points = (routeOverviewPolyline?["points"]?.stringValue)!
        let legs = routeDirection["legs"].arrayValue
        let leg = legs[0]
        distance = leg["distance"]["text"].stringValue
        duration = leg["duration"]["text"].stringValue
        startAddress = leg["start_address"].stringValue
        endAddress = leg["end_address"].stringValue
        startLocation_lat = String(leg["start_location"]["lat"].doubleValue)
        startLocation_lng = String(leg["start_location"]["lng"].doubleValue)
        endLocation_lat = String(leg["end_location"]["lat"].doubleValue)
        endLocation_lng = String(leg["end_location"]["lng"].doubleValue)
        
    }
}
