//
//  Localizator.swift
//  ParkHere
//
//  Created by john on 3/12/17.
//  Copyright © 2017 dtp. All rights reserved.
//

import Foundation

class LocalizatorUtil {
    
    static let sharedInstance = LocalizatorUtil()
    
    lazy var localizableDictionary: NSDictionary! = {
        if let path = Bundle.main.path(forResource: Constant.Multilingual_File_Name, ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("MultilingualData file NOT found")
    }()
    
    func localize(key: String) -> String {
        let localizedString = localizableDictionary.value(forKey: key) as! String
        
        guard !localizedString.isEmpty else {
            assertionFailure("Missing translation for: \(key)")
            return Constant.Empty_String
        }
        
        return localizedString
    }
}

extension String {
    var localized: String {
        return LocalizatorUtil.sharedInstance.localize(key: self)
    }
}

