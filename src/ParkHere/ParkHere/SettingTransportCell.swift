//
//  SettingTransportCell.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 4/1/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

class SettingTransportCell: UITableViewCell {
    
    weak var delegate: SettingCellDelegate?
    
    // View references
    @IBOutlet var transportLabel: UILabel!
    @IBOutlet var transportSegment: UISegmentedControl!
    lazy var transportTypes = [TransportTypeEnum.Bicycle, TransportTypeEnum.Motorbike, TransportTypeEnum.Car, TransportTypeEnum.All]

    // Action references
    @IBAction func onTransportTypeChanged(_ sender: UISegmentedControl) {
        delegate?.onTransportChanged(type: transportTypes[sender.selectedSegmentIndex])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transportSegment.selectedSegmentIndex = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
