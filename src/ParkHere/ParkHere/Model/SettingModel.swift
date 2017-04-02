//
//  SettingModel.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 4/2/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation

class SettingModel {
    // Default setting
    static let Transport_Type = TransportTypeEnum.All
    static let Open_Time = "06:00"
    static let Closed_Time = "23:00"
    static let Radius_Query: Float = 2.0
    
    var openTime: String?
    var closedTime: String?
    var transportType: TransportTypeEnum?
    var radius: Float?
    
    var isChanged = false
    
    init(type: TransportTypeEnum?, openTime: String?, closedTime: String?, radius: Float?) {
        self.transportType = type
        self.openTime = openTime
        self.closedTime = closedTime
        self.radius = radius
    }
}
