//
//  SettingTransportCell.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 4/1/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

class SettingTransportCell: UITableViewCell {
    
    @objc weak var delegate: SettingCellDelegate?
    
    // View references
    @IBOutlet var transportLabel: UILabel!

    // Action references
    @IBAction func onTransportTypeChanged(_ sender: UISegmentedControl) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
