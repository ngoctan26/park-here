//
//  GMapRoute.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 3/18/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation
import CoreLocation

class GMapRoute {
    var routeAsPoints: String!
    
    init (routeResponse: [String: AnyObject]) {
        let overViewPolyline = routeResponse["overview_polyline"] as! Dictionary<String, AnyObject>
        routeAsPoints = overViewPolyline["points"] as! String
        let legs = routeResponse["legs"] as! Array<Dictionary<String, AnyObject>>
        let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
        let originCoordinate = CLLocationCoordinate2D(latitude: startLocationDictionary["lat"] as! Double, longitude: startLocationDictionary["lng"] as! Double)
        let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
        let endCoordinate = CLLocationCoordinate2D(latitude: endLocationDictionary["lat"] as! Double, longitude: endLocationDictionary["lng"] as! Double)
    }
}
