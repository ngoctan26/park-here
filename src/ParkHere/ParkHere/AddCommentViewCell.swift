//
//  AddCommentViewCell.swift
//  ParkHere
//
//  Created by Phong on 26/3/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

protocol AddCommentViewCellDelagate {
    func addCommentViewCell(addCommentViewCell: AddCommentViewCell, didSendComment text:String)
    func addCommentViewCellSignIn(addCommentViewCell: AddCommentViewCell)
}

class AddCommentViewCell: UITableViewCell {

    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    var delegate: AddCommentViewCellDelagate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func reloadUser(username: String) {
        if username == Constant.Anonymous{
            userLabel.text = Constant.Anonymous
            linkLabel.isHidden = false
            signInButton.isHidden = false
        }else{
            userLabel.text = username
            linkLabel.isHidden = true
            signInButton.isHidden = true
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onSignInButton(_ sender: UIButton) {
        delegate.addCommentViewCellSignIn(addCommentViewCell: self)
    }

    @IBAction func onAddCommentButton(_ sender: UIButton) {
        delegate.addCommentViewCell(addCommentViewCell: self, didSendComment: contentTextField.text!)
        contentTextField.text = ""
    }
}
