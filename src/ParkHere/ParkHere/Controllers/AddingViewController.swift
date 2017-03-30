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
import GooglePlaces
import GoogleMaps
import GeoFire

class AddingViewController: UIViewController {
    
    @IBOutlet weak var newParkingZoneView: UIScrollView!
    var newParkingZoneSubView = NewParkingZone(frame: CGRect(x: 0, y: 0, width: 200, height: 880))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        newParkingZoneSubView.delegate = self
        newParkingZoneSubView.frame.size.width = newParkingZoneView.frame.size.width
        newParkingZoneSubView.segmentedControl.frame.size.width = newParkingZoneSubView.frame.size.width - 20
        newParkingZoneView.contentSize = CGSize(width: newParkingZoneSubView.frame.size.width, height: newParkingZoneSubView.frame.origin.y + newParkingZoneSubView.frame.size.height)
        newParkingZoneView.addSubview(newParkingZoneSubView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchPlace(place: GMSPlace) {
        let searchCoordinate = place.coordinate
        newParkingZoneSubView.selectedPlace = place
        newParkingZoneSubView.mapView.moveCamera(inputLocation: place.coordinate, animate: true)
        newParkingZoneSubView.searchMarker = newParkingZoneSubView.mapView.addMarker(lat: searchCoordinate.latitude, long: searchCoordinate.longitude, textInfo: nil, markerIcon: #imageLiteral(resourceName: "ic_search_marker"))
    }
}

extension AddingViewController: NewParkingZoneDelegate {
    func saveSuccessful(newParkingZone: ParkingZoneModel) {
        print("save thanh cong")
        dismiss(animated: true, completion: nil)
    }
}
