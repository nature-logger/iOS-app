//
//  LogEntryTableViewCell.swift
//  nature-logger
//
//  Created by Donat on 19.12.20.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import UIKit

class LogEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var logEntryTitle: UILabel!
    @IBOutlet weak var logEntryDescription: UILabel!
    @IBOutlet weak var logEntryImage: UIImageView!
    
    var poi: PointOfInterest?
    var tableImage: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
