//
//  LogsTableViewController.swift
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 6/19/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

import UIKit

class LogsTableViewController: UITableViewController {
    @IBOutlet weak var logTableView: UITableView!

    private let databaseIntegration: DatabaseIntegration = DatabaseIntegration.sharedInstance();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(logsUpdatedNotificationHandler), name: LOGS_UPDATED, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (DatabaseIntegration.sharedInstance().logs != nil) ? 1 : 0
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
    
    func logsUpdatedNotificationHandler(aNotification:NSNotification)
    {
        self.logTableView.reloadData()
    }
    
}
