//
//  HamburgerViewController.swift
//  ParkHere
//
//  Created by john on 3/13/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import GooglePlaces

class HamburgerViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftMarginConstraintHeaderView: NSLayoutConstraint!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var menuIcon: UIButton!
    @IBOutlet var saveBtn: UIButton!
    
    var isMenuOpen = false;
    
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            
            contentView.addSubview(contentViewController.view)
            
            contentViewController.didMove(toParentViewController: self)
            
            searchBtn.isHidden = !(contentViewController is HomeViewController)
            saveBtn.isHidden = !(contentViewController is SettingsViewController)
            
            UIView.animate(withDuration: 0.5) {
                self.toogleMenuSettingIcon(isOpen: self.isMenuOpen, button: self.menuIcon)
                self.isMenuOpen = !self.isMenuOpen
                self.leftMarginConstraint.constant = 0
                self.leftMarginConstraintHeaderView.constant = 10
                self.view.layoutIfNeeded()
            }
        }
    }
    
    var originalLeftMargin: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        leftMarginConstraintHeaderView.constant = 10
        headerView.backgroundColor = Constant.Header_View_Background_Color
        headerView.layer.cornerRadius = 7
        saveBtn.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onMenu(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.toogleMenuSettingIcon(isOpen: self.isMenuOpen, button: sender)
            self.isMenuOpen = !self.isMenuOpen
            self.leftMarginConstraint.constant = self.leftMarginConstraint.constant != 0 ? 0 : self.view.frame.size.width - self.view.frame.size.width/2
            if self.leftMarginConstraint.constant != 0 && self.view.frame.size.width / 2 < CGFloat(Constant.Width_Of_Space_For_Icon_On_Header_View) {
                self.logo.isHidden = true
            } else {
                self.logo.isHidden = false
            }
            self.leftMarginConstraintHeaderView.constant = self.leftMarginConstraint.constant == 0 ? 10 : self.leftMarginConstraint.constant
            self.view.layoutIfNeeded()
        }
    }
    
    func toogleMenuSettingIcon(isOpen: Bool, button: UIButton) {
        if isOpen {
            button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            button.transform = CGAffineTransform(rotationAngle: 0)
        } else {
            button.transform = CGAffineTransform(rotationAngle: 0)
            button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        }
    }
    
    @IBAction func onSearchBtnClicked(_ sender: UIButton) {
        if contentViewController is HomeViewController {
            performSegue(withIdentifier: "searchPlaces", sender: nil)
        }
    }
    
    
    @IBAction func onSaveBtnClicked(_ sender: UIButton) {
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desNav = segue.destination as? UINavigationController
        if let desNav = desNav {
            if let desVC = desNav.topViewController as? SearchPlacesViewController {
                desVC.delegate = self
            }
        }
     }
}

extension HamburgerViewController: SearchPlacesViewControllerDelegate {
    func onSearchedDone(place: GMSPlace) {
        if let currentVC =  contentViewController as? HomeViewController {
            currentVC.searchPlace(place: place)
        } else if let currentVC = contentViewController as? AddingViewController {
            currentVC.searchPlace(place: place)
        }
    }
}
