//
//  GoogleDataProvider.swift
//  PayBack
//
//  Created by Dinakaran M on 14/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
import GooglePlaces
import SwiftyJSON

class GoogleDataProvider: NSObject {
    
    var photoCache = [String: UIImage]()
    var iConCache = [String: UIImage]()
    var placesTask: URLSessionDataTask?
    var session: URLSession {
        return URLSession.shared
    }
    // MARK: Fetch Near by Coordinates
    func fetchPlacesNearCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, types: [String], completion: @escaping (([GooglePlace]) -> Void)) {
        var urlString =  "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&key=\(providerAPIKey)&sensor=true"
        
        let typesString = !types.isEmpty ? types.joined(separator: "|") : "hospital"
        urlString += "&types=\(typesString)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
            task.cancel()
        }
       // UIApplication.shared.isNetworkActivityIndicatorVisible = true
        placesTask = session.dataTask(with: NSURL(string: urlString)! as URL) {data, _, error in
        //UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var placesArray = [GooglePlace]()
            if let aData = data {
                do {
                    let json = try JSON(data: aData, options: JSONSerialization.ReadingOptions.mutableContainers)
                    if let results = json["results"].arrayObject as? [[String : AnyObject]] {
                        for rawPlace in results {
                            let place = GooglePlace(dictionary: rawPlace, acceptedTypes: types)
                            placesArray.append(place)
                        }
                    }
                } catch let error {
                    print("\(error.localizedDescription)")
                }
            }
            DispatchQueue.main.async {
                completion(placesArray)
            }
        }
        placesTask?.resume()
    }
    
    // MARK: Fetch Direction Path
    func fetchDirection(startLocation: CLLocation, endLocation: CLLocation, completion: @escaping((GoogleDirection) -> Void)) {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let str  = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        let url = URL(string: str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, _, _) in
            var placeDirection: GoogleDirection?
            if let data = data {
                do {
                    let json = try JSON(data:data)
                    let routes = json["routes"].arrayValue
                    if !routes.isEmpty {
                        let route = routes[0]
                        placeDirection = GoogleDirection(routeDirection: route)
                        DispatchQueue.main.async {
                            completion(placeDirection!)
                        }
                    }
                } catch let error {
                    print("\(error.localizedDescription)")
                }
            }
            
        }).resume()
  }
}
