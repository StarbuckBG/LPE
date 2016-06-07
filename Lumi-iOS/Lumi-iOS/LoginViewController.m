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

@interface LoginViewController ()

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
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    LocalDataIntegration * data = [[LocalDataIntegration alloc]init];
    if ([data rememberPassword]) {
        self.Username.text = [data username];
        self.Password.text = [data password];
    }
    if ([data autoLogin]) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"goToHomeScreenSegue" sender:nil];
        });
    }
}
-(void) successfull {
    dispatch_async(dispatch_get_main_queue(), ^{
    LocalDataIntegration * data = [[LocalDataIntegration alloc]init];
    [data setUsername:self.Username.text];
    [data setPassword:self.Password.text];
    [data setAutoLogin:self.rememberMeSwitch.on];
    
        [self performSegueWithIdentifier:@"goToHomeScreenSegue" sender:nil];
    });
}
- (IBAction)cancelButtonToHomeScreen:(id)sender {
    [self performSegueWithIdentifier:@"goToHomeScreenSegue" sender:nil];
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
    
    DatabaseIntegration *database = [[DatabaseIntegration alloc]init];
    [database loginWithUsername:self.Username.text andPassword:self.Password.text];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.Username resignFirstResponder];
    [self.Password resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.Username) {
        [self.Username resignFirstResponder];
    }
    if (self.Password) {
        [self.Password resignFirstResponder];
    }    
    return NO;
}
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 170.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 170.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}

@end
