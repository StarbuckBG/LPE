//
//  LoginViewController.h
//  Lumi-iOS
//
//  Created by PETAR LAZAROV on 6/6/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGFormViewController.h"

@interface LoginViewController : RGFormViewController

#define LOGIN_SUCCESSFUL @"LoginSuccessful"
#define LOGIN_NOT_SUCCESSFUL @"LoginUnsuccessful"

@property (weak, nonatomic) IBOutlet UISwitch *rememberMeSwitch;

@property (weak, nonatomic) IBOutlet RGTextField *Username;
@property (weak, nonatomic) IBOutlet RGTextField *Password;

@end
