//
//  ParkingZoneModel.swift
//  ParkHere
//
//  Created by john on 3/18/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation
import NSDate_TimeAgo

class ParkingZoneModel: NSObject {
    var id: Int?
    var createdAt: Date?
    var imageUrl: URL?
    var rating: Double = 0.0
    var desc: String?
    var longitude: Double?
    var latitude: Double?
    var address: String?
    var transportTypes: [TransportTypeEnum]?
    var timeAgo: String {
        return (createdAt as NSDate?)?.timeAgo() ?? Constant.Empty_String
    }
    var openTime: Int?
    var closeTime: Int?
    
    override init() {}
    
    init(dictionary: NSDictionary) {
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
            let timeFormater = DateFormatter()
            timeFormater.dateFormat = "EEE MMM d HH:mm:ss" // Tue Aug 28 21:16:23
            createdAt = timeFormater.date(from: timestampString)
        }
        
        if let transportTypeStr = dictionary["transport_types"] as? String {
            transportTypes = transportTypeStr.components(separatedBy: Constant.Comma_Char).map {TransportTypeEnum(rawValue: $0)!}
        }
        
        if let workingTime = dictionary["working_time"] as? NSDictionary {
            openTime = workingTime["opening_time"] as? Int
            closeTime = workingTime["closing_time"] as? Int
        }
    }
    
    class func parkingZones(dictionaries: [NSDictionary]) -> [ParkingZoneModel] {
        return dictionaries.map { ParkingZoneModel(dictionary: $0) }
    }
}
