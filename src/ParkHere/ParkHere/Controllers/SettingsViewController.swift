//
//  SettingsViewController.swift
//  ParkHere
//
//  Created by john on 3/13/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // View References
    @IBOutlet var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set view background
        initView()
    }

    func initView() {
        view.backgroundColor = Constant.Header_View_Background_Color
        
        // Init table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return Constant.Section_1_Title.localized
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 61
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "transportCell", for: indexPath) as! SettingTransportCell
            cell.transportLabel.text = Constant.Transport_Type_Label.localized
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath ) as! SettingTimeCell
            cell.timeCellLabel.text = Constant.Time_Setting_Label.localized
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "distanceCell", for: indexPath) as! SettingDistanceCell
            cell.distanceLabel.text = Constant.Distance_Label
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}
