//
//  MapView.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 3/21/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

@objc protocol MapViewDelegate {
    @objc optional func onLongPressed(locationOnMap: CLLocationCoordinate2D)
}

class MapView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet var showingMap: GMSMapView!
    
    weak var mapViewDelegate: MapViewDelegate!
    var isLongPressedEnable = false
    lazy var longPressRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: "MapView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        containerView.frame = bounds
        addSubview(containerView)
        initMapView()
    }
    
    private func initMapView() {
        showingMap.isMyLocationEnabled = true
    }

    /**
     Enable long press to add marker in map view. Should add delegate to hanlde longpress result
    */
    func setLongPressEnable(isEnable: Bool) {
        if isEnable {
            showingMap.addGestureRecognizer(longPressRecognizer)
        } else {
            showingMap.removeGestureRecognizer(longPressRecognizer)
        }
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            let longPressPoint = recognizer.location(in: showingMap)
            let coordinate = showingMap.projection.coordinate(for: longPressPoint)
            mapViewDelegate.onLongPressed!(locationOnMap: coordinate)
        }
    }
    
    /**
     Drawing route from points.
     - parameter points: Get from overview_polyline in direction APIs
    */
    func drawRoute(points: String) -> GMSPolyline {
        let path: GMSPath = GMSPath(fromEncodedPath: points)!
        let routePolynline = GMSPolyline(path: path)
        routePolynline.map = showingMap
        return routePolynline
    }
    
    func moveCamera(inputLocation: CLLocationCoordinate2D, animate: Bool) {
        let positionCamera = GMSCameraPosition.camera(withLatitude: inputLocation.latitude, longitude: inputLocation.longitude, zoom: Constant.Normal_Zoom_Ratio)
        if animate {
            showingMap.animate(to: positionCamera)
        } else {
            showingMap.camera = positionCamera
        }
    }
    
    func addMarker(parkingZones: [ParkingZoneModel], textInfo: String?, markerIcon: UIImage?) -> [GMSMarker] {
        var markerList: [GMSMarker] = []
        for parkingZone in parkingZones {
            let coordinate = CLLocationCoordinate2D(latitude: parkingZone.latitude!, longitude: parkingZone.longitude!)
            let createdMarker = addMarker(coordinate: coordinate, textInfo: nil, markerIcon: nil)
            markerList.append(createdMarker)
        }
        return markerList
    }
    
    func addMarker(lat: Double, long: Double, textInfo: String?, markerIcon: UIImage?) -> GMSMarker {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        return addMarker(coordinate: coordinate, textInfo: textInfo, markerIcon: markerIcon)
    }
    
    private func addMarker(coordinate: CLLocationCoordinate2D, textInfo: String?, markerIcon: UIImage?) -> GMSMarker {
        let marker = GMSMarker(position: coordinate)
        marker.map = showingMap
        if textInfo != nil {
            // add small text above marker. Can be addresses
            marker.snippet = textInfo
        }
        if markerIcon == nil {
            // Add default icon red marker
            marker.icon = GMSMarker.markerImage(with: UIColor.red)
        } else {
            marker.icon = markerIcon
        }
        return marker
    }
}
