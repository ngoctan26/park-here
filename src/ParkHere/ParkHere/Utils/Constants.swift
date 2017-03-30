//
//  Constants.swift
//  ParkHere
//
//  Created by john on 3/12/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation
import UIKit

class Constant {
    static let Multilingual_File_Name = "MultilingualData"
    static let Empty_String = ""
    static let Comma_Char = ","
    
    // Hamburger Menu
    static let Home_Menu_Title_Key = "homeMenu"
    static let Comment_Menu_Title_Key = "commentMenu"
    static let Adding_Menu_Title_Key = "addingMenu"
    static let Settings_Menu_Title_Key = "settingsMenu"
    static let SignIn_Menu_Title_Key = "signInMenu"
    
    static let Width_Of_Space_For_Icon_On_Header_View = 100
    
    static let Header_View_Background_Color = UIColor(red:0.65, green:0.80, blue:0.36, alpha:1.0)
    
    // Map configuration
    static let Google_Api_key = "AIzaSyCVy3nim32ev3LFpmGVC-RVvKeE6SwRWuE"
    static let Normal_Zoom_Ratio: Float = 16.0
    
    // Firebase Db Auth
    static let Auth_Email = "toicodedoec@gmail.com"
    static let Auth_Pass = "parkhere"
    
    // Firebase Db Node
    static let Comments_Node = "comments/"
    static let Parking_Zones_Node = "parking_zones"
    // locations
    static let GeoQuery_Radius_Default = 2
    static let Locations_Node = "locations/"
    // user
    static let Current_User_Loc_Key = "current_user"
    static let Current_User_Loc_Node = "current_user"
    static let User_Node = "user_profiles/"
    static let Anonymous = "Anonymous"
    
    // Adding New Parking Zone
    static let Name_Place_Holder = "namePlaceHolder"
    static let Desc_Place_Holder = "descPlaceHolder"
    static let Address_Place_Holder = "addressPlaceHolder"
    
    // Firebase storage node
    static let Image_Storage_Node = "images/"

}
