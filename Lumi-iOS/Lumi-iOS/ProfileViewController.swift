//
//  ProfileViewController.swift
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 6/19/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(updateTable()), name: USERDATA_UPDATED, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTable()
    {
        profileTableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: "profileInfoCell")
        let databaseIntegration = DatabaseIntegration.sharedInstance();
        switch indexPath.row {
        case 0:
            cell.textLabel!.text = "Username"
            cell.detailTextLabel!.text = databaseIntegration.userdata.objectForKey("username") as? String
            break;
        case 1:
            cell.textLabel!.text = "All points"
            cell.detailTextLabel!.text = databaseIntegration.userdata.objectForKey("points_balance") as? String
            break;
        case 2:
            cell.textLabel!.text = "Points from last week"
            cell.detailTextLabel!.text = databaseIntegration.userdata.objectForKey("points_balance") as? String
            break;
        case 3:
            cell.textLabel!.text = "Position"
            cell.detailTextLabel!.text = "2"
            break;
        case 4:
            cell.textLabel!.text = "Hours of play"
            cell.detailTextLabel!.text = "4:12:08"
            break;
        default:
            break;
        }
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
}