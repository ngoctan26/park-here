//
//  NewParkingZone.swift
//  ParkHere
//
//  Created by john on 3/25/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import ATHMultiSelectionSegmentedControl
import GooglePlaces
import GoogleMaps
import GeoFire

@objc protocol NewParkingZoneDelegate {
    @objc func saveSuccessful(newParkingZone: ParkingZoneModel)
    @objc func openPickImageController()
}

class NewParkingZone: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var containerCtrlView: UIView!
    @IBOutlet weak var transportTypeView: UIView!
    @IBOutlet weak var workingTimeView: UIView!
    @IBOutlet weak var imageCtrlView: UIView!
    @IBOutlet weak var buttonCtrlView: UIView!
    
    @IBOutlet weak var mapView: MapView!
    
    @IBOutlet weak var txtName: UITextView!
    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet weak var txtAddress: UITextView!
    
    @IBOutlet weak var imgOnCapture: UIImageView!
    
    @IBOutlet weak var btnPost: UIButton!
    
    var searchMarker: GMSMarker?
    
    var selectedPlace: GMSPlace? {
        didSet {
            txtAddress.text = selectedPlace?.formattedAddress
            txtName.text = txtName.text == Constant.Name_Place_Holder.localized ? selectedPlace?.name : txtName.text
            txtName.textColor = .black
        }
    }
    
    weak var delegate: NewParkingZoneDelegate!
    
    var segmentedControl = MultiSelectionSegmentedControl(items: ["B", "M", "C"])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
        loadTransportTypeView()
        setupTextView()
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubView()
        loadTransportTypeView()
    }
    
    func initSubView() {
        let nib = UINib(nibName: "NewParkingZone", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        containerCtrlView.frame = bounds
        
        addSubview(containerCtrlView)
    }
    
    @IBAction func onCaptureImage(_ sender: UIButton) {
        delegate.openPickImageController()
    }
    
    @IBAction func onPost(_ sender: UIButton) {
        let newParkingZone = ParkingZoneModel()
        newParkingZone.desc = txtDesc.text
        newParkingZone.name = txtName.text
        newParkingZone.rating = 0.0
        
        newParkingZone.latitude = selectedPlace?.coordinate.latitude
        newParkingZone.longitude = selectedPlace?.coordinate.longitude
        newParkingZone.address = selectedPlace?.formattedAddress
        
        newParkingZone.createdAt = DateTimeUtil.stringFromDate(date: Date())
        
        // dummy value
        newParkingZone.closeTime = "23"
        newParkingZone.openTime = "5"
        // newParkingZone.imageUrl = "dummy url"
        newParkingZone.transportTypes = [TransportTypeEnum.Bicycle, TransportTypeEnum.Motorbike, TransportTypeEnum.Car]
        newParkingZone.prices = ["5", "10", "15"]
        
        FirebaseService.getInstance().addParkingZone(newParkingZone: newParkingZone) { 
            self.delegate.saveSuccessful(newParkingZone: newParkingZone)
        }
    }
    
    
    func setupTextView() {
        txtName.delegate = self
        txtName.text = Constant.Name_Place_Holder.localized
        txtName.textColor = .lightGray
        
        txtDesc.delegate = self
        txtDesc.text = Constant.Desc_Place_Holder.localized
        txtDesc.textColor = .lightGray
        
        txtAddress.delegate = self
        txtAddress.text = Constant.Address_Place_Holder.localized
        txtAddress.textColor = .lightGray
        
        // register noti/tap for keyboard
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        tapToDimissKeyboard()
    }
    
    func loadTransportTypeView() {
        self.transportTypeView.layoutIfNeeded()
        
        segmentedControl.frame = CGRect(x: 0, y: 0, width: transportTypeView.frame.size.width - 40, height: transportTypeView.frame.size.height)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.frame.size.width = transportTypeView.frame.size.width
        
        transportTypeView.addSubview(segmentedControl)
    }
    
    func setupButton() {
        btnPost.setImage(#imageLiteral(resourceName: "post"), for: .normal)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        // dismiss(animated: true, completion: nil)
    }
    
    func searchPlace(place: GMSPlace) {
        let searchCoordinate = place.coordinate
        mapView.moveCamera(inputLocation: place.coordinate, animate: true)
        searchMarker = mapView.addMarker(lat: searchCoordinate.latitude, long: searchCoordinate.longitude, textInfo: nil, markerIcon: #imageLiteral(resourceName: "ic_search_marker"))
    }
}

extension NewParkingZone: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        var changed: Bool = true
        
        changed = textView.restorationIdentifier == "txtName" ? textView.text == Constant.Name_Place_Holder.localized : textView.text == Constant.Desc_Place_Holder.localized
        
        if changed {
            textView.text = Constant.Empty_String
            textView.textColor = .black
        }
        
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == Constant.Empty_String {
            textView.text = textView.restorationIdentifier == "txtName" ? Constant.Name_Place_Holder.localized : Constant.Desc_Place_Holder.localized
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}

// MARK: - Keyboard functions
extension NewParkingZone {
    
    func adjustInsetForKeyboardShow(notification: NSNotification) {
        guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        adjustInsetForKeyboardShow(notification: notification)
    }
    
    func tapToDimissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        containerCtrlView.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        containerCtrlView.endEditing(true)
    }
}
