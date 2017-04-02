//
//  SettingCellDelegate.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 4/1/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation

protocol SettingCellDelegate: class {
    func onTransportChanged(type: TransportTypeEnum)
    func onTimeChanged(openTime: String?, closedTime: String?)
    func onDistanceChanged(radius: Float)
}
