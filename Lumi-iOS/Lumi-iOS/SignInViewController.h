//
//  SignInViewController.h
//  Lumi-iOS
//
//  Created by PETAR LAZAROV on 6/6/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *Username;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *PasswordAgain;
@property (weak, nonatomic) IBOutlet UITextField *Email;
- (IBAction)registerButton:(UIButton *)sender;
- (BOOL)IsValidEmail:(NSString *)string;
@end
