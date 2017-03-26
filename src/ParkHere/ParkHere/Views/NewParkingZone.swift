//
//  NewParkingZone.swift
//  ParkHere
//
//  Created by john on 3/25/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import ATHMultiSelectionSegmentedControl

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
    
    @IBOutlet weak var imgOnCapture: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
        loadTransportTypeView()
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
    }
    
    func loadTransportTypeView() {
        let segmentedControl = MultiSelectionSegmentedControl(items: ["1", "2", "3"])
        
        segmentedControl.frame = CGRect(x: 0, y: 0, width: transportTypeView.frame.size.width - 40, height: transportTypeView.frame.size.height)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        transportTypeView.addSubview(segmentedControl)
        
        self.transportTypeView.layoutIfNeeded()
        
        let widthConstraint = NSLayoutConstraint(item: segmentedControl, attribute: .width, relatedBy: .equal, toItem: transportTypeView, attribute: .width, multiplier: 1.0, constant: 0.0)
        
//        NSLayoutConstraint.activate([widthConstraint])
    }

}
