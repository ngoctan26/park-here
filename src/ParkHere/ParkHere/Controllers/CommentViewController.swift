//
//  CommentViewController.swift
//  ParkHere
//
//  Created by john on 3/13/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleSignIn

class CommentViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var commentTableView: UITableView!

    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var parkingZone: ParkingZoneModel?
    var zoneMarker: GMSMarker?
    
    var comments: [CommentModel]?
    
    @IBAction func hideKeyboardTap(_ sender: UITapGestureRecognizer) {
        commentTableView.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
                
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.estimatedRowHeight = 100
        commentTableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        initTitle()
        getAllComments()
    }
    
    func initTitle() {
        backButton.title = Constant.Back_Title.localized
    }
    
    func getAllComments() {
        if parkingZone != nil {
            FirebaseService.getInstance().getCommentsByPage(parkingZoneId: parkingZone?.id, page: 0) { (comments: [CommentModel]) in
                self.comments = comments
                self.commentTableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onGoogleLoginButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func onLogoutButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    @IBAction func onBackButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            commentTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
            self.commentTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }
}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 2: if comments != nil{
                    return comments!.count
                }else{
                    return 0
                }
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapCommentCell", for: indexPath) as! CommentMapCell
            if let parkingZone = parkingZone {
                let parkingCoordinate = CLLocationCoordinate2D(latitude: parkingZone.latitude!, longitude: parkingZone.longitude!)
                cell.parkingLocation = parkingCoordinate
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCommentCell", for: indexPath) as! CommentInfoCell
            if let parkingZone = parkingZone {
                cell.parkingModel = parkingZone
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentViewCell", for: indexPath) as! CommentViewCell
            let comment = comments![indexPath.row]
            cell.contentLabel.text = comment.text
            cell.ratingView.rating = comment.rating!
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCommentCell", for: indexPath) as! AddCommentViewCell
            cell.delegate = self
            var userName = Constant.Anonymous
            if UserModel.currentUser != nil {
               userName = (UserModel.currentUser?.name)!
            }
            cell.reloadUser(username: userName)
            return cell
        default: return UITableViewCell()
        }
    }
}

extension CommentViewController: AddCommentViewCellDelagate{
    func addCommentViewCellInit(addCommentViewCell: AddCommentViewCell) -> String {
        if UserModel.currentUser == nil {
            return Constant.Anonymous
        } else{
            return (UserModel.currentUser?.name)!
        }
    }
    func addCommentViewCellSignIn(addCommentViewCell: AddCommentViewCell) {
        GIDSignIn.sharedInstance().signIn()
    }
    func addCommentViewCell(addCommentViewCell: AddCommentViewCell, didSendComment text: String, rating: Double) {
        var userId = UserModel.anonymousUser?.id
        if UserModel.currentUser != nil {
            userId = (UserModel.currentUser?.id)!
        }
        let newComment: CommentModel = CommentModel()
        newComment.id = 1
        newComment.text = text
        newComment.parkingZoneId = parkingZone?.id
        newComment.rating = rating
        newComment.userId = userId
        newComment.createdAt = Date.init()
        FirebaseService.getInstance().addComment(newComment: newComment) {
            self.getAllComments()
            let newParkingRating = ((self.parkingZone?.rating)! + rating)/2
            FirebaseService.getInstance().updateParkingZoneRating(parkingId: (self.parkingZone?.id)!, newRating: newParkingRating, success: {
                self.parkingZone?.rating = newParkingRating
            })
        }
    }
}

