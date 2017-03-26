//
//  HomeViewController.swift
//  ParkHere
//
//  Created by john on 3/12/17.
//  Copyright © 2017 dtp. All rights reserved.
//

import UIKit
import GoogleMaps
import GeoFire

class HomeViewController: UIViewController {

    @IBOutlet weak var lblTestMultilingual: UILabel!
    @IBOutlet var mapView: MapView!
    @IBOutlet var actionBar: MapActionBarView!
    
    var locationManager = CLLocationManager()
    var isUpdateCurrentLocationEnable = true;
    var infoWindow = MarkerInfoWindowView(frame: CGRect(x: 0, y: 0, width: 150, height: 200))
    
    var geoFireStartObserve: Bool = false
    var currentGeoQuery: GFCircleQuery?
    var parkingZones: [String: ParkingZoneModel] = [:]
    var filteredParkingZones: [String: ParkingZoneModel] = [:]
    var markersRef: [GMSMarker] = []
    
    // Sample variable
    var sampleMarker: GMSMarker!
    var sampleMarker2nd: GMSMarker!
    var selectedMarker: GMSMarker?
    var sampleDesCoordinate: CLLocationCoordinate2D!
    
    // Action references
    
    @IBAction func onBtnCurrentLocationClicked(_ sender: UIButton) {
        updateMapToCurrentPosition(animate: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblTestMultilingual.text = "lang".localized
        actionBar.delegate = self
        initMapView()
        //createSampleForTest()
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
        
        // Add delegate for map view
        mapView.showingMap.delegate = self
        // At first, jump into current location
        updateMapToCurrentPosition(animate: false)
    }
    
    func updateMapToCurrentPosition(animate: Bool) {
        let currentLocation = locationManager.location
        if let currentLocation = currentLocation {
            mapView.moveCamera(inputLocation: currentLocation.coordinate, animate: animate)
        }
    }
 
    // TODO: Remove sample when finished test
    func createSampleForTest() {
//        addMarkerForSampleDestination()
//        addSampleParkingZone()
    }
    
//    func addMarkerForSampleDestination() {
//        sampleDesCoordinate = CLLocationCoordinate2D(latitude: 10.762639, longitude: 106.682027)
//        sampleMarker = mapView.addMarker(lat: sampleDesCoordinate.latitude, long: sampleDesCoordinate.longitude, textInfo: nil, markerIcon: nil)
//        
//        // Add second marker
//        let sample2ndCoordinate = CLLocationCoordinate2D(latitude: 10.761096, longitude: 106.682230)
//        sampleMarker2nd = mapView.addMarker(lat: sample2ndCoordinate.latitude, long: sample2ndCoordinate.longitude, textInfo: nil, markerIcon: nil)
//    }
    
    func showRouteSample() {
        let currentCoordinate = CLLocationCoordinate2D(latitude: 10.762639, longitude: 106.682027)
        let sampleDesCoordinate = CLLocationCoordinate2D(latitude: 10.758599, longitude: 106.681230)
        GMapDirectionService.sharedInstance.getDirection(origin: currentCoordinate.getLocationsAsString(), destination: sampleDesCoordinate.getLocationsAsString(), success: { (route) in
            self.mapView.drawRoute(points: route.routeAsPoints)
        }, failure: { (error) in
            print("Get route from server failed. \(error?.localizedDescription)")
        })
    }
    
//    func addSampleParkingZone() {
//        let newParkingZone = ParkingZoneModel()
//        newParkingZone.desc = "sample description for park 1"
//        newParkingZone.address = "227 Nguyễn Văn Cừ, phường 4, Quận 5, Hồ Chí Minh, Việt Nam"
//        newParkingZone.imageUrl = URL(fileURLWithPath: "http://sample.url")
//        newParkingZone.latitude = 10.762639
//        newParkingZone.longitude = 106.682027
//        let currentDateTime = Date()
//        newParkingZone.createdAt = DateTimeUtil.stringFromDate(date: currentDateTime)
//        newParkingZone.closeTime = 1120
//        newParkingZone.id = FirebaseClient.getInstance().getAutoId(path: Constant.Parking_Zones_Node)
//        FirebaseService.getInstance().addParkingZone(newParkingZone: newParkingZone) {
//            // TODO: update something when complete
//            
//        }
//    }
    
//    func saveSampleLocation() {
//        let savedLocation = CLLocation(latitude: 10.762639, longitude: 106.682027)
//        FirebaseService.getInstance().saveLocation(key: "Kg3s2sGsK502j_xrk9h", location: savedLocation) { (error) in
//            if let error = error {
//                print("Save sample location failed: \(error)")
//            }
//        }
//    }
    
    func startQueryForParkingZone(centerLocation: CLLocation) {
            currentGeoQuery = FirebaseService.getInstance().getCircleQuery(centerLocation: centerLocation)
            if let currentGeoQuery = currentGeoQuery {
                currentGeoQuery.observeReady({
                    print("All initial data has been loaded and events have been fired!")
                })
                currentGeoQuery.observe(.keyEntered, with: { (key, parkingLocation) in
                    if key != Constant.Current_User_Loc_Key {
                        FirebaseService.getInstance().getParkingZonesById(parkingZoneId: key!, success: { (parkingModel) in
                            if let parkingModel = parkingModel {
                                // Set id for model
                                parkingModel.id = key
                                // Set marker for model
                                let addedMarker = self.mapView.addMarker(parkingZones: [parkingModel], textInfo: nil, markerIcon: nil)
                                addedMarker[0].userData = parkingModel
                                self.parkingZones[key!] = parkingModel
                                
                                // Add marker reference by position in order to be retreive later
                                parkingModel.markerRef = self.markersRef.count
                                self.markersRef.append(addedMarker[0])
                            }
                        })
                    }
                })
                currentGeoQuery.observe(.keyExited, with: { (key, parkingLocation) in
                    if key != Constant.Current_User_Loc_Key {
                        // Get maker and Model reference by key
                        let parkingModel = self.parkingZones[key!]
                        let markerRefPos = (parkingModel?.markerRef)!
                        let marker = self.markersRef[markerRefPos]
                        // Remove marker from map
                        marker.map = nil
                        // Remove all reference from maker list and parking zone list
                        self.markersRef.remove(at: markerRefPos)
                        self.parkingZones.removeValue(forKey: key!)
                        
                    }
                })
                currentGeoQuery.observe(.keyMoved, with: { (key, parkingLocation) in
                    if key != Constant.Current_User_Loc_Key {
                        // Get maker and Model reference by key
                        let parkingModel = self.parkingZones[key!]
                        let markerRefPos = (parkingModel?.markerRef)!
                        let marker = self.markersRef[markerRefPos]
                        marker.position = CLLocationCoordinate2D(latitude: (parkingLocation?.coordinate.latitude)!, longitude: (parkingLocation?.coordinate.longitude)!)
                        parkingModel?.longitude = parkingLocation?.coordinate.latitude
                        parkingModel?.longitude = parkingLocation?.coordinate.longitude
                    }
                })
            }
    }
    
    func filterByTransporter(types: [TransportTypeEnum]) -> [String : ParkingZoneModel]{
        var resultFilter: [String : ParkingZoneModel] = [:]
        for (key, value) in parkingZones {
            for type in types {
                if (value.transportTypes?.contains(type))! {
                    resultFilter[key] = value
                }
            }
        }
        return resultFilter
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        // Update here when location changed
        if isUpdateCurrentLocationEnable {
            mapView.moveCamera(inputLocation: (location?.coordinate)!, animate: false)
            FirebaseService.getInstance().updateUserLocation(currentLocation: location!, failure: { (error) in
                if let error = error {
                    print("Update user location to firebase failed: \(error.localizedDescription)")
                }
            })
            isUpdateCurrentLocationEnable = false
        }
        if !geoFireStartObserve && location != nil {
            startQueryForParkingZone(centerLocation: location!)
            geoFireStartObserve = true
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
        //showRouteSample()
    }
    
    func onBtnDetailClicked() {
        // TODO: Move to details
        performSegue(withIdentifier: "CommentSegue", sender: nil)
    }
}

extension HomeViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if selectedMarker != nil {
            infoWindow.removeFromSuperview()
            selectedMarker = nil
        }
        let parkingModel = marker.userData as? ParkingZoneModel
        if let parkingModel = parkingModel {
            infoWindow.removeFromSuperview()
            infoWindow.delegate = self
            infoWindow.markerInfo = parkingModel
            infoWindow.center = mapView.projection.point(for: marker.position)
            infoWindow.center.y -= 150 // Place infowindow above marker
            selectedMarker = marker
            self.view.addSubview(infoWindow)
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if selectedMarker != nil {
            infoWindow.center = mapView.projection.point(for: (selectedMarker?.position)!)
            infoWindow.center.y -= 150
        }
    }
    
    // take care of the close event
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
    }
}

extension HomeViewController: MapActionBarViewDelegate {
    func btnRatingClicked() {
        
    }
    
    func btnCarClicked() {
        
    }
    
    func btnMotoClicked() {
        
    }
    
    func btnPriceClicked() {
        
    }
    
    func btnNearestClicked() {
        
    }
    
    func btnBikeClicked() {
        
    }
}
