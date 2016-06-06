//
//  LoginViewController.m
//  Lumi-iOS
//
//  Created by PETAR LAZAROV on 6/6/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "LoginViewController.h"
#import "DatabaseIntegration.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)LoginButton:(UIButton *)sender {
    
    DatabaseIntegration *database = [[DatabaseIntegration alloc]init];
    [database loginWithUsername:self.Username.text andPassword:self.Password.text];
//    if(loginReturn == true)
//    {
//        userDataSaving * data = [[userDataSaving alloc]init];
//        [data setCurrentUser:self.Username.text];
//        [data setCurrentPassword:self.Password.text];
//        if(self.rememberMeState == true)
//        {
//            [data setRememberMeState:true];
//        }
//        
//        [self appearLoggedInScreen];
//        [self loaddata];
//        
//        
//        
//        //        LoggedViewController *mainViewController = (LoggedViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"LoggedViewController"];
//        //        mainViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        //        [self presentViewController:mainViewController animated:YES completion:nil];
//    } else {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login unsuccessful"
//                                                        message:@"Username or/and password incorrect"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
    
    
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login unsuccessful"
//                                                                   message:@"Username or/and password incorrect"
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
//                                                            style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {
//                                                              NSLog(@"You pressed button OK");
//                                                          }];
//    [alert addAction:defaultAction];
//    [self presentViewController:alert animated:YES completion:nil];
    
//    }
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
