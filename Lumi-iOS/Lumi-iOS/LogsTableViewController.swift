//
//  LogsTableViewController.swift
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 6/19/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

import UIKit

class LogsTableViewController: UITableViewController {

    private let databaseIntegration: DatabaseIntegration = DatabaseIntegration.sharedInstance();
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return databaseIntegration.logs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("logsTableViewControllerCell", forIndexPath: indexPath)

        cell.textLabel!.text = databaseIntegration.logs.objectAtIndex(indexPath.row).valueForKey("points") as! String + " points"
        cell.detailTextLabel!.text = databaseIntegration.logs.objectAtIndex(indexPath.row).valueForKey("start_time") as? String
        
        return cell
    }
    
}
