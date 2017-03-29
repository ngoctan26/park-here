//
//  ParkingZoneModel.swift
//  ParkHere
//
//  Created by john on 3/18/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation
import NSDate_TimeAgo
import GoogleMaps

class ParkingZoneModel: NSObject {
    var name: String?
    var id: String?
    var createdAt: String?
    var imageUrl: URL?
    var rating: Double = 0.0
    var desc: String?
    var longitude: Double?
    var latitude: Double?
    var address: String?
    var transportTypes: [TransportTypeEnum]?
    var timeAgo: String {
        let createdAtDate = DateTimeUtil.dateFromString(dateAsString: createdAt!)
        return (createdAtDate as NSDate?)?.timeAgo() ?? Constant.Empty_String
    }
    var openTime: String?
    var closeTime: String?
    var markerRef: Int?
    var prices: [String]?
    
    override init() {}
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        desc = dictionary["description"] as? String
        address = dictionary["address"] as? String
        
        if let imageURLString = dictionary["image_url"] as? String {
            imageUrl = URL(string: imageURLString)
        }
        
        
        if let coordinate = dictionary["coordinate"] as? NSDictionary {
            latitude = coordinate["latitude"] as? Double
            longitude = coordinate["longitude"] as? Double
        }
        
        if let timestampString = dictionary["created_at"] as? String {
            createdAt = timestampString
        }
        
        if let transportTypeStr = dictionary["transport_types"] as? String {
            transportTypes = transportTypeStr.components(separatedBy: Constant.Comma_Char).map {TransportTypeEnum(rawValue: $0)!}
        }
        if let priceStr = dictionary["prices"] as? String {
            prices = priceStr.components(separatedBy: Constant.Comma_Char)
        }
        
        if let ratingRaw = dictionary["rating"] as? Double {
            rating = ratingRaw
        }
        
        if let workingTime = dictionary["working_time"] as? NSDictionary {
            openTime = workingTime["opening_time"] as? String
            closeTime = workingTime["closing_time"] as? String
        }
    }
    
    class func parkingZones(dictionaries: [NSDictionary]) -> [ParkingZoneModel] {
        return dictionaries.map { ParkingZoneModel(dictionary: $0) }
    }
}
