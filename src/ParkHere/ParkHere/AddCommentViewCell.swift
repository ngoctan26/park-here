//
//  AddCommentViewCell.swift
//  ParkHere
//
//  Created by Phong on 26/3/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import Cosmos

protocol AddCommentViewCellDelagate {
    func addCommentViewCell(addCommentViewCell: AddCommentViewCell, didSendComment text:String, rating: Double)
    func addCommentViewCellSignIn(addCommentViewCell: AddCommentViewCell)
}

class AddCommentViewCell: UITableViewCell {

    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet var baseConstraint: NSLayoutConstraint!
    
    var delegate: AddCommentViewCellDelagate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentTextField.delegate = self
        // Define identifier
        let signInNotificationName = Notification.Name(Constant.UserDidSignInNotification)
        // Register to receive notification
        NotificationCenter.default.addObserver(forName: signInNotificationName, object: nil, queue: OperationQueue.main, using: {(Notification) -> Void in
            self.reloadUser(username: (UserModel.currentUser?.name!)!)
        })
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
        delegate.addCommentViewCell(addCommentViewCell: self, didSendComment: contentTextField.text!, rating: ratingView.rating)
        contentTextField.text = ""
    }
}

extension AddCommentViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentTextField.endEditing(true)
        return false
    }
}
