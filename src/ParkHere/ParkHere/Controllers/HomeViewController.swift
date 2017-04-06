//
//  HomeViewController.swift
//  ParkHere
//
//  Created by john on 3/12/17.
//  Copyright © 2017 dtp. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import GeoFire
import PopupDialog

class HomeViewController: UIViewController {
    
    @IBOutlet var mapView: MapView!
    @IBOutlet var actionBar: MapActionBarView!
    
    var locationManager = CLLocationManager()
    var isUpdateCurrentLocationEnable = true;
    var infoWindow = MarkerInfoWindowView(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
    
    var geoFireStartObserve: Bool = false
    var currentGeoQuery: GFCircleQuery?
    var searchGeoQuery: GFCircleQuery?
    var parkingZones: [String: ParkingZoneModel] = [:]
    var filteredParkingZones: [String: ParkingZoneModel] = [:]
    var currentDrawedRoute: GMSPolyline?
    var desDrawlocation: CLLocationCoordinate2D?
    var markersRef: [GMSMarker] = []
    var selectedMarker: GMSMarker?
    var searchMarker: GMSMarker?
    var filterState = FilterState.None
    var isSearching = false
    var searedLocation: CLLocationCoordinate2D?
    var currentSetting: SettingModel?
    var cirleQuery: GMSCircle?
    
    // Action references
    
    @IBAction func onBtnCurrentLocationClicked(_ sender: UIButton) {
        updateMapToCurrentPosition(animate: true)
        if isSearching {
            isSearching = false
            clearSearchData()
            if let currentLocation = locationManager.location {
                let currentRadius = currentSetting?.radius
                let queryRadius = currentRadius != nil ? currentRadius! : Constant.GeoQuery_Radius_Default
                currentGeoQuery = startQueryForParkingZone(centerLocation: currentLocation, radius: queryRadius)
                drawRadiusQuery(coordinate: currentLocation.coordinate)
            }
        }
    }
    
    @IBAction func onUnrouteBtnClicked(_ sender: UIButton) {
        if let currentDrawedRoute = currentDrawedRoute {
            currentDrawedRoute.map = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        actionBar.delegate = self
        initMapView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! UINavigationController
        let commentVC = navVC.topViewController as! CommentViewController
        commentVC.parkingZone = selectedMarker?.userData as? ParkingZoneModel
        
    }
    
    func initMapView() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Add delegate for map view
        mapView.showingMap.delegate = self
        mapView.showHideSearchBtn(isHide: true)
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
        addSampleParkingZone()
    }
    
    func getRouteFromServer(desCoordinate: CLLocationCoordinate2D) {
        if let currentCoordinate = locationManager.location?.coordinate  {
            GMapDirectionService.sharedInstance.getDirection(origin: currentCoordinate.getLocationsAsString(), destination: desCoordinate.getLocationsAsString(), success: { (route) in
                if self.currentDrawedRoute != nil {
                    // Remove old route
                    self.currentDrawedRoute?.map = nil
                    self.desDrawlocation = desCoordinate
                }
                self.currentDrawedRoute = self.mapView.drawRoute(points: route.routeAsPoints)
            }, failure: { (error) in
                print("Get route from server failed. \(error?.localizedDescription)")
            })
        }
    }
    
    func addSampleParkingZone() {
        let newParkingZone = ParkingZoneModel()
        newParkingZone.desc = "Bệnh Viện Mắt Cao Thắng"
        newParkingZone.address = "135B Trần Bình Trọng, phường 2, Quận 5, Hồ Chí Minh 700000, Việt Nam"
        newParkingZone.imageUrl = "http://sample.url"
        newParkingZone.latitude = 10.757261
        newParkingZone.longitude = 106.680654
        let currentDateTime = Date()
        newParkingZone.createdAt = DateTimeUtil.stringFromDate(date: currentDateTime)
        newParkingZone.closeTime = "23:30"
        newParkingZone.openTime = "08:30"
        newParkingZone.prices = ["10000"]
        newParkingZone.rating = 0.0
        newParkingZone.transportTypes = [TransportTypeEnum.Motorbike]
        newParkingZone.id = FirebaseClient.getInstance().getAutoId(path: Constant.Parking_Zones_Node)
        FirebaseService.getInstance().addParkingZone(newParkingZone: newParkingZone) {
            // TODO: update something when complete
            
        }
    }
    
    func searchPlace(place: GMSPlace) {
        isSearching = true
        searedLocation = place.coordinate
        mapView.moveCamera(inputLocation: place.coordinate, animate: true)
        searchMarker = mapView.addMarker(lat: searedLocation!.latitude, long: searedLocation!.longitude, textInfo: nil, markerIcon: #imageLiteral(resourceName: "ic_search_marker"))
        clearCurrentShowingData()
        let currentRadius = currentSetting?.radius
        let queryRadius = currentRadius != nil ? currentRadius! : Constant.GeoQuery_Radius_Default
        searchGeoQuery = startQueryForParkingZone(centerLocation: CLLocation(latitude: searedLocation!.latitude, longitude: searedLocation!.longitude), radius: queryRadius)
        drawRadiusQuery(coordinate: searedLocation!)
    }
    
    func clearSearchData() {
        searchMarker?.map = nil
        searchGeoQuery?.removeAllObservers()
    }
    
    func clearCurrentShowingData() {
        currentGeoQuery?.removeAllObservers()
        parkingZones.removeAll()
        currentDrawedRoute?.map = nil
        filteredParkingZones.removeAll()
        for marker in markersRef {
            marker.map = nil
        }
        markersRef.removeAll()
        
    }
    
    func startQueryForParkingZone(centerLocation: CLLocation, radius: Float) -> GFCircleQuery? {
        GuiUtil.showLoadingIndicator()
        // input radius is meter
        let geoQuery = FirebaseService.getInstance().getCircleQuery(centerLocation: centerLocation, radius: Double(radius / 1000))
        if let geoQuery = geoQuery {
            geoQuery.observeReady({
                print("All initial data has been loaded and events have been fired!")
                GuiUtil.dismissLoadingIndicator()
            })
            geoQuery.observe(.keyEntered, with: { (key, parkingLocation) in
                if key != Constant.Current_User_Loc_Key {
                    FirebaseService.getInstance().getParkingZonesById(parkingZoneId: key!, success: { (parkingModel) in
                        if let parkingModel = parkingModel {
                            // Set id for model
                            parkingModel.id = key
                            self.parkingZones[key!] = parkingModel
                            self.updateShowingParkingByState(state: self.filterState, parkingModel: parkingModel, key: key!)
                            GuiUtil.dismissLoadingIndicator()
                        }
                    })
                }
            })
            geoQuery.observe(.keyExited, with: { (key, parkingLocation) in
                if key != Constant.Current_User_Loc_Key {
                    // Get maker and Model reference by key
                    self.parkingZones.removeValue(forKey: key!)
                    let showingModel = self.filteredParkingZones[key!]
                    if let showingModel = showingModel {
                        // Data is in showing model. Removing it and marker
                        let markerPos = showingModel.markerRef
                        let showingMarker = self.markersRef[markerPos!]
                        showingMarker.map = nil
                        
                        // Remove in all reference list
                        self.filteredParkingZones.removeValue(forKey: key!)
                        self.markersRef.remove(at: markerPos!)
                    }
                }
            })
            geoQuery.observe(.keyMoved, with: { (key, parkingLocation) in
                if key != Constant.Current_User_Loc_Key {
                    // Get maker and Model reference by key
                    let parkingModel = self.parkingZones[key!]
                    parkingModel?.latitude = parkingLocation?.coordinate.latitude
                    parkingModel?.longitude = parkingLocation?.coordinate.longitude
                    // Update if this parking zone is in showing list
                    let showingModel = self.filteredParkingZones[key!]
                    if let showingModel = showingModel {
                        showingModel.latitude = parkingLocation?.coordinate.latitude
                        showingModel.longitude = parkingLocation?.coordinate.longitude
                        let markerPos = showingModel.markerRef
                        let marker = self.markersRef[markerPos!]
                        marker.position = CLLocationCoordinate2D(latitude: (parkingLocation?.coordinate.latitude)!, longitude: (parkingLocation?.coordinate.longitude)!)
                    }
                }
            })
        }
        return geoQuery
    }
    
    func updateShowingParkingByState(state: FilterState, parkingModel: ParkingZoneModel, key: String) {
        var dataIsValid = false
        switch state {
        case .Transport_Car:
            dataIsValid = (parkingModel.transportTypes?.contains(TransportTypeEnum.Car))!
            break
        case .Transport_Bike:
            dataIsValid = (parkingModel.transportTypes?.contains(TransportTypeEnum.Bicycle))!
            break
        case .Transport_Moto:
            dataIsValid = (parkingModel.transportTypes?.contains(TransportTypeEnum.Motorbike))!
            break
        // Below cases will only have 1 data in dictionary.
        case .Rating:
            if let filteredData = filteredParkingZones.values.first {
                dataIsValid = filteredData.rating < parkingModel.rating
            }
            break
        case .Nearest:
            if let filteredData = filteredParkingZones.values.first {
                let coordinateFiltered = CLLocation(latitude: filteredData.latitude!, longitude: filteredData.longitude!)
                let coordinateNew = CLLocation(latitude: parkingModel.latitude!, longitude: parkingModel.longitude!)
                if let currentLocation = locationManager.location {
                    dataIsValid = coordinateFiltered.distance(from: currentLocation) > coordinateNew.distance(from: currentLocation)
                }
            }
            break
        case .Price:
            if let filteredData = filteredParkingZones.values.first {
                dataIsValid = (filteredData.prices?[0])! < (parkingModel.prices?[0])!
            }
            break
        default:
            dataIsValid = true
            break
        }
        if let currentLoation = locationManager.location {
            dataIsValid = dataIsValid || isValidData(parkingZone: parkingModel, currentLocation: currentLoation)
        }
        // Update to showing parking zone and add marker
        if dataIsValid {
            addMarker(parkingModel: parkingModel)
            filteredParkingZones[key] = parkingModel
        }
    }
    
    func updateShowingParkings(data: [String : ParkingZoneModel]) {
        // Clear all current marker
        mapView.showingMap.clear()
        if let cirleQuery = cirleQuery {
            cirleQuery.map = mapView.showingMap
        }
        if isSearching {
            searchMarker?.map = mapView.showingMap
        }
        markersRef.removeAll()
        filteredParkingZones = data
        for (_, value) in filteredParkingZones {
            addMarker(parkingModel: value)
        }
    }
    
    func addMarker(parkingModel: ParkingZoneModel) {
        //        let types = parkingModel.transportTypes
        //        var icDisplay: UIImage?
        //        if types != nil && (types?.count)! > 1 {
        //            icDisplay = #imageLiteral(resourceName: "ic_parking")
        //        } else if types != nil && types![0] == .Bicycle {
        //            icDisplay = #imageLiteral(resourceName: "ic_bike_parking")
        //        } else if types != nil && types![0] == .Car {
        //            icDisplay = #imageLiteral(resourceName: "ic_car_parking")
        //        } else if types != nil && types![0] == .Motorbike {
        //            icDisplay = #imageLiteral(resourceName: "ic_moto_parking")
        //        }
        
        let addedMarker = mapView.addMarker(parkingZones: [parkingModel], textInfo: nil, markerIcon: ImageUtil.resizeImage(image: #imageLiteral(resourceName: "ic_parking"), newWidth: 48))[0]
        addedMarker.userData = parkingModel
        parkingModel.markerRef = markersRef.count
        markersRef.append(addedMarker)
    }
    
    func filterDataByState(state: FilterState) -> [String : ParkingZoneModel] {
        if state == .None {
            return parkingZones
        }
        if state == .Rating {
            // Filter by rating
            let model = parkingZones.max { a, b  in a.value.rating < b.value.rating
            }
            if let model = model {
                return [model.key : model.value]
            }
            return [:]
        } else if state == .Nearest {
            // Filter by distance from current location
            let currentLocation = locationManager.location
            if let currentLocation = currentLocation {
                let model = parkingZones.min { a, b  in
                    let locationA = CLLocation(latitude: a.value.latitude!, longitude: a.value.longitude!)
                    let locationB = CLLocation(latitude: b.value.latitude!, longitude: b.value.longitude!)
                    return locationA.distance(from: currentLocation) < locationB.distance(from: currentLocation)
                }
                if let model = model {
                    return [model.key : model.value]
                }
                return [:]
            }
            return [:]
        } else if state == .Price {
            // TODO: handle price by current transport type selected
            // Currently just get min of first price
            let model = parkingZones.min { a, b  in
                return Int((a.value.prices?[0])!)! < Int((b.value.prices?[0])!)!
            }
            if let model = model {
                return [model.key : model.value]
            }
            return [:]
        }
        var resultFilter: [String : ParkingZoneModel] = [:]
        for (key, value) in parkingZones {
            switch state {
            case .Transport_Car:
                if (value.transportTypes?.contains(TransportTypeEnum.Car))! {
                    resultFilter[key] = value
                }
                break
            case .Transport_Bike:
                if (value.transportTypes?.contains(TransportTypeEnum.Bicycle))! {
                    resultFilter[key] = value
                }
                break
            case .Transport_Moto:
                if (value.transportTypes?.contains(TransportTypeEnum.Motorbike))! {
                    resultFilter[key] = value
                }
                break
            default:
                break
            }
        }
        return resultFilter
    }
    
    func isValidData(parkingZone: ParkingZoneModel, currentLocation: CLLocation?) -> Bool {
        var isValid = true
        // FIXME: confusing between setting and filter at home
        //        let settingTransport = currentSetting?.transportType
        //        if settingTransport != nil && settingTransport != TransportTypeEnum.All {
        //            isValid = (parkingZone.transportTypes?.contains(settingTransport!))!
        //        }
        let openTime = currentSetting?.openTime
        let closedTime = currentSetting?.closedTime
        if openTime != nil {
            let openTimeConvert = DateTimeUtil.dateFromString(dateAsString: openTime!, format: DateTimeUtil.Time_Format_Default)
            let openTimeInModel = DateTimeUtil.dateFromString(dateAsString: parkingZone.openTime!, format: DateTimeUtil.Time_Format_Default)
            if openTimeInModel != nil {
                isValid = isValid || (openTimeConvert! < openTimeInModel!)
            }
        }
        if closedTime != nil {
            let closeTimeConvert = DateTimeUtil.dateFromString(dateAsString: closedTime!, format: DateTimeUtil.Time_Format_Default)
            let closedimeInModel = DateTimeUtil.dateFromString(dateAsString: parkingZone.closeTime!, format: DateTimeUtil.Time_Format_Default)
            if closedimeInModel != nil {
                isValid = isValid || (closedimeInModel! < closeTimeConvert!)
            }
        }
        let radius = currentSetting?.radius
        if radius != nil && currentLocation != nil {
            let location = CLLocation(latitude: parkingZone.latitude!, longitude: parkingZone.longitude!)
            let distance = location.distance(from: currentLocation!)
            isValid = isValid || (Double(radius!) > distance)
        }
        return isValid
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
            // Draw circle query
            drawRadiusQuery(coordinate: (location?.coordinate)!)
            let currentRadius = currentSetting?.radius
            let queryRadius = currentRadius != nil ? currentRadius! : Constant.GeoQuery_Radius_Default
            currentGeoQuery = startQueryForParkingZone(centerLocation: location!, radius: queryRadius)
            geoFireStartObserve = true
        }
    }
    
    func drawRadiusQuery(coordinate: CLLocationCoordinate2D) {
        if let cirleQuery = cirleQuery {
            cirleQuery.map = nil
        }
        var radius: Float = Constant.GeoQuery_Radius_Default
        if let currentSetting = currentSetting {
            if let radiusFromSetting = currentSetting.radius {
                radius = radiusFromSetting
            }
        }
        cirleQuery = mapView.drawCircle(coordinate: coordinate, radius: radius)
    }
}

extension CLLocationCoordinate2D {
    func getLocationsAsString() -> String {
        return "\(String(latitude)),\(String(longitude))"
    }
}

extension HomeViewController: MarkerInfoWindowViewDelegate {
    func onBtnDrawRouteClicked(desLat: Double, desLng: Double) {
        if desDrawlocation != nil && desDrawlocation!.latitude == desLat && desDrawlocation!.longitude == desLng {
            // Unroute current path
            currentDrawedRoute?.map = nil
            desDrawlocation = nil
        } else {
            getRouteFromServer(desCoordinate: CLLocationCoordinate2D(latitude: desLat, longitude: desLng))
        }
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
        // Keep selected marker for perform segue to Comment view
        selectedMarker = marker
        let parkingModel = marker.userData as? ParkingZoneModel
        
        // Customize overlay appearance
        let ov = PopupDialogOverlayView.appearance()
        ov.blurEnabled = false
        ov.blurRadius  = 30
        ov.liveBlur    = false
        ov.opacity     = 0.7
        ov.color       = UIColor.black
        
        // Prepare the popup assets
        let title = parkingModel?.name
        let message = parkingModel?.address
        var image = ImageUtil.resizeImage(image: #imageLiteral(resourceName: "ic_default_image"), newWidth: 300)
        if let urlAsString = parkingModel?.imageUrl {
            if let url = URL(string: urlAsString) {
                _ = ImageUtil.loadImage(imageUrl: url.absoluteString, success: { (downloadedImage) in
                    if let imageResized = ImageUtil.resizeImage(image: downloadedImage, newWidth: 300) {
                        image = imageResized
                        // Create the dialog
                        let popup = PopupDialog(title: title, message: message, image: image)
                        
                        // Create first button
                        let buttonOne = CancelButton(title: Constant.Close.localized) {
                        }
                        
                        // Create second button
                        let buttonTwo = DefaultButton(title: Constant.Show_Route.localized) {
                            self.onBtnDrawRouteClicked(desLat: (parkingModel?.latitude)!, desLng: (parkingModel?.longitude)!)
                        }
                        
                        // Create third button
                        let buttonThree = DefaultButton(title: Constant.Detail.localized) {
                            self.onBtnDetailClicked()
                        }
                        
                        // Add buttons to dialog
                        popup.addButtons([buttonOne, buttonTwo, buttonThree])
                        
                        // Present dialog
                        self.present(popup, animated: true, completion: nil)
                    }
                })
            }
        }
        /*
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
         infoWindow.center.y -= 120 // Place infowindow above marker
         selectedMarker = marker
         self.view.addSubview(infoWindow)
         }
         */
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if selectedMarker != nil {
            infoWindow.center = mapView.projection.point(for: (selectedMarker?.position)!)
            infoWindow.center.y -= 120
        }
    }
    
    // take care of the close event
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
    }
}

extension HomeViewController: MapActionBarViewDelegate {
    func btnRatingClicked() {
        infoWindow.removeFromSuperview()
        filterState = .Rating
        let filterdData = filterDataByState(state: filterState)
        updateShowingParkings(data: filterdData)
    }
    
    func btnCarClicked() {
        infoWindow.removeFromSuperview()
        filterState = .Transport_Car
        let filterdData = filterDataByState(state: filterState)
        updateShowingParkings(data: filterdData)
    }
    
    func btnMotoClicked() {
        infoWindow.removeFromSuperview()
        filterState = .Transport_Moto
        let filterdData = filterDataByState(state: filterState)
        updateShowingParkings(data: filterdData)
    }
    
    func btnNearestClicked() {
        infoWindow.removeFromSuperview()
        filterState = .Nearest
        let filterdData = filterDataByState(state: filterState)
        updateShowingParkings(data: filterdData)
    }
    
    func btnBikeClicked() {
        infoWindow.removeFromSuperview()
        filterState = .Transport_Bike
        let filterdData = filterDataByState(state: filterState)
        updateShowingParkings(data: filterdData)
    }
    
    func unselected() {
        infoWindow.removeFromSuperview()
        filterState = .None
        let filterData = filterDataByState(state: filterState)
        updateShowingParkings(data: filterData)
    }
}

extension HomeViewController: SettingsViewControllerDelegate {
    func onSettingChanged(changed: SettingModel) {
        currentSetting = changed
        let currentRadius = currentSetting?.radius
        let queryRadius = currentRadius != nil ? currentRadius! : Constant.GeoQuery_Radius_Default
        if isSearching {
            searchGeoQuery?.removeAllObservers()
            clearSearchData()
            searchGeoQuery = startQueryForParkingZone(centerLocation: CLLocation(latitude: searedLocation!.latitude, longitude: searedLocation!.longitude), radius: queryRadius)
            drawRadiusQuery(coordinate: searedLocation!)
        } else {
            currentGeoQuery?.removeAllObservers()
            clearCurrentShowingData()
            if let currentLocation = locationManager.location {
                currentGeoQuery = startQueryForParkingZone(centerLocation: currentLocation, radius: queryRadius)
                drawRadiusQuery(coordinate: currentLocation.coordinate)
            }
        }
    }
}
