//
//  LogEntriesTableViewController.swift
//  nature-logger
//
//  Created by Donat on 19.12.20.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import UIKit

class LogEntriesTableViewController: UITableViewController {
    
    private var logEntries: LogEntries?
    var poi: PointOfInterest?
    let cellIdentifier = "logEntryTemplate"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logEntries = LogEntries(poi)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        cell.logEntryImage.image = poi.loadImage()
        cell.logEntryTitle.text = poi.title
        cell.logEntryDescription.text = poi.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? EntryMapViewController, poi != nil {
            viewController.location = poi!.location
        }
    }
}
