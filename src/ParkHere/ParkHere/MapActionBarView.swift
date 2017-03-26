//
//  MapActionBarView.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 3/25/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

@objc protocol MapActionBarViewDelegate {
    @objc func btnBikeClicked()
    @objc func btnMotoClicked()
    @objc func btnCarClicked()
    @objc func btnPriceClicked()
    @objc func btnNearestClicked()
    @objc func btnRatingClicked()
}

class MapActionBarView: UIView {
    // View references
    @IBOutlet var containerView: UIView!
    
    weak var delegate: MapActionBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: "MapActionBarView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        containerView.frame = bounds
        addSubview(containerView)
        containerView.layer.cornerRadius = 15
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.backgroundColor = UIColor.clear
    }
    
    // Action references
    @IBAction func onBtnClicked(_ sender: UIButton) {
        switch sender.restorationIdentifier! {
        case "btnBike":
            delegate?.btnBikeClicked()
            break
        case "btnMoto":
            delegate?.btnMotoClicked()
            break
        case "btnCar":
            delegate?.btnCarClicked()
            break
        case "btnPrice":
            delegate?.btnPriceClicked()
            break
        case "btnNearest":
            delegate?.btnNearestClicked()
            break
        case "btnRating":
            delegate?.btnRatingClicked()
            break
        default:
            return
        }
    }
    
}
