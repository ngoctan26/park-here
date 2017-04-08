//
//  CommentMapCell.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 4/9/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import GoogleMaps

class CommentMapCell: UITableViewCell {
    @IBOutlet var commentMap: MapView!
    var zoneMarker: GMSMarker?
    
    var parkingLocation: CLLocationCoordinate2D? {
        didSet {
            commentMap.moveCamera(inputLocation: parkingLocation!, animate: false)
            zoneMarker = commentMap.addMarker(lat: (parkingLocation?.latitude)!, long: (parkingLocation?.longitude)!, textInfo: nil, markerIcon: nil)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commentMap.showHideSearchBtn(isHide: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
