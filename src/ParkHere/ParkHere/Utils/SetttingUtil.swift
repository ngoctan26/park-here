//
//  SetttingUtil.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 3/10/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation

class SettingUtil {
    
    static func loadSetting(key: String, defaultValue: Any?) -> Any? {
        let defaults = UserDefaults.standard
        guard let returnValue = defaults.object(forKey: key) as? Data else {
            return defaultValue
        }
        return NSKeyedUnarchiver.unarchiveObject(with: returnValue)
    }
    
    static func saveSetting(configurations: [String : Any]) {
        let defaults = UserDefaults.standard
        for (key, object) in configurations {
            let data = NSKeyedArchiver.archivedData(withRootObject: object)
            defaults.set(data, forKey: key)
        }
        defaults.synchronize()
    }
    
    static func removeSetting(key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
}
