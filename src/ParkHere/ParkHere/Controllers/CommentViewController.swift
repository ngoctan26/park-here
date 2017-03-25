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

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        initMapView()
    }

    func initMapView() {
        
        //commentMapView.showingMap.delegate = self
        let currentLocation = CLLocationCoordinate2D(latitude: 10.762639, longitude: 106.682027)
        commentMapView.moveCamera(inputLocation: currentLocation, animate: false)
        let sampleDesCoordinate = CLLocationCoordinate2D(latitude: 10.762639, longitude: 106.682027)
        commentMapView.addMarker(lat: sampleDesCoordinate.latitude, long: sampleDesCoordinate.longitude, textInfo: nil, markerIcon: nil)

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

