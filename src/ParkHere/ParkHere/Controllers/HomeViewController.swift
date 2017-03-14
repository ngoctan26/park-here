//
//  HomeViewController.swift
//  ParkHere
//
//  Created by john on 3/12/17.
//  Copyright © 2017 dtp. All rights reserved.
//

import UIKit
import GoogleMaps

class HomeViewController: UIViewController {

    @IBOutlet weak var lblTestMultilingual: UILabel!
    @IBOutlet var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var isUpdateCurrentLocationEnable = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblTestMultilingual.text = "lang".localized
        initMapView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func initMapView() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        // At first, jump into current location
        updateMapToCurrentPosition()
    }
    
    func updateMapToCurrentPosition() {
        let currentLocation = locationManager.location
        if let currentLocation = currentLocation {
            mapView.camera = GMSCameraPosition.camera(withLatitude: (currentLocation.coordinate.latitude), longitude: (currentLocation.coordinate.longitude), zoom: Constant.Normal_Zoom_Ratio)
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // let location = locations[0]
        // Update here when location changed
        if isUpdateCurrentLocationEnable {
            updateMapToCurrentPosition()
            isUpdateCurrentLocationEnable = false
        }
    }
}
