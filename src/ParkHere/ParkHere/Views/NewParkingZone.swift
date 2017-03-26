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
    
    func loadTransportTypeView() {
//        let segmentedControl = MultiSelectionSegmentedControl(items: ["Segment 1", "Segment 2", "Segment 3"])
//        segmentedControl.frame = CGRect(x: transportTypeView.frame.origin.x, y: transportTypeView.frame.origin.y, width: transportTypeView.frame.size.width/2, height: transportTypeView.frame.size.height)
//        transportTypeView.addSubview(segmentedControl)
    }

}
