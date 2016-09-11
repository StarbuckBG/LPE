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
    @IBOutlet weak var termsOfUseWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        NSString *path = [[NSBundle mainBundle] pathForResource:@"document" ofType:@"pdf"];
        //        NSURL *targetURL = [NSURL fileURLWithPath:path];
        //        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        
        //        [webView loadRequest:request];
        
        let path = NSBundle.mainBundle().pathForResource("lumi-privacy", ofType: "pdf")
        let targetURL = NSURL.fileURLWithPath(path!)
        let request = NSURLRequest.init(URL: targetURL)
        termsOfUseWebView.loadRequest(request)
        // Do any additional setup after loading the view.
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



