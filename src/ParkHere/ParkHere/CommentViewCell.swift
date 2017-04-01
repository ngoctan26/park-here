//
//  CommentViewCell.swift
//  ParkHere
//
//  Created by Phong on 26/3/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import Cosmos

class CommentViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
