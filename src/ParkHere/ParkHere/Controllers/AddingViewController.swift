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
    
    var hamburgerViewController: HamburgerViewController!
    var homeNavController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        newParkingZoneSubView.delegate = self
        newParkingZoneSubView.frame.size.width = newParkingZoneView.frame.size.width
        newParkingZoneSubView.segmentedControl.frame.size.width = newParkingZoneSubView.frame.size.width - 20
        newParkingZoneView.contentSize = CGSize(width: newParkingZoneSubView.frame.size.width, height: newParkingZoneSubView.frame.origin.y + newParkingZoneSubView.frame.size.height + 10)
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

extension AddingViewController: NewParkingZoneDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func saveSuccessful(newParkingZone: ParkingZoneModel) {
        hamburgerViewController.contentViewController = homeNavController
    }
    
    func openPickImageController() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        newParkingZoneSubView.imgOnCapture.image = editedImage
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    func openSearchPlaceController() {
        performSegue(withIdentifier: "searchPlaces", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desNav = segue.destination as? UINavigationController {
            if let desVC = desNav.topViewController as? SearchPlacesViewController {
                desVC.delegate = self
            }
        }
    }
}

extension AddingViewController: SearchPlacesViewControllerDelegate {
    func onSearchedDone(place: GMSPlace) {
        searchPlace(place: place)
    }
}

