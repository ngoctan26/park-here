//
//  SettingTimeCell.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 4/1/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

class SettingTimeCell: UITableViewCell {
    
    @objc weak var delegate: SettingCellDelegate?
    
    // View references
    @IBOutlet var timeCellLabel: UILabel!
    @IBOutlet var startLabel: UILabel!
    @IBOutlet var stopLabel: UILabel!
    
    // Action references
    @IBAction func onStartClockClicked(_ sender: UIButton) {
    }
    
    @IBAction func onCloseClockClicked(_ sender: UIButton) {
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
