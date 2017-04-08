//
//  CommentInfoCell.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 4/9/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

class CommentInfoCell: UITableViewCell {
    @IBOutlet var addressLb: UILabel!
    @IBOutlet var vehicleLb: UILabel!
    @IBOutlet var priceLb: UILabel!
    @IBOutlet var openTimeLb: UILabel!
    @IBOutlet var closeTimeLb: UILabel!
    @IBOutlet var descriptionLb: UILabel!
    @IBOutlet var addressTitleLabel: UILabel!
    @IBOutlet var vehicleTitleLabel: UILabel!
    @IBOutlet var priceTitleLabel: UILabel!
    @IBOutlet var openTitleLabel: UILabel!
    @IBOutlet var closeTitleLabel: UILabel!
    @IBOutlet var descriptionTitleLabel: UILabel!
    
    var parkingModel: ParkingZoneModel? {
        didSet {
            var vehicle: String = ""
            if parkingModel?.transportTypes != nil {
                for (_, element) in (parkingModel?.transportTypes!.enumerated())! {
                    vehicle += element.rawValue + ", "
                }
                
                let splitIndex = vehicle.index(vehicle.endIndex, offsetBy: -2)
                vehicle = vehicle.substring(to: splitIndex)
            }
            
            if parkingModel?.address != nil {
                addressLb.text = parkingModel?.address!
            }
            priceLb.text = parkingModel?.prices?.joined(separator: ", ")
            vehicleLb.text = vehicle
            openTimeLb.text = parkingModel?.openTime
            closeTimeLb.text = parkingModel?.closeTime
            descriptionLb.text = parkingModel?.desc
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addressTitleLabel.text = Constant.Address_Title.localized
        vehicleTitleLabel.text = Constant.Vehicle_Title.localized
        priceTitleLabel.text = Constant.Price_Title.localized
        openTitleLabel.text = Constant.OpenTime_Title.localized
        closeTitleLabel.text = Constant.CloseTime_Title.localized
        descriptionTitleLabel.text = Constant.Description_Title.localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
