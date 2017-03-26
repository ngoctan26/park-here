//
//  MarkerInfoWindowView.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 3/15/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

@objc protocol MarkerInfoWindowViewDelegate {
    @objc optional func onBtnDrawRouteClicked()
    @objc optional func onBtnDetailClicked()
}

class MarkerInfoWindowView: UIView {
    
    weak var delegate: MarkerInfoWindowViewDelegate!
    
    // TODO: defined object model for marker info
    var markerInfo: ParkingZoneModel! {
        didSet {
            // Just add hardcode for demo
            name.text = markerInfo.desc
            addressLabel.text = markerInfo.address
        }
    }

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet var containerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "MarkerInfoWindowView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        containerView.frame = bounds
        addSubview(containerView)
        
    }

    @IBAction func btnRouteClicked(_ sender: UIButton) {
        delegate.onBtnDrawRouteClicked!()
    }
    
    @IBAction func btnDetailClicked(_ sender: UIButton) {
        delegate.onBtnDetailClicked!()
    }
    
}
