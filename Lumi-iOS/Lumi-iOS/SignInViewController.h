//
//  SignInViewController.h
//  Lumi-iOS
//
//  Created by PETAR LAZAROV on 6/6/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGTextField.h"
#import "RGFormViewController.h"


@interface SignInViewController : RGFormViewController 

#define REGISTRATION_SUCCESSFUL @"RegistrationSuccessful"
#define REGISTRATION_NOT_SUCCESSFUL @"RegisterNotSuccessful"
#define REGISTRATION_USERNAME_NOT_AVAILABLE @"RegistrationUsernameNotAvailable"

@property (weak, nonatomic) IBOutlet UISwitch *rememberMeSwitch;

@property (weak, nonatomic) IBOutlet RGTextField *Username;
@property (weak, nonatomic) IBOutlet RGTextField *Password;
@property (weak, nonatomic) IBOutlet RGTextField *PasswordAgain;
@property (weak, nonatomic) IBOutlet RGTextField *Email;

- (IBAction)registerButton:(UIButton *)sender;
@end
