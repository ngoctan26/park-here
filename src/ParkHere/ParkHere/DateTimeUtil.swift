//
//  DateTimeUtil.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 3/25/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation

class DateTimeUtil {
    static let timeFormater = DateFormatter()
    static let Date_Format_Default = "EEE MMM d HH:mm:ss"
    static let Time_Format_Default = "HH:mm"
    
    static func dateFromString(dateAsString: String) -> Date? {
        timeFormater.dateFormat = Date_Format_Default
        return timeFormater.date(from: dateAsString)
    }
    
    static func stringFromDate(date: Date) -> String? {
        timeFormater.dateFormat = Date_Format_Default
        return timeFormater.string(from: date)
    }
    
    static func dateFromString(dateAsString: String, format: String) -> Date? {
        timeFormater.dateFormat = format
        return timeFormater.date(from: dateAsString)
    }
    
    static func stringFromDate(date: Date, format: String) -> String? {
        timeFormater.dateFormat = format
        return timeFormater.string(from: date)
    }
}
