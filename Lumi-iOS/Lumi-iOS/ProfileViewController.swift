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
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(userDataUpdatedNotificationHandler),
                                                         name: NSNotification.Name(rawValue: USERDATA_UPDATED), object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DatabaseIntegration.sharedInstance().updateUserData()
        self.profileTableView.reloadData()
        self.navigationController!.topViewController!.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Logout",
                                                                                                               style:.plain,
                                                                                                               target: self,
                                                                                                               action: #selector(logout(_:)))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController!.topViewController!.navigationItem.rightBarButtonItem = nil;
    }
    
    func userDataUpdatedNotificationHandler()
    {
        DispatchQueue.main.async
        {
            // reload the UI on main thread
            self.profileTableView.reloadData()
        }
    }
    
    func logout(_ sender: UIBarButtonItem)
    {
        if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "loginViewController"), storyboard != nil
        {
            self.present(loginViewController,animated: true) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.profileScreenOpened()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "profileInfoCell")
        let databaseIntegration = DatabaseIntegration.sharedInstance();
        switch indexPath.row {
        case 0:
            cell.textLabel!.text = "Username"
            cell.detailTextLabel!.text = databaseIntegration?.userdata.object(forKey: "username") as? String
            break;
        case 1:
            cell.textLabel!.text = "Current points"
            cell.detailTextLabel!.text = databaseIntegration?.userdata.object(forKey: "points_balance") as? String
            break;
        case 2:
            cell.textLabel!.text = "Points from last week"
            cell.detailTextLabel!.text = databaseIntegration?.getPointsForLastWeek()
            break;
        case 3:
            cell.textLabel!.text = "Position"
            let position = databaseIntegration?.getUserPosition()
            cell.detailTextLabel!.text =  position != 0 ? "\(position!)" : "Not available"
            break;
        case 4:
            cell.textLabel!.text = "Hours of play"
            cell.detailTextLabel!.text = databaseIntegration?.getHoursOfPlay()
            break;
        default:
            break;
        }
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
}
