//
//  GuiUtil.swift
//  ParkHere
//
//  Created by john on 4/2/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation
import SVProgressHUD
import UIKit

class GuiUtil {
    
    class func showLoadingIndicator() {
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setForegroundColor(UIColor.cyan)
        SVProgressHUD.show()
    }
    
    class func dismissLoadingIndicator() {
        SVProgressHUD.dismiss()
    }
}

