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
import GeoFire

class FirebaseService {
    let fireBaseDefaultRef = FIRDatabase.database().reference()
    
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
    
    func getParkingZonesById(parkingZoneId: String, success: @escaping (ParkingZoneModel?) -> Void) {
        FIRAuth.auth()!.signIn(withEmail: Constant.Auth_Email, password: Constant.Auth_Pass) { (user, error) in
            if error == nil {
                FirebaseClient.getInstance().retreiveData(path: Constant.Parking_Zones_Node, key: parkingZoneId, sussess: { (result) in
                    let rawValue = result as? NSDictionary
                    if let rawValue = rawValue {
                        success(ParkingZoneModel(dictionary: rawValue))
                    } else {
                        success(nil)
                    }
                })
            } else {
                print("error")
            }
        }
    }
    
    func addParkingZone(newParkingZone: ParkingZoneModel, success: @escaping () -> Void) {
        FIRAuth.auth()!.signIn(withEmail: Constant.Auth_Email, password: Constant.Auth_Pass) { (user, error) in
            if error == nil {
                // At first get key for new parking zone
                newParkingZone.id = FirebaseClient.getInstance().getAutoId(path: Constant.Parking_Zones_Node)
                
                // Add value for child node in parking zone
                var params = [String: AnyObject]()
                
                params["address"] = newParkingZone.address as AnyObject
                params["description"] = newParkingZone.desc as AnyObject
                params["image_url"] = newParkingZone.imageUrl as AnyObject
                params["created_at"] = newParkingZone.createdAt as AnyObject
                params["rating"] = newParkingZone.rating as AnyObject
                
                if let openTime = newParkingZone.openTime {
                    if let closeTime = newParkingZone.closeTime {
                        let workingTime: [String : String] = [
                            "opening_time": openTime,
                            "closing_time": closeTime
                        ]
                        params["working_time"] = workingTime as AnyObject?
                    }
                } else {
                    let workingTime: [String : AnyObject] = [
                        "opening_time": "07:00" as AnyObject,
                        "closing_time": "22:00" as AnyObject
                    ]
                    params["working_time"] = workingTime as AnyObject?
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
                    transportTypes.forEach { transportTypeStr = transportTypeStr + $0.rawValue + Constant.Comma_Char}
                    transportTypeStr = String(transportTypeStr.characters.dropLast())
                    params["transport_types"] = transportTypeStr as AnyObject
                }
                
                if let prices = newParkingZone.prices {
                    var pricesStr = Constant.Empty_String
                    prices.forEach { pricesStr = pricesStr + $0 + Constant.Comma_Char}
                    pricesStr = String(pricesStr.characters.dropLast())
                    params["prices"] = pricesStr as AnyObject
                }
                
                FirebaseClient.getInstance().saveValueWithoutAutoId(path: Constant.Parking_Zones_Node + "/\(newParkingZone.id!)", value: params, failure: { (error) in
                    if error != nil {
                        print(error.debugDescription)
                    } else {
                        // Starting push location for this zone by key with GeoFire
                        let pushedLocation = CLLocation(latitude: newParkingZone.latitude!, longitude: newParkingZone.longitude!)
                        self.saveLocation(key: newParkingZone.id!, location: pushedLocation, failure: { (error) in
                            if let error = error {
                                print("Pushed location failed: \(error)")
                            } else {
                                success()
                            }
                        })
                    }
                })
                try! FIRAuth.auth()!.signOut()
            } else {
                print("error")
            }
        }
    }
    
    func updateParkingZoneRating(parkingId: String, newRating: Double, success: @escaping () -> Void) {
        FIRAuth.auth()!.signIn(withEmail: Constant.Auth_Email, password: Constant.Auth_Pass) { (user, error) in
            if error == nil {
                var params = [String: AnyObject]()
                params["rating"] = newRating as AnyObject
                
                FirebaseClient.getInstance().updateValue(path: Constant.Parking_Zones_Node + "/\(parkingId)", value: params, failure: { (error: Error?) in
                    if error != nil {
                        print(error.debugDescription)
                    }
                    else {
                        success()
                    }
                })
                
                try! FIRAuth.auth()!.signOut()
            } else {
                print("error")
            }
        }
    }
    
    func getParkingZoneRating(parkingZoneId: Int!, success: @escaping (Double) -> Void) {
        //var sum: Double = 0.0
        var count: Int = 0
        FIRAuth.auth()!.signIn(withEmail: Constant.Auth_Email, password: Constant.Auth_Pass) { (user, error) in
            if error == nil {
                FIRDatabase.database().reference().child("comments/1/").queryOrdered(byChild: "rating").observe(.childAdded, with: { (snapshot) -> Void in
                    
                    print("\(snapshot.value)")
                    //sum += snapshot.value["rating"] as! Double
                    count += 1
                })
            } else {
                print("error")
            }
        }
    }
    
