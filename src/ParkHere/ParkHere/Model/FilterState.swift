//
//  FilterState.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 3/26/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation

enum FilterState: Int {
    case None = 0
    case Transport_Bike = 1
    case Transport_Car = 2
    case Transport_Moto = 3
    case Price = 4
    case Nearest = 5
    case Rating = 6
}
