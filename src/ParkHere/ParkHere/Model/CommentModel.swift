//
//  CommentModel.swift
//  ParkHere
//
//  Created by john on 3/18/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation
import NSDate_TimeAgo

class CommentModel: NSObject {
    var id: Int?
    var createdAt: Date?
    var imageUrl: URL?
    var parkingZoneId: String?
    var rating: Double?
    var text: String?
    var longitude: Double?
    var latitude: Double?
    var userId: String?
    var timeAgo: String {
        return (createdAt as NSDate?)?.timeAgo() ?? Constant.Empty_String
    }
    
    var timestamp: TimeInterval?
    
    override init() {}
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        rating = dictionary["rating"] as? Double
        userId = dictionary["user_id"] as? String
        parkingZoneId = dictionary["parking_zone_id"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        imageUrl = imageURLString != nil ? URL(string: imageURLString!)! : nil
        
        let coordinate = dictionary["coordinate"] as? NSDictionary
        if coordinate != nil {
            latitude = coordinate?["latitude"] as? Double
            longitude = coordinate?["longitude"] as? Double
        }
        
        if let timestampString = dictionary["created_at"] as? String {
            let timeFormater = DateFormatter()
            timeFormater.dateFormat = "EEE MMM d HH:mm:ss" // Tue Aug 28 21:16:23
            createdAt = timeFormater.date(from: timestampString)
        }
        
        timestamp = dictionary["timestamp"] as? TimeInterval
    }
    
    class func comments(dictionaries: [NSDictionary]) -> [CommentModel] {
        let result = dictionaries.map { CommentModel(dictionary: $0) }
        return result.sorted(by: { (firstComment, secondComment) -> Bool in
            return firstComment.timestamp! < secondComment.timestamp!
        })
    }
}