    // <!-- Comment -->
    func getCommentsByPage(parkingZoneId: String!, page: Int!, success: @escaping ([CommentModel]) -> Void) {
        FIRAuth.auth()!.signIn(withEmail: Constant.Auth_Email, password: Constant.Auth_Pass) { (user, error) in
            if error == nil {
                FirebaseClient.getInstance().retreiveDataWithOrder(path: Constant.Comments_Node + "\(parkingZoneId!)",key: "timestamp", sussess: { (result) in
                    if let results = result as? NSDictionary {
                        success(CommentModel.comments(dictionaries: results.allValues as! [NSDictionary]))
                    }
                })
            } else {
                print("error")
            }
        }
    }
    
    func addComment(newComment: CommentModel,  success: @escaping () -> Void) {
        FIRAuth.auth()!.signIn(withEmail: Constant.Auth_Email, password: Constant.Auth_Pass) { (user, error) in
            if error == nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                var Timestamp: TimeInterval {
                    return NSDate().timeIntervalSince1970 * 1000
                }
                let t1 = Timestamp

                var params = [String: AnyObject]()
                
                params["text"] = newComment.text as AnyObject
                params["rating"] = newComment.rating as AnyObject
                params["user_id"] = newComment.userId as AnyObject
                params["parking_zone_id"] = newComment.parkingZoneId as AnyObject
                params["create_at"] = dateFormatter.string(from: newComment.createdAt!) as AnyObject?
                params["timestamp"] = t1 as AnyObject
                
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
    func getUserById(userId: String!, success: @escaping (UserModel) -> (), failure: @escaping (Error?) -> ()) -> Void {
        FIRAuth.auth()!.signIn(withEmail: Constant.Auth_Email, password: Constant.Auth_Pass) { (user, error) in
            if error == nil {
                FirebaseClient.getInstance().retreiveData(path: Constant.User_Node + "\(userId!)", sussess: { (result) in
                    if let userDictionary = result as? NSDictionary{
                        success(UserModel(dictionary: userDictionary))
                    } else {
                        failure(nil)
                    }
                })
            } else {
                failure(error!)
            }
        }
    }
    
    func addUser(userModel: UserModel,  success: @escaping () -> Void) {
        FIRAuth.auth()!.signIn(withEmail: Constant.Auth_Email, password: Constant.Auth_Pass) { (user, error) in
            if error == nil {
                
                var params = [String: AnyObject]()
                params["name"] = userModel.name as AnyObject
                params["email"] = userModel.email as AnyObject
                
                FirebaseClient.getInstance().saveValue(path: Constant.User_Node + "\(userModel.id!)", value: params, failure: { (error) in
                    print(error.debugDescription)
                })
                try! FIRAuth.auth()!.signOut()
                success()
            } else {
                print("error")
            }
        }
    }

    
    // Locations
    
    func updateUserLocation(currentLocation: CLLocation, failure: @escaping (_ error: Error?) -> ()) {
        saveLocation(key: Constant.Current_User_Loc_Key, location: currentLocation) { (error) in
            failure(error)
        }
    }
    
    func saveLocation(key: String, location: CLLocation, failure: @escaping (_ error: Error?) -> ()) {
        let geoRef = GeoFire(firebaseRef: fireBaseDefaultRef.child(Constant.Locations_Node))
        geoRef?.setLocation(location, forKey: key) { (error) in
            failure(error)
        }
    }
    
    func getCircleQuery(centerLocation: CLLocation, radius: Double) -> GFCircleQuery? {
        let geoRef = GeoFire(firebaseRef: fireBaseDefaultRef.child(Constant.Locations_Node))
        // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
        return geoRef?.query(at: centerLocation, withRadius: radius)
    }
    
    // Upload image
    func uploadImage(image: UIImage, failure: @escaping (_ error: Error?) -> (), success: @escaping (_ downLoadURL: String) -> ()) {
        let storageRef = FIRStorage.storage().reference()
        let data = UIImagePNGRepresentation(image)
        let storagePath = Constant.Image_Storage_Node + "\(NSDate().timeIntervalSince1970 * 1000)\\imagename.png"
        if let data = data {
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/png"
            storageRef.child(storagePath).put(data, metadata: metaData, completion: { (metaDataReturn, error) in
                guard let metaDataReturn = metaDataReturn else {
                    failure(error)
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downLoadString = metaDataReturn.downloadURL()!.absoluteString
                success(downLoadString)
                print(downLoadString)
            })
        }
    }
}
