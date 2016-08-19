//
//  LoginViewController.m
//  Lumi-iOS
//
//  Created by PETAR LAZAROV on 6/6/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "LoginViewController.h"
#import "DatabaseIntegration.h"
#import "LocalDataIntegration.h"
#import "Reachability.h"
#import "RDInternetData.h"

@interface LoginViewController ()
{
    LocalDataIntegration * data;
}
@end

@implementation LoginViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(successfull)
                                                 name:LOGIN_SUCCESSFUL
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notSuccessefull)
                                                 name:LOGIN_NOT_SUCCESSFUL
                                               object:nil];
    self.Username.delegate = self;
    self.Password.delegate = self;
    data = [LocalDataIntegration sharedInstance];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange) name:@"IntenetConnectionChanged" object:nil];
}
- (void)networkChange {
    RDInternetData* internetData = [RDInternetData sharedInstance];
    NSLog(@"network change: %d", internetData.hasInternet);
}

-(void) setValidation {
    [self.Username addValidationForTextFieldsWithUserName];
    [self.Password addValidationForTextFieldsWithPass];
}
//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    if ([data rememberPassword]) {
//        self.Username.text = [data username];
//        self.Password.text = [data password];
//    }
//    if ([data autoLogin]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//        [self performSegueWithIdentifier:@"goToHomeScreenSegue" sender:nil];
//        });
//    }
//}
-(void) successfull {
    dispatch_async(dispatch_get_main_queue(), ^{
    [data setUsername:self.Username.text];
    [data setPassword:self.Password.text];
    [data setAutoLogin:self.rememberMeSwitch.on];
    [data syncData];
    
        [self performSegueWithIdentifier:@"goToHomeScreenSegue" sender:nil];
    });
}
#warning will there be cancel button.
- (IBAction)cancelButtonToHomeScreen:(id)sender {
//    [self performSegueWithIdentifier:@"goToHomeScreenSegue" sender:nil];
}
-(void) notSuccessefull {
    dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login unsuccessful"
                                                                   message:@"Username or/and password incorrect"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button OK");
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    });
}


- (IBAction)registerButton:(id)sender {
    [self performSegueWithIdentifier:@"registerSegue" sender:nil];
}

- (IBAction)LoginButton:(UIButton *)sender {
    [self login];
}
-(void)login {
    DatabaseIntegration *database = [DatabaseIntegration sharedInstance];
    [database loginWithUsername:self.Username.text andPassword:self.Password.text];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.Username resignFirstResponder];
    [self.Password resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.Username) {
        [self.Username resignFirstResponder];
        [self.Password becomeFirstResponder];
    } else if (textField == self.Password) {
        [self.Password resignFirstResponder];
        [self login];
    }    
    return NO;
}


@end
