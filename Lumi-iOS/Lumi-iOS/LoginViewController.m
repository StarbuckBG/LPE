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
    LocalDataIntegration * data = [[LocalDataIntegration alloc]init];
    if ([data rememberPassword]) {
        self.Username.text = [data username];
        self.Password.text = [data password];
    }
}

-(void) successfull {
    dispatch_async(dispatch_get_main_queue(), ^{
    LocalDataIntegration * data = [[LocalDataIntegration alloc]init];
    [data setUsername:self.Username.text];
    [data setPassword:self.Password.text];
    [data setAutoLogin:self.rememberMeSwitch.on];
    
        [self.navigationController popViewControllerAnimated:YES];
    });
    
//    if (self.rememberMeSwitch.on) {
//        NSMutableDictionary* dic = [NSMutableDictionary new];
//        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"dictionaryNotFilled"];
//        USAFormPartOneViewController *viewController = (USAFormPartOneViewController *)[storyboard instantiateViewControllerWithIdentifier:@"usa1"];
//        [self.navigationController pushViewController:viewController animated:YES];
//        
//    } else {
//        PasswordViewController *viewController1 = (PasswordViewController *)[storyboard instantiateViewControllerWithIdentifier:@"pass"];
//        [self.navigationController pushViewController:viewController1 animated:YES];
//    }
//
//    
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

- (IBAction)rememberMeSwitch:(id)sender {
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
