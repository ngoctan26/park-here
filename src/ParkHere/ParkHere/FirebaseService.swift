//
//  FirebaseUtil.swift
//  ParkHere
//
//  Created by john on 3/18/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation

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
    func getCommentsByPage(parkingZoneId: Int, page: Int) -> [CommentModel] {
        return []
    }
    
    func addComment(newComment: CommentModel,  success: @escaping (CommentModel) -> Void) {
        success(newComment)
    }
    
    // <!-- User -->
    func getUserById(userId: Int) -> UserModel {
        return UserModel()
    }
}
