//
//  CustomTableViewCell.swift
//  nature-logger
//
//  Created by Frederik Helth on 15/12/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import UIKit

class CustomTableViewCell : UITableViewCell {
    
    @IBOutlet weak var plantTitle: UILabel!
    @IBOutlet weak var plantCell: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
