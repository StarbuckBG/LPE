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
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(userDataUpdatedNotificationHandler),
                                                         name: USERDATA_UPDATED, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        DatabaseIntegration.sharedInstance().updateUserData()
        self.profileTableView.reloadData()
        self.navigationController!.topViewController!.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Logout",
                                                                                                               style:.Plain,
                                                                                                               target: self,
                                                                                                               action: #selector(logout(_:)))
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.navigationController!.topViewController!.navigationItem.rightBarButtonItem = nil;
    }
    
    func userDataUpdatedNotificationHandler()
    {
        dispatch_async(dispatch_get_main_queue())
        {
            // reload the UI on main thread
            self.profileTableView.reloadData()
        }
    }
    
    func logout(sender: UIBarButtonItem)
    {
        if let loginViewController = storyboard?.instantiateViewControllerWithIdentifier("loginViewController") where storyboard != nil
        {
            self.presentViewController(loginViewController,animated: true) {
                //erase stored data on logout
                LocalDataIntegration.sharedInstance().logout()
            }
        }
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
            cell.detailTextLabel!.text = databaseIntegration.getPointsForLastWeek()
            break;
        case 3:
            cell.textLabel!.text = "Position"
            let position = databaseIntegration.getUserPosition()
            cell.detailTextLabel!.text =  position != 0 ? String("\(position)") : "Loading..."
            break;
        case 4:
            cell.textLabel!.text = "Hours of play"
            cell.detailTextLabel!.text = databaseIntegration.getHoursOfPlay()
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