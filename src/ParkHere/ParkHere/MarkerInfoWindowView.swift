//
//  MarkerInfoWindowView.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 3/15/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import Cosmos
import AFNetworking

@objc protocol MarkerInfoWindowViewDelegate {
    @objc optional func onBtnDrawRouteClicked(desLat: Double, desLng: Double)
    @objc optional func onBtnDetailClicked()
}

class MarkerInfoWindowView: UIView {
    
    weak var delegate: MarkerInfoWindowViewDelegate!
    
    // TODO: defined object model for marker info
    var markerInfo: ParkingZoneModel! {
        didSet {
            // Just add hardcode for demo
            name.text = markerInfo.address
            startTimeLabel.text = markerInfo.openTime
            endTimeLabel.text = markerInfo.closeTime
            ratingBar.rating = markerInfo.rating
            if let urlAsString = markerInfo.imageUrl {
                if let url = URL(string: urlAsString) {
                    imageParking.setImageWith(url)
                }
            }
        }
    }

    @IBOutlet weak var name: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var ratingBar: CosmosView!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    @IBOutlet var imageParking: UIImageView!
    
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
        //containerView.layer.cornerRadius = 10
        addSubview(containerView)
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.cgColor
        
    }

    @IBAction func btnRouteClicked(_ sender: UIButton) {
        delegate.onBtnDrawRouteClicked!(desLat: markerInfo.latitude!, desLng: markerInfo.longitude!)
    }
    
    @IBAction func btnDetailClicked(_ sender: UIButton) {
        delegate.onBtnDetailClicked!()
    }
    
}
