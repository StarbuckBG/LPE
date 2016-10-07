//
//  InfoViewController.swift
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 9/11/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

import UIKit
import MessageUI

class InfoViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.versionLabel.text = "Version \(UIApplication.appVersion()) (\(UIApplication.build()))"
        self.navigationController!.navigationBar.topItem!.title = "Back"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func contactUsButtonTapped(sender: UIBarButtonItem) {
        let emailTitle = "Lumi iOS User Feedback"
        let messageBody = "Please input your feedback"
        let toRecepients = ["support@playgroundenergy.com"]
        let mailComposerViewControler = MFMailComposeViewController.init()
        mailComposerViewControler.setSubject(emailTitle)
        mailComposerViewControler.setMessageBody(messageBody, isHTML: false)
        mailComposerViewControler.setToRecipients(toRecepients)
        mailComposerViewControler.mailComposeDelegate = self
        
        self.presentViewController(mailComposerViewControler, animated: true) {
            // do nothing
        }
        
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true) { 
            //do nothing
        }
    }
    
}



