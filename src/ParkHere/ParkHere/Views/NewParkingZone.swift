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
import NHRangeSlider
import Toast_Swift

@objc protocol NewParkingZoneDelegate {
    @objc func saveSuccessful(newParkingZone: ParkingZoneModel)
    @objc func openPickImageController()
    @objc func openSearchPlaceController()
    @objc func cancel()
}

class NewParkingZone: UIView {
    
    @IBOutlet var containerCtrlView: UIView!
    @IBOutlet weak var transportTypeView: UIView!
    @IBOutlet weak var workingTimeView: UIView!
    @IBOutlet weak var imageCtrlView: UIView!
    @IBOutlet weak var buttonCtrlView: UIView!
    
    @IBOutlet weak var mapView: MapView!
    
    @IBOutlet weak var txtName: UITextView!
    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet weak var txtAddress: UITextView!
    @IBOutlet weak var inside: UIView!
    
    @IBOutlet weak var imgOnCapture: UIImageView!
    
    @IBOutlet weak var btnPost: UIButton!
    
    var searchMarker: GMSMarker?
    var currentLocation: CLLocationCoordinate2D? {
        didSet {
            if let currentLocation = currentLocation {
                mapView.moveCamera(inputLocation: currentLocation, animate: true)
            }
        }
    }
    
    var selectedPlace: GMSPlace? {
        didSet {
            txtAddress.text = selectedPlace?.formattedAddress
            txtName.text = txtName.text == Constant.Name_Place_Holder.localized ? selectedPlace?.name : txtName.text
            txtName.textColor = .black
        }
    }
    
    var openTime: String?
    var closeTime: String?
    var transports: [TransportTypeEnum]?
    
    weak var delegate: NewParkingZoneDelegate!
    
    var segmentedControl = MultiSelectionSegmentedControl(items: ["🚲", "🏍", "🚗"])
    var rangeSlider = NHRangeSliderView(frame: CGRect(x: 0, y: 0, width: 400, height: 30))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
        loadTransportTypeView()
        setupTextView()
        setupButton()
        setupRangeSlider()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubView()
        loadTransportTypeView()
    }
    
    @IBAction func onCaptureImage(_ sender: UIButton) {
        delegate.openPickImageController()
    }
    
    @IBAction func onPost(_ sender: UIButton) {
        if !validateBeforPost() {
            return
        }
        GuiUtil.showLoadingIndicator()
        
        let newParkingZone = ParkingZoneModel()
        newParkingZone.desc = txtDesc.text
        newParkingZone.name = txtName.text
        newParkingZone.rating = 0.0
        
        newParkingZone.latitude = selectedPlace?.coordinate.latitude
        newParkingZone.longitude = selectedPlace?.coordinate.longitude
        newParkingZone.address = selectedPlace?.formattedAddress
        
        newParkingZone.createdAt = DateTimeUtil.stringFromDate(date: Date())
        newParkingZone.closeTime = closeTime
        newParkingZone.openTime = openTime
        
        newParkingZone.transportTypes = transports
        
        // dummy value
        newParkingZone.prices = ["2000", "5000", "20000"]
        
        FirebaseService.getInstance().uploadImage(image: imgOnCapture.image!, failure: { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
            newParkingZone.imageUrl = "dummyUrl"
            FirebaseService.getInstance().addParkingZone(newParkingZone: newParkingZone) {
                self.reset()
                GuiUtil.dismissLoadingIndicator()
                self.delegate.saveSuccessful(newParkingZone: newParkingZone)
            }
        }) { (imgUrl) in
            newParkingZone.imageUrl = imgUrl
            FirebaseService.getInstance().addParkingZone(newParkingZone: newParkingZone) {
                self.reset()
                GuiUtil.dismissLoadingIndicator()
                self.delegate.saveSuccessful(newParkingZone: newParkingZone)
            }
        }
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        delegate.cancel()
    }
    
    func validateBeforPost() -> Bool {
        if selectedPlace == nil {
            self.makeToast("Error: Input missing information")
            return false
        }
        return true
    }
}

// MARK: - Setup view
extension NewParkingZone {
    
    func initSubView() {
        let nib = UINib(nibName: "NewParkingZone", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        containerCtrlView.frame = bounds
        mapView.mapViewDelegate = self
        addSubview(containerCtrlView)
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
        
        segmentedControl.delegate = self
        
        transportTypeView.addSubview(segmentedControl)
    }
    
    func setupButton() {
    }
    
    func setupRangeSlider() {
        
        rangeSlider.frame.size.width = workingTimeView.frame.size.width
        rangeSlider.trackHighlightTintColor = UIColor.blue
        rangeSlider.minimumValue = 0
        rangeSlider.maximumValue = 24
        rangeSlider.stepValue = 1
        rangeSlider.lowerValue = 5
        rangeSlider.upperValue = 22
        rangeSlider.thumbLabelStyle = .FOLLOW
        rangeSlider.lowerDisplayStringFormat = "%.0f " + Constant.Hour.localized
        rangeSlider.upperDisplayStringFormat = "%.0f " + Constant.Hour.localized
        rangeSlider.sizeToFit()
        rangeSlider.delegate = self
        rangeSlider.translatesAutoresizingMaskIntoConstraints = false
        
        inside.addSubview(rangeSlider)
    }
    
    func reset() {
        imgOnCapture.image = #imageLiteral(resourceName: "parkhere")
        selectedPlace = nil
        txtName.text = Constant.Name_Place_Holder.localized
        txtDesc.text = Constant.Desc_Place_Holder.localized
        txtAddress.text = Constant.Address_Place_Holder.localized
        segmentedControl.selectedSegmentIndices = []
        rangeSlider.upperValue = 24
        rangeSlider.lowerValue = 0
    }
}

// MARK: - RangeSlider delegate processing
extension NewParkingZone: NHRangeSliderViewDelegate {    
    func sliderValueChanged(slider: NHRangeSlider?) {
        openTime = "\(slider?.lowerValue)"
        closeTime = "\(slider?.upperValue)"
    }
}

// MARK: - MultiSelectionSegmentedControlDelegate processing
extension NewParkingZone: MultiSelectionSegmentedControlDelegate {
    func multiSelectionSegmentedControl(_ control: MultiSelectionSegmentedControl, selectedIndices indices: [Int]) {
        transports = []
        for i in indices {
            if i == 0 {
                transports?.append(TransportTypeEnum.Bicycle)
            } else if i == 1 {
                transports?.append(TransportTypeEnum.Motorbike)
            } else if i == 2 {
                transports?.append(TransportTypeEnum.Car)
            }
        }
    }
}

// MARK: - UITextView delegate processing
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
        guard (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue) != nil else { return }
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

// MARK: - Custom MapView delegate processing
extension NewParkingZone: MapViewDelegate {
    func onSearchClicked() {
        delegate.openSearchPlaceController()
    }
}
