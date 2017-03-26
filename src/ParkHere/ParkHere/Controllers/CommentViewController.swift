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

    @IBOutlet weak var commentMapView: MapView!
    @IBOutlet weak var commentTableView: UITableView!
    
    var comments: [CommentModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signOut()
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.estimatedRowHeight = 50
        commentTableView.rowHeight = UITableViewAutomaticDimension

        
        initMapView()
        getAllComments(parkingId: "-Kg5QJT0Iat8uxuDMFiJ")
    }

    func initMapView() {
        
        //commentMapView.showingMap.delegate = self
        let currentLocation = CLLocationCoordinate2D(latitude: 10.762639, longitude: 106.682027)
        commentMapView.moveCamera(inputLocation: currentLocation, animate: false)
        let sampleDesCoordinate = CLLocationCoordinate2D(latitude: 10.762639, longitude: 106.682027)
        commentMapView.addMarker(lat: sampleDesCoordinate.latitude, long: sampleDesCoordinate.longitude, textInfo: nil, markerIcon: nil)

    }
    
    func getAllComments(parkingId: String) {
        FirebaseService.getInstance().getCommentsByPage(parkingZoneId: parkingId, page: 0) { (comments: [CommentModel]) in
            self.comments = comments
            self.commentTableView.reloadData()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0: return ""
//        case 1: return "Distance"
//        case 2: return "Sort By"
//        case 3: return "Category"
//        default: return ""
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: if comments != nil{
                    return comments!.count
                }else{
                    return 0
                }
        case 1: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath as NSIndexPath).section {
        case 0: return 44
        case 1: return 80
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentViewCell", for: indexPath) as! CommentViewCell
            let comment = comments![indexPath.row]
            cell.contentLabel.text = comment.text
            return cell
        case 1:
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
    func addCommentViewCell(addCommentViewCell: AddCommentViewCell, didSendComment text: String) {
        let newComment: CommentModel = CommentModel()
        newComment.id = 1
        newComment.longitude = 123
        newComment.latitude = 123
        newComment.text = text
        newComment.parkingZoneId = "-Kg5QJT0Iat8uxuDMFiJ"
        newComment.rating = 4.5
        newComment.userId = 1
        newComment.createdAt = Date.init()
        FirebaseService.getInstance().addComment(newComment: newComment) {
            self.getAllComments(parkingId: "-Kg5QJT0Iat8uxuDMFiJ")
        }
    }
}

