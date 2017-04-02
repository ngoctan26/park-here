//
//  SettingTimeCell.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 4/1/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import DatePickerDialog

class SettingTimeCell: UITableViewCell {
    
    weak var delegate: SettingCellDelegate?
    let diaglog = DatePickerDialog()
    
    // View references
    @IBOutlet var timeCellLabel: UILabel!
    @IBOutlet var startLabel: UILabel!
    @IBOutlet var stopLabel: UILabel!
    
    // Action references
    @IBAction func onStartClockClicked(_ sender: UIButton) {
        let currentSetTime = DateTimeUtil.dateFromString(dateAsString: startLabel.text!, format: DateTimeUtil.Time_Format_Default)
        diaglog.show(title: "Time", doneButtonTitle: "OK", cancelButtonTitle: "Cancel", defaultDate: currentSetTime!, minimumDate: nil, maximumDate: nil, datePickerMode: .time) { (pickedDate) in
            if let pickedDate = pickedDate {
                let dateAsString = DateTimeUtil.stringFromDate(date: pickedDate, format: DateTimeUtil.Time_Format_Default)
                self.startLabel.text = dateAsString
                self.delegate?.onTimeChanged(openTime: dateAsString, closedTime: nil)
            }
        }
    }
    
    @IBAction func onCloseClockClicked(_ sender: UIButton) {
        let currentSetTime = DateTimeUtil.dateFromString(dateAsString: stopLabel.text!, format: DateTimeUtil.Time_Format_Default)
        diaglog.show(title: "Time", doneButtonTitle: "OK", cancelButtonTitle: "Cancel", defaultDate: currentSetTime!, minimumDate: nil, maximumDate: nil, datePickerMode: .time) { (pickedDate) in
            if let pickedDate = pickedDate {
                let dateAsString = DateTimeUtil.stringFromDate(date: pickedDate, format: DateTimeUtil.Time_Format_Default)
                self.stopLabel.text = dateAsString
                self.delegate?.onTimeChanged(openTime: nil, closedTime: dateAsString)
            }
        }
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
