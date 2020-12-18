//
//  LogEntriesViewController.swift
//  nature-logger
//
//  Created by Sebastian Moldt on 18/12/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import UIKit

class LogEntriesViewController: UIViewController {
    
    private var logEntries: LogEntries?
    
    func addEntry(poi: PointOfInterest) {
        logEntries = LogEntries(poi: poi)
    }
}
