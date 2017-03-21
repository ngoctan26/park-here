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
    var infoWindow = MarkerInfoWindowView(frame: CGRect(x: 0, y: 0, width: 150, height: 200))
    var sampleMarker: GMSMarker!
    var sampleDesCoordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblTestMultilingual.text = "lang".localized
        initMapView()
        addMarkerForSampleDestination()
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
        mapView.delegate = self
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
    
    func addMarkerForSampleDestination() {
        sampleDesCoordinate = CLLocationCoordinate2D(latitude: 10.762639, longitude: 106.682027)
        sampleMarker = GMSMarker(position: sampleDesCoordinate)
        sampleMarker.map = mapView
        sampleMarker.icon = GMSMarker.markerImage(with: UIColor.red)
    }
    
    func showRouteSample() {
        let currentCoordinate = CLLocationCoordinate2D(latitude: 10.762639, longitude: 106.682027)
        let sampleDesCoordinate = CLLocationCoordinate2D(latitude: 10.758599, longitude: 106.681230)
        GMapDirectionService.sharedInstance.getDirection(origin: currentCoordinate.getLocationsAsString(), destination: sampleDesCoordinate.getLocationsAsString(), success: { (route) in
            self.drawRoute(points: route.routeAsPoints)
        }, failure: { (error) in
            print("Get route from server failed. \(error?.localizedDescription)")
        })
    }
    
    func drawRoute(points: String) {
        let path: GMSPath = GMSPath(fromEncodedPath: points)!
        let sampleRoute = GMSPolyline(path: path)
        sampleRoute.map = mapView
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

extension CLLocationCoordinate2D {
    func getLocationsAsString() -> String {
        return "\(String(latitude)),\(String(longitude))"
    }
}

extension HomeViewController: MarkerInfoWindowViewDelegate {
    func onBtnDrawRouteClicked() {
        showRouteSample()
    }
    
    func onBtnDetailClicked() {
        // TODO: Move to details
    }
}

extension HomeViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let location = CLLocationCoordinate2D(latitude: sampleDesCoordinate.latitude, longitude: sampleDesCoordinate.longitude)
        infoWindow.removeFromSuperview()
        infoWindow.delegate = self
        infoWindow.markerInfo = "info"
        infoWindow.center = mapView.projection.point(for: location)
        infoWindow.center.y -= 150 // Place infowindow above marker
        self.view.addSubview(infoWindow)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let location = CLLocationCoordinate2D(latitude: sampleDesCoordinate.latitude, longitude: sampleDesCoordinate.longitude)
        infoWindow.center = mapView.projection.point(for: location)
        infoWindow.center.y -= 150
    }
    
    // take care of the close event
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
    }
}
