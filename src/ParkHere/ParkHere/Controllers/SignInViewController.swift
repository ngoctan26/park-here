//
//  ViewController.swift
//  ParkHere
//
//  Created by Phong on 16/3/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var messageLabel: UILabel!
    
    var isSignOut: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
        if isSignOut {
            GIDSignIn.sharedInstance().signOut()
            messageLabel.text = Constant.SignOutMessage.localized
            UserModel.currentUser = nil
            
            let notificationName = Notification.Name(Constant.UserDidSignOutNotification)
            NotificationCenter.default.post(name: notificationName, object: nil)
            
        } else {
            messageLabel.text = Constant.SignInMessage.localized
        }
        
        // Define identifier
        let signInNotificationName = Notification.Name(Constant.UserDidSignInNotification)
        // Register to receive notification
        NotificationCenter.default.addObserver(forName: signInNotificationName, object: nil, queue: OperationQueue.main, using: {(Notification) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
