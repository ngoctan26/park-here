//
//  GMapDirectionService.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 3/13/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation
import Alamofire

class GMapDirectionService {
    let baseURLString = "https://maps.googleapis.com/maps/api/directions/json"
    
    /**
        Get direction from origin to destination
        - parameter origin: The address, textual latitude/longitude value, or place ID from which you wish to calculate directions.
        - parameter destination: The address, textual latitude/longitude value, or place ID to which you wish to calculate directions.
    */
    func getDirection(origin: String, destination: String, success: @escaping (_ route: GMapRoute) -> (), failure: @escaping (_ error: Error?) -> ()) {
        var parameters: [String : Any] = [:]
        parameters["origin"] = origin
        parameters["destination"] = destination
        parameters["waypoints"] = "optimize:true"
        parameters["key"] = Constant.Google_Api_key
        
        Alamofire.request(baseURLString, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isFailure {
                return
            }
            if let _ = response.result.value as? NSNull {
                return
            }
            guard let json = response.result.value as? [String : AnyObject] else {
                return
            }
            let status = json["status"] as! String
            if status != "OK" {
                return
            }
            guard let jsonRoute = json["routes"] as? [String : AnyObject] else {
                return
            }
            let resultRoute = GMapRoute(routeResponse: jsonRoute)
            success(resultRoute)
        }
    }
}
