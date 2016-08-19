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
#import "RGTextField.h"

@interface SignInViewController ()

@end

@implementation SignInViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.Password.secureTextEntry = true;
    self.PasswordAgain.secureTextEntry = true;
    
    [self setValidation];
    
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

- (void) setValidation {
    [self.Username addValidationForTextFieldsWithUserName];
    [self.Password addValidationForTextFieldsWithPass];
    [self.PasswordAgain addValidationForTextFieldsWithPass];
    [self.Email addValidationForTextFieldsWithEmailAddress];
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
- (IBAction)cancelButtonToLogin:(id)sender {
    [self performSegueWithIdentifier:@"goToLogIn" sender:nil];
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
        DatabaseIntegration *database = [[DatabaseIntegration alloc]init];
        [database registerUserWithUsername:self.Username.text andPassword:self.Password.text andEmail:self.Email.text];
        [[NSUserDefaults standardUserDefaults] setObject:self.Username.text forKey:@"usernameToLoadAfterRegistration"];
        [[NSUserDefaults standardUserDefaults] setObject:self.Password.text forKey:@"passwordToLoadAfterRegistration"];
        [self performSegueWithIdentifier:@"goToLogIn" sender:nil];
        
    }
    
}
@end