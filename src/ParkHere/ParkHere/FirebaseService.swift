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
    func getAllParkingZones(success: @escaping ([ParkingZoneModel]) -> Void) {
        FIRAuth.auth()!.signIn(withEmail: Constant.Auth_Email, password: Constant.Auth_Pass) { (user, error) in
            if error == nil {
                FirebaseClient.getInstance().retreiveData(path: Constant.Parking_Zones_Node, sussess: { (result) in
                    let results: NSDictionary = result as! NSDictionary
                    success(ParkingZoneModel.parkingZones(dictionaries: results.allValues as! [NSDictionary]))
                })
            } else {
                print("error")
            }
        }
    }
    
    func getParkingZonesByDistance() -> [ParkingZoneModel] {
        return []
    }
    
    func getParkingZonesById(parkingZoneId: Int!, success: @escaping (ParkingZoneModel) -> Void) {
        FIRAuth.auth()!.signIn(withEmail: Constant.Auth_Email, password: Constant.Auth_Pass) { (user, error) in
            if error == nil {
                FirebaseClient.getInstance().retreiveData(path: Constant.Parking_Zones_Node + "\(parkingZoneId!)", sussess: { (result) in
                    success(ParkingZoneModel(dictionary: result as! NSDictionary))
                })
            } else {
                print("error")
            }
        }
    }
    
    func addParkingZone(newParkingZone: ParkingZoneModel, success: @escaping () -> Void) {
        FIRAuth.auth()!.signIn(withEmail: Constant.Auth_Email, password: Constant.Auth_Pass) { (user, error) in
            if error == nil {
                
                var params = [String: AnyObject]()
                
                params["address"] = newParkingZone.address as AnyObject
                params["description"] = newParkingZone.desc as AnyObject
                params["image_url"] = newParkingZone.imageUrl?.absoluteString as AnyObject
                params["created_at"] = newParkingZone.createdAt as AnyObject
                
                if let openTime = newParkingZone.openTime {
                    if let closeTime = newParkingZone.closeTime {
                        let workingTime: [String : AnyObject] = [
                            "opening_time": openTime as AnyObject,
                            "closing_time": closeTime as AnyObject
                        ]
                        params["working_time"] = workingTime as AnyObject?
                    }
                }
                
                if let longitude = newParkingZone.longitude {
                    if let latitude = newParkingZone.latitude {
                        let coordinate: [String : AnyObject] = [
                            "longitude": longitude as AnyObject,
                            "latitude": latitude as AnyObject
                        ]
                        params["coordinate"] = coordinate as AnyObject?
                    }
                }
                
                if let transportTypes = newParkingZone.transportTypes {
                    var transportTypeStr = Constant.Empty_String
                    transportTypes.forEach { transportTypeStr = transportTypeStr + Constant.Comma_Char + $0.rawValue}
                    params["transport_types"] = transportTypeStr as AnyObject
                }
                
                FirebaseClient.getInstance().saveValue(path: Constant.Parking_Zones_Node, value: params, failure: { (error) in
                    print(error.debugDescription)
                })
                try! FIRAuth.auth()!.signOut()
                success()
            } else {
                print("error")
            }
        }
    }
    
    func getParkingZoneRating(parkingZoneId: Int!, success: @escaping (Double) -> Void) {
        var sum: Double = 0.0
        var count: Int = 0
        FIRAuth.auth()!.signIn(withEmail: Constant.Auth_Email, password: Constant.Auth_Pass) { (user, error) in
            if error == nil {
                FIRDatabase.database().reference().child("comments/1/").queryOrdered(byChild: "rating").observe(.childAdded, with: { (snapshot) -> Void in
                    
                    print(snapshot.value)
                    //sum += snapshot.value["rating"] as! Double
                    count += 1
                })
            } else {
                print("error")
            }
        }
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
