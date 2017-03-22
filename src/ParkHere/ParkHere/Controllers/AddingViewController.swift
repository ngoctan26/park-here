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
        let newComment: CommentModel = CommentModel()
        newComment.id = 1
        newComment.longitude = 123
        newComment.latitude = 123
        newComment.text = "Test Comment"
        newComment.parkingZoneId = 1
        newComment.rating = 4.5
        newComment.userId = 1
        newComment.createdAt = Date.init()
        
        FirebaseService.getInstance().addComment(newComment: newComment) { (_) in
            print("OK")
        }
        
        FirebaseService.getInstance().getCommentsByPage(parkingZoneId: 1, page: 1) { (comments) in
            print(comments.count)
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
