//
//  SettingDistanceCell.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 4/1/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

class SettingDistanceCell: UITableViewCell {
    
    weak var delegate: SettingCellDelegate?
    
    // View references
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var distanceValueLabel: UILabel!
    @IBOutlet var distanceSlider: UISlider!
    
    @IBAction func onSlideChanged(_ sender: UISlider) {
        self.distanceValueLabel.text = String(format: "%.1f", sender.value) + "km"
        self.delegate?.onDistanceChanged(radius: sender.value)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        distanceLabel.text = Constant.Distance_Label.localized
        self.distanceValueLabel.text = String(format: "%.2f", distanceSlider.value) + "km"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
