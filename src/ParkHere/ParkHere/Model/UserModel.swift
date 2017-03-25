//
//  UserModel.swift
//  ParkHere
//
//  Created by john on 3/18/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation
import GoogleSignIn

class UserModel: NSObject, NSCoding {
    var id: String?
    var name: String?
    var email: String?
    var avatar: URL?
    var isAnonymous: Bool?
    
    override init() {
        id = "0"
        isAnonymous = false
    }
    
    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObject(forKey: "userid") as? String
        self.name = decoder.decodeObject(forKey: "username") as? String
        self.email = decoder.decodeObject(forKey: "useremail") as? String
        self.avatar = decoder.decodeObject(forKey: "useravatar") as? URL
        self.isAnonymous = decoder.decodeObject(forKey: "useranonymous") as? Bool
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "userid")
        coder.encode(name, forKey: "username")
        coder.encode(email, forKey: "useremail")
        coder.encode(avatar, forKey: "useravatar")
        coder.encode(isAnonymous, forKey: "useranonymous")
    }
    
    init(googleUser: GIDGoogleUser) {
        id = googleUser.userID
        email = googleUser.profile.email
        name = googleUser.profile.name
        avatar = googleUser.profile.hasImage ? googleUser.profile.imageURL(withDimension: 64) : nil
        isAnonymous = false
    }
    
    static var _currentUser: UserModel?
    class var currentUser: UserModel?{
        get{
            if _currentUser == nil {
                if let userData = SettingUtil.loadSetting(key: "currentUserData", defaultValue: nil){
                    _currentUser = userData as? UserModel
                } else {
                    _currentUser = nil
                }
            }
            
            return _currentUser
        }
        set(user){
            _currentUser = user
            let userDictionary = ["currentUserData": user]
            SettingUtil.saveSetting(configurations: userDictionary)
        }
    }
}

