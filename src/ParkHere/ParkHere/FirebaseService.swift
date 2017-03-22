//
//  FirebaseUtil.swift
//  ParkHere
//
//  Created by john on 3/18/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FirebaseService {
    
    private static var instance: FirebaseService?
    
    static func getInstance() -> FirebaseService {
        if instance == nil {
            instance = FirebaseService()
        }
        return instance!
    }
    
    // <!-- ParkingZone -->
    func getAllParkingZones() -> [ParkingZoneModel] {
        return []
    }
    
    func getParkingZonesByDistance() -> [ParkingZoneModel] {
        return []
    }
    
    func getParkingZonesById() -> ParkingZoneModel {
        return ParkingZoneModel()
    }
    
    func addParkingZone(newParkingZone: ParkingZoneModel, success: @escaping (ParkingZoneModel) -> Void) {
        success(newParkingZone)
    }
    
    func getParkingZoneRating(parkingZoneId: Int) -> Double {
        return 0.0
    }
    
    // <!-- Comment -->
    func getCommentsByPage(parkingZoneId: Int!, page: Int!, success: @escaping ([CommentModel]) -> Void) {
        FIRAuth.auth()!.signIn(withEmail: Constant.Auth_Email, password: Constant.Auth_Pass) { (user, error) in
            if error == nil {
                FirebaseClient.getInstance().retreiveData(path: Constant.Comments_Node + "\(parkingZoneId!)", sussess: { (result) in
                    let results: NSDictionary = result as! NSDictionary
                    success(CommentModel.comments(dictionaries: results.allValues as! [NSDictionary]))
                })
            } else {
                print("error")
            }
        }
    }
    
    func addComment(newComment: CommentModel,  success: @escaping () -> Void) {
        FIRAuth.auth()!.signIn(withEmail: Constant.Auth_Email, password: Constant.Auth_Pass) { (user, error) in
            if error == nil {
                
                var params = [String: AnyObject]()
                
                params["text"] = newComment.text as AnyObject
                params["rating"] = newComment.rating as AnyObject
                params["user_id"] = newComment.userId as AnyObject
                params["parking_zone_id"] = newComment.parkingZoneId as AnyObject
                
                if let longitude = newComment.longitude {
                    if let latitude = newComment.latitude {
                        let coordinate: [String : AnyObject] = [
                            "longitude": longitude as AnyObject,
                            "latitude": latitude as AnyObject
                        ]
                        params["coordinate"] = coordinate as AnyObject?
                    }
                }
                
                FirebaseClient.getInstance().saveValue(path: Constant.Comments_Node + "\(newComment.parkingZoneId!)", value: params, failure: { (error) in
                    print(error.debugDescription)
                })
                try! FIRAuth.auth()!.signOut()
                success()
            } else {
                print("error")
            }
        }
    }
    
    // <!-- User -->
    func getUserById(userId: Int) -> UserModel {
        return UserModel()
    }
}
