//
//  AddingViewController.swift
//  ParkHere
//
//  Created by john on 3/13/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AddingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAdd(_ sender: UIButton) {
        FIRAuth.auth()!.signIn(withEmail: "toicodedoec@gmail.com", password: "parkhere") { (user, error) in
            if error == nil {
                
//                let messageRef: FIRDatabaseReference = FIRDatabase.database().reference().child("parking_zone")
//                let newMessageRef = messageRef.childByAutoId()
                let messageData: [String: Any] = [
                    "senderId": "songoku",
                    "email": "songoku@namec.com",
                    "content": "kadic stupid",
                    "createdAt": [".sv": "timestamp"]
                ]
//                newMessageRef.setValue(messageData)
                
                FirebaseClient.getInstance().saveValue(path: "parking_zone/7_vien_ngoc_rong", value: messageData, failure: { (error) in
                    print(error.debugDescription)
                })
                try! FIRAuth.auth()!.signOut()
            } else {
                print("error")
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
