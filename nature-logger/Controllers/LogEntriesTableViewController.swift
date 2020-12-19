//
//  LogEntriesTableViewController.swift
//  nature-logger
//
//  Created by Donat on 19.12.20.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import UIKit

class LogEntriesTableViewController: UITableViewController {
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private var logEntries: LogEntries?
    var poi: PointOfInterest?
    let cellIdentifier = "logEntryTemplate"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logEntries = LogEntries(poi)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard logEntries != nil
        else {
            return 0
        }
        return logEntries!.pois.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LogEntryTableViewCell, logEntries != nil else {
            fatalError("The dequeued cell is not an instance of LogEntryTableViewCell.")
        }
        
        let poi = logEntries!.pois[indexPath.row]
        
        if let image = poi.loadImage() {
            cell.logEntryImage.image = image
        }
        
        cell.logEntryTitle.text = poi.title
        
        cell.logEntryDescription.text = poi.description
        
        return cell
    }
}
