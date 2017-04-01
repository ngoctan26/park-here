//
//  MenuViewController.swift
//  ParkHere
//
//  Created by john on 3/13/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tblMenu: UITableView!
    
    private var homeNavController: UIViewController!
    private var settingsNavController: UIViewController!
    private var addingNavController: UIViewController!
    private var signInNavController: UIViewController!
    
    var hamburgerViewController: HamburgerViewController!
    
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblMenu.delegate = self
        tblMenu.dataSource = self
        tblMenu.tableFooterView = UIView()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        homeNavController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        settingsNavController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        addingNavController = storyboard.instantiateViewController(withIdentifier: "AddingViewController")
        signInNavController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        
        viewControllers.append(homeNavController)
        viewControllers.append(settingsNavController)
        viewControllers.append(addingNavController)
        viewControllers.append(signInNavController)
        
        hamburgerViewController.isMenuOpen = true   // Initialize menu state at begining
        hamburgerViewController.contentViewController = homeNavController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuViewCell", for: indexPath) as! MenuViewCell
        
        let titles = [Constant.Home_Menu_Title_Key.localized, Constant.Settings_Menu_Title_Key.localized, Constant.Adding_Menu_Title_Key.localized,Constant.SignIn_Menu_Title_Key.localized]
        switch indexPath.row {
        case 0:
            cell.lblMenuTitle.text = titles[0]
            cell.icMenu.image = #imageLiteral(resourceName: "ic_home")
            break
        case 1:
            cell.lblMenuTitle.text = titles[1]
            cell.icMenu.image = #imageLiteral(resourceName: "ic_setting")
            break
        case 2:
            cell.lblMenuTitle.text = titles[2]
            cell.icMenu.image = #imageLiteral(resourceName: "ic_compose")
            break
        case 3:
            cell.lblMenuTitle.text = titles[3]
            cell.icMenu.image = #imageLiteral(resourceName: "ic_user")
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
}
