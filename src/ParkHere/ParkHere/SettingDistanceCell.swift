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
        self.distanceValueLabel.text = String(format: "%d", Int(sender.value)) + "m"
        self.delegate?.onDistanceChanged(radius: sender.value)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        distanceLabel.text = Constant.Distance_Label.localized
        distanceSlider.value = 500
        self.distanceValueLabel.text = String(format: "%d", Int(distanceSlider.value)) + "m"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
