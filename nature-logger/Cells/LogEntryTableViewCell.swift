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
    @IBOutlet weak var logEntryImage: UIImageView!
    @IBOutlet weak var logEntryDescription: UITextView!
    
    var poi: PointOfInterest?
    var tableImage: UIImage?
}
