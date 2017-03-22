//
//  GeocodingService.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 3/23/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

class GeocodingService {
    let baseURLString = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    static var sharedInstance: GMapDirectionService = GMapDirectionService()
    
    func getAddress(coordinate: CLLocationCoordinate2D, success: @escaping (_ address: [String]) -> (), failure: @escaping (_ error: Error?) -> ()) {
        var parameters: [String : String] = [:]
        parameters["latlng"] = coordinate.getLocationsAsString()
        parameters["key"] = Constant.Google_Api_key
        let request = Alamofire.request(baseURLString, method: .get, parameters: parameters)
        request.responseJSON { (response) in
            if response.result.isFailure {
                failure(APIError.failedRequest)
                return
            }
            if let _ = response.result.value as? NSNull {
                failure(APIError.wrongFormattedResponse)
                return
            }
            guard let json = response.result.value as? [String : AnyObject] else {
                failure(APIError.wrongFormattedResponse)
                return
            }
            let status = json["status"] as! String
            if status != "OK" {
                failure(APIError.responseStatusNOK)
                return
            }
            guard let jsonResults = json["results"] as? [[String : AnyObject]] else {
                failure(APIError.wrongFormattedResponse)
                return
            }
            var addresses: [String] = []
            for jsonResults in jsonResults {
                if let addressFormatted = jsonResults["formatted_address"] as? String {
                    addresses.append(addressFormatted)
                }
            }
            success(addresses)
        }
    }
}
