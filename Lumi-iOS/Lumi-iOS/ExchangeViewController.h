//
//  ExchangeViewController.h
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    IBOutlet UISlider *slider;
    IBOutlet UILabel *totalPoints;
    IBOutlet UILabel *pointsConversion;
    IBOutlet UILabel *pointsCurency;
    IBOutlet UILabel *username;
}
@property NSString* FBusername, *FBuserid;
- (IBAction) slider:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
