//
//  SignInViewController.m
//  Lumi-iOS
//
//  Created by PETAR LAZAROV on 6/6/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "SignInViewController.h"
#import "DatabaseIntegration.h"
#import "LocalDataIntegration.h"

@interface SignInViewController ()

@end

@implementation SignInViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.Password.secureTextEntry = true;
    self.PasswordAgain.secureTextEntry = true;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(successfull)
                                                 name:REGISTRATION_SUCCESSFUL
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notSuccessefull)
                                                 name:REGISTRATION_NOT_SUCCESSFUL
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userNameNotFree)
                                                 name:REGISTRATION_USERNAME_NOT_AVAILABLE
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) successfull {
    dispatch_async(dispatch_get_main_queue(), ^{
        LocalDataIntegration * data = [[LocalDataIntegration alloc]init];
        [data setUsername:self.Username.text];
        [data setPassword:self.Password.text];
        [data setRememberPassword:self.rememberMeSwitch.on];
        
        [self.navigationController popViewControllerAnimated:YES];
    });
}
-(void) notSuccessefull {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Registration unsuccessful"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button OK");
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void) userNameNotFree {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Registration unsuccessful"
                                                                   message:@"Username not available"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button OK");
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)registerButton:(UIButton *)sender {
    if([self.Password.text isEqualToString:self.PasswordAgain.text] == false)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Registration unsuccessful"
                                                                       message:@"Passwords doesn't match"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button OK");
                                                              }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(self.Username.text.length < 5)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Registration unsuccessful"
                                                                       message:@"Username must consist of 6 or more characters"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button OK");
                                                              }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(self.Password.text.length < 5)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Registration unsuccessful"
                                                                       message:@"Password must consist of 6 or more characters"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button OK");
                                                              }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        
        
        /*
         * Registration request
         */
        
        DatabaseIntegration *database = [[DatabaseIntegration alloc]init];
        [database registerUserWithUsername:self.Username.text andPassword:self.Password.text andEmail:self.Email.text];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.Username resignFirstResponder];
    [self.Password resignFirstResponder];
    [self.PasswordAgain resignFirstResponder];
    [self.Email resignFirstResponder];
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.Username) {
        [self.Username resignFirstResponder];
    }
    if (self.Password) {
        [self.Password resignFirstResponder];
    }
    if (self.PasswordAgain) {
        [self.PasswordAgain resignFirstResponder];
    }
    if (self.Email) {
        [self.Email resignFirstResponder];
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

-(BOOL) IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


@end
