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

    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var vehicleTitleLabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var openTitleLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var closeTitleLabel: UILabel!
    @IBOutlet weak var closeTimeLabel: UILabel!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var parkingZone: ParkingZoneModel?
    var zoneMarker: GMSMarker?
    
    var comments: [CommentModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
                
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.estimatedRowHeight = 100
        commentTableView.rowHeight = UITableViewAutomaticDimension

        initTitle()
        initMapView()
        getParkingZoneDetail()
        getAllComments()
    }
    
    func initTitle() {
        backButton.title = Constant.Back_Title.localized
        addressTitleLabel.text = Constant.Address_Title.localized
        vehicleTitleLabel.text = Constant.Vehicle_Title.localized
        priceTitleLabel.text = Constant.Price_Title.localized
        openTitleLabel.text = Constant.OpenTime_Title.localized
        closeTitleLabel.text = Constant.CloseTime_Title.localized
        descriptionTitleLabel.text = Constant.Description_Title.localized
    }
    
    func initMapView() {
        if parkingZone != nil {
            commentMapView.showHideSearchBtn(isHide: true)
            let currentLocation = CLLocationCoordinate2D(latitude: (parkingZone?.latitude)!, longitude: (parkingZone?.longitude)!)
            commentMapView.moveCamera(inputLocation: currentLocation, animate: false)
            zoneMarker = commentMapView.addMarker(lat: currentLocation.latitude, long: currentLocation.longitude, textInfo: nil, markerIcon: nil)
        }
    }
    
    func getParkingZoneDetail() {
        if parkingZone != nil {
            
            var vehicle: String = ""
            if parkingZone?.transportTypes != nil {
                for (_, element) in (parkingZone?.transportTypes!.enumerated())! {
                    vehicle += element.rawValue + ", "
                }
                
                let splitIndex = vehicle.index(vehicle.endIndex, offsetBy: -2)
                vehicle = vehicle.substring(to: splitIndex)
            }
            
            if parkingZone?.address != nil {
                addressLabel.text = parkingZone?.address!
            }
            priceLabel.text = parkingZone?.prices?.joined(separator: ", ")
            vehicleLabel.text = vehicle
            openTimeLabel.text = parkingZone?.openTime
            closeTimeLabel.text = parkingZone?.closeTime
            descriptionLabel.text = parkingZone?.desc
        }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentViewCell", for: indexPath) as! CommentViewCell
            let comment = comments![indexPath.row]
            cell.contentLabel.text = comment.text
            cell.ratingView.rating = comment.rating!
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

