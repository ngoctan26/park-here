//
//  NewParkingZone.swift
//  ParkHere
//
//  Created by john on 3/25/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import ATHMultiSelectionSegmentedControl

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
        
        // self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onPost(_ sender: UIButton) {
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
        
        let segmentedControl = MultiSelectionSegmentedControl(items: ["1", "2", "3"])
        
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
