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
        ref.child(path).childByAutoId().setValue(value) { (error, firebaseRef) in
            failure(error)
        }
    }
    
    /**
     Save value to firbase at specific path without using auto create id
     */
    func saveValueWithoutAutoId(path: String, value: [String: Any], failure: @escaping (_ error: Error?) -> ()) {
        let ref = FIRDatabase.database().reference()
        ref.child(path).setValue(value) { (error, firebaseRef) in
            failure(error)
    }
    }
    
    func getAutoId(path: String) -> String {
        let ref = FIRDatabase.database().reference()
        return ref.child(path).childByAutoId().key
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
    
    func retreiveData(path: String, sussess: @escaping (_ data: Any?) -> ()) {
        self.retreiveData(path: path, key: nil) { (result) in
            sussess(result)
        }
    }
    
    /**
     Retreive value at once. It is not tracking the changed from firebase
     */
    func retreiveData(path: String, key: String?, sussess: @escaping (_ data: Any?) -> ()) {
        var ref = FIRDatabase.database().reference().child(path)
        if let key = key {
            ref = ref.child(key)
        }
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                sussess(nil)
                print("Retreive date at path \(path) is not existed")
                return
            }
            sussess(snapshot.value)
        })
    }
    
    func retreiveDataWithOrder(path: String, key: String, sussess: @escaping (_ data: Any?) -> ()) {
        let ref = FIRDatabase.database().reference().child(path).queryOrdered(byChild: key)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                sussess(nil)
                print("Retreive date at path \(path) is not existed")
                return
            }
            
            sussess(snapshot.value)
        })
    }
}
