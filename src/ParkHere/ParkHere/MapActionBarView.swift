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
    @objc func unselected()
}

class MapActionBarView: UIView {
    // View references
    @IBOutlet var containerView: UIView!
    @IBOutlet var btnBike: UIButton!
    @IBOutlet var btnMoto: UIButton!
    @IBOutlet var btnCar: UIButton!
    @IBOutlet var btnPrice: UIButton!
    @IBOutlet var btnNearest: UIButton!
    @IBOutlet var btnRating: UIButton!
    
    let BlurTagView = 1
    var blurViews: [UIVisualEffectView] = []
    // buttons state order (true is selected, false is unselected): btnBike, btnMoto, btnCar, btnPrice, btnNearest, btnRating
    var btnStates: [Bool] = [false, false, false, false, false, false]
    var selectedPos = -1
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
//        containerView.layer.cornerRadius = 15
//        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.backgroundColor = UIColor.clear
    }
    
    // Action references
    @IBAction func onBtnClicked(_ sender: UIButton) {
        switch sender.restorationIdentifier! {
        case "btnBike":
            if selectedPos == 0 {
                // is selected befor
                btnBike.setImage(#imageLiteral(resourceName: "ic_bike_unselect"), for: .normal)
                removeAllBlurAndReturnUnseleted()
            } else {
                btnStates[0] = true
                btnCar.setImage(#imageLiteral(resourceName: "ic_car_unselect"), for: .normal)
                btnMoto.setImage(#imageLiteral(resourceName: "ic_motor_unselect"), for: .normal)
                btnNearest.setImage(#imageLiteral(resourceName: "ic_nearest_unselect"), for: .normal)
                btnPrice.setImage(#imageLiteral(resourceName: "ic_price_unselect"), for: .normal)
                btnRating.setImage(#imageLiteral(resourceName: "ic_rating_unselect"), for: .normal)
                if selectedPos != -1 {
                    btnStates[selectedPos] = false
                }
                selectedPos = 0
                btnBike.setImage(#imageLiteral(resourceName: "ic_bike_select"), for: .normal)
                delegate?.btnBikeClicked()
            }
            break
        case "btnMoto":
            if selectedPos == 1 {
                // is selected befor
                removeAllBlurAndReturnUnseleted()
            } else {
                btnStates[1] = true
                btnCar.setImage(#imageLiteral(resourceName: "ic_car_unselect"), for: .normal)
                btnBike.setImage(#imageLiteral(resourceName: "ic_bike_unselect"), for: .normal)
                btnNearest.setImage(#imageLiteral(resourceName: "ic_nearest_unselect"), for: .normal)
                btnPrice.setImage(#imageLiteral(resourceName: "ic_price_unselect"), for: .normal)
                btnRating.setImage(#imageLiteral(resourceName: "ic_rating_unselect"), for: .normal)
                if selectedPos != -1 {
                    btnStates[selectedPos] = false
                }
                btnMoto.setImage(#imageLiteral(resourceName: "ic_motor_select"), for: .normal)
                selectedPos = 1
                delegate?.btnMotoClicked()
            }
            break
        case "btnCar":
            if selectedPos == 2 {
                // is selected befor
                removeAllBlurAndReturnUnseleted()
            } else {
                btnStates[2] = true
                btnBike.setImage(#imageLiteral(resourceName: "ic_bike_unselect"), for: .normal)
                btnMoto.setImage(#imageLiteral(resourceName: "ic_motor_unselect"), for: .normal)
                btnNearest.setImage(#imageLiteral(resourceName: "ic_nearest_unselect"), for: .normal)
                btnPrice.setImage(#imageLiteral(resourceName: "ic_price_unselect"), for: .normal)
                btnRating.setImage(#imageLiteral(resourceName: "ic_rating_unselect"), for: .normal)
                if selectedPos != -1 {
                    btnStates[selectedPos] = false
                }
                btnCar.setImage(#imageLiteral(resourceName: "ic_car_select"), for: .normal)
                selectedPos = 2
                delegate?.btnCarClicked()
            }
            break
        case "btnPrice":
            if selectedPos == 3 {
                // is selected befor
                removeAllBlurAndReturnUnseleted()
            } else {
                btnStates[3] = true
                btnCar.setImage(#imageLiteral(resourceName: "ic_car_unselect"), for: .normal)
                btnMoto.setImage(#imageLiteral(resourceName: "ic_motor_unselect"), for: .normal)
                btnNearest.setImage(#imageLiteral(resourceName: "ic_nearest_unselect"), for: .normal)
                btnBike.setImage(#imageLiteral(resourceName: "ic_bike_unselect"), for: .normal)
                btnRating.setImage(#imageLiteral(resourceName: "ic_rating_unselect"), for: .normal)
                if selectedPos != -1 {
                    btnStates[selectedPos] = false
                }
                btnPrice.setImage(#imageLiteral(resourceName: "ic_price_select"), for: .normal)
                selectedPos = 3
                delegate?.btnPriceClicked()
            }
            break
        case "btnNearest":
            if selectedPos == 4 {
                // is selected befor
                removeAllBlurAndReturnUnseleted()
            } else {
                btnStates[4] = true
                btnCar.setImage(#imageLiteral(resourceName: "ic_car_unselect"), for: .normal)
                btnMoto.setImage(#imageLiteral(resourceName: "ic_motor_unselect"), for: .normal)
                btnBike.setImage(#imageLiteral(resourceName: "ic_bike_unselect"), for: .normal)
                btnPrice.setImage(#imageLiteral(resourceName: "ic_price_unselect"), for: .normal)
                btnRating.setImage(#imageLiteral(resourceName: "ic_rating_unselect"), for: .normal)
                if selectedPos != -1 {
                    btnStates[selectedPos] = false
                }
                btnNearest.setImage(#imageLiteral(resourceName: "ic_nearest_select"), for: .normal)
                selectedPos = 4
                delegate?.btnNearestClicked()
            }
            break
        case "btnRating":
            if selectedPos == 5 {
                // is selected befor
                removeAllBlurAndReturnUnseleted()
            } else {
                btnStates[5] = true
                btnCar.setImage(#imageLiteral(resourceName: "ic_car_unselect"), for: .normal)
                btnMoto.setImage(#imageLiteral(resourceName: "ic_motor_unselect"), for: .normal)
                btnNearest.setImage(#imageLiteral(resourceName: "ic_nearest_unselect"), for: .normal)
                btnPrice.setImage(#imageLiteral(resourceName: "ic_price_unselect"), for: .normal)
                btnBike.setImage(#imageLiteral(resourceName: "ic_bike_unselect"), for: .normal)
                if selectedPos != -1 {
                    btnStates[selectedPos] = false
                }
                btnRating.setImage(#imageLiteral(resourceName: "ic_rating_select"), for: .normal)
                selectedPos = 5
                delegate?.btnRatingClicked()
            }
            break
        default:
            return
        }
    }
    
    func removeAllBlurAndReturnUnseleted() {
        btnCar.setImage(#imageLiteral(resourceName: "ic_car_unselect"), for: .normal)
        btnMoto.setImage(#imageLiteral(resourceName: "ic_motor_unselect"), for: .normal)
        btnNearest.setImage(#imageLiteral(resourceName: "ic_nearest_unselect"), for: .normal)
        btnPrice.setImage(#imageLiteral(resourceName: "ic_price_unselect"), for: .normal)
        btnBike.setImage(#imageLiteral(resourceName: "ic_bike_unselect"), for: .normal)
        btnRating.setImage(#imageLiteral(resourceName: "ic_rating_unselect"), for: .normal)
        selectedPos = -1
        delegate?.unselected()
    }
}
