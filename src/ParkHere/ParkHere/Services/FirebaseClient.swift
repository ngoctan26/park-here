//
//  FirebaseClient.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 3/13/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseClient {
    static var instance: FirebaseClient?
    
    static func getInstance() -> FirebaseClient {
        if instance == nil {
            instance = FirebaseClient()
        }
        return instance!
    }
 
    /**
     Save value to firbase at specific path
    */
    func saveValue(path: String, value: [String: Any], failure: @escaping (_ error: Error?) -> ()) {
        let ref = FIRDatabase.database().reference()
        ref.child(path).setValue(value) { (error, firebaseRef) in
            failure(error)
        }
    }
    
    /**
     Update child data in node. Make sure that child data have full properties and value otherwise child data structure will be changed
     */
    func updateValue(path: String, value: [String: Any], failure: @escaping (_ error: Error?) -> ()) {
        let ref = FIRDatabase.database().reference()
        ref.child(path).updateChildValues(value) { (error, firebaseRef) in
            failure(error)
        }
    }
    
    /**
     Insert new record in node that have child is an array
     */
    func updateValueByKey(path: String, value: [String: Any], failure: @escaping (_ error: Error?) -> ()) {
        let ref = FIRDatabase.database().reference()
        let key = ref.child(path).childByAutoId().key
        let childUpdate = ["\(path)/\(key)": value]
        ref.updateChildValues(childUpdate) { (error, firebaseRef) in
            failure(error)
        }
    }
    
    /**
     Retreive value at once. It is not tracking the changed from firebase
     */
    func retreiveData(path: String, sussess: @escaping (_ data: Any?) -> ()) {
        let ref = FIRDatabase.database().reference()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                sussess(nil)
            }
            let result = snapshot.childSnapshot(forPath: path)
            sussess(result.value)
        })
    }
}
