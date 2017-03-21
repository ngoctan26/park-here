//
//  UserModel.swift
//  ParkHere
//
//  Created by john on 3/18/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation

class UserModel: NSObject {
    var id: Int?
    var isAnonymous: Bool?
    
    override init() {}
    
    init(dictionary: NSDictionary) {
        isAnonymous = dictionary["is_anonymous"] as? Bool ?? false
    }
}
