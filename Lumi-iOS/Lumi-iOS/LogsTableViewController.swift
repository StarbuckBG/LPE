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

    fileprivate let databaseIntegration: DatabaseIntegration = DatabaseIntegration.sharedInstance();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(logsUpdatedNotificationHandler), name: NSNotification.Name(rawValue: LOGS_UPDATED), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.logScreenOpened()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (DatabaseIntegration.sharedInstance().logs != nil) ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return databaseIntegration.logs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logsTableViewControllerCell", for: indexPath)

        cell.textLabel!.text = (databaseIntegration.logs.object(at: indexPath.row) as AnyObject).value(forKey: "points") as! String + " points"
        cell.detailTextLabel!.text = (databaseIntegration.logs.object(at: indexPath.row) as AnyObject).value(forKey: "start_time") as? String
        
        return cell
    }
    
    func logsUpdatedNotificationHandler(_ aNotification:Notification)
    {
        self.logTableView.reloadData()
    }
    
}
