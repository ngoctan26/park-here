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
    var totalDistance: Int! // In meters
    var totalDuration: Int! // In seconds
    
    init (routeResponse: [String: AnyObject]) {
        let overViewPolyline = routeResponse["overview_polyline"] as! Dictionary<String, AnyObject>
        routeAsPoints = overViewPolyline["points"] as! String
        let legs = routeResponse["legs"] as! Array<Dictionary<String, AnyObject>>
        calulateDistanceAndDuration(legs: legs)
    }
    
    private func calulateDistanceAndDuration(legs: [[String : AnyObject]]) {
        var totalDistanceInMeters = 0
        var totalDurationInSeconds = 0
        for leg in legs {
            totalDistanceInMeters += (leg["distance"] as! Dictionary<String, AnyObject>)["value"] as! Int
            totalDurationInSeconds += (leg["duration"] as! Dictionary<String, AnyObject>)["value"] as! Int
        }
        totalDistance = totalDistanceInMeters
        totalDuration = totalDurationInSeconds
    }
    
    func getDistanceInKm() -> Double {
        return Double(totalDistance / 1000)
    }
}
