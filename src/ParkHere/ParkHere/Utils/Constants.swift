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
    static let SignOut_Menu_Title_Key = "signOutMenu"
    
    static let Width_Of_Space_For_Icon_On_Header_View = 100
    
    static let Header_View_Background_Color = UIColor(red:0.0 / 255, green:214.0 / 255, blue:199.0 / 255, alpha:1.0)
    
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
    static let GeoQuery_Radius_Default: Float = 500
    static let Locations_Node = "locations/"
    // user
    static let Current_User_Loc_Key = "current_user"
    static let Current_User_Loc_Node = "current_user"
    static let User_Node = "user_profiles/"
    static let Anonymous = "Anonymous"
    static let SignInMessage = "signInMessage"
    static let SignOutMessage = "signOutMessage"
    static let UserDidSignOutNotification = "userDidSignOutNotification"
    static let UserDidSignInNotification = "userDidSignInNotification"
    
    // Adding New Parking Zone
    static let Name_Place_Holder = "namePlaceHolder"
    static let Desc_Place_Holder = "descPlaceHolder"
    static let Address_Place_Holder = "addressPlaceHolder"
    static let Hour = "hour"
    
    // Firebase storage node
    static let Image_Storage_Node = "images/"
    
    // Setting view
    static let Section_1_Title = "settingSection1Title"
    static let Transport_Type_Label = "transportTypeLabel"
    static let Time_Setting_Label = "timeOpenAndCloseLabel"
    static let Distance_Label = "distanceLabel"
    
    static let Saved_Message_Toast = "savedText"
    
    // Comment
    static let Back_Title = "backTitle"
    static let Address_Title = "addressTitle"
    static let Vehicle_Title = "vehicleTitle"
    static let Price_Title = "priceTitle"
    static let OpenTime_Title = "openTimeTitle"
    static let CloseTime_Title = "closeTimeTitle"
    static let Description_Title = "descriptionTitle"

}
