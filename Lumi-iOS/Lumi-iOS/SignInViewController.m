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
    [self delegateTF];
    [self gestureHandle];
//    [self setValidation];

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

- (void) delegateTF {
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[RGTextField class]]) {
            RGTextField *tf = (RGTextField*)view;
            tf.rgdelegate = self;
        }
    }
}

- (void) setValidation {
    [self.Username addValidationForTextFieldsWithWord];
    [self.Password addValidationForTextFieldsWithPass];
    [self.PasswordAgain addValidationForTextFieldsWithPass];
    [self.Email addValidationForTextFieldsWithEmailAddress];
}

-(BOOL)checkForErrors {
    BOOL areValid = YES;
    NSArray* subViews = self.view.subviews;
    for (int i = 0; i < subViews.count; i ++) {
        UIView* view = [subViews objectAtIndex:i];
        if ([view isKindOfClass:[RGTextField class]]) {
            RGTextField* rgTf =(RGTextField*)view;
            if (![rgTf validate]) {
                areValid = NO;
                [self showFirstErrorPopUp];
            }
        }
    }
    return areValid;
}

#pragma mark- FindFirstError
- (RGTextField*) findFirstErrorInView:(UIView*)aView
{
    RGTextField* rgTf;
    NSArray* subViews = aView.subviews;
    for (int i = 0; i < subViews.count; i ++) {
        UIView* view = [subViews objectAtIndex:i];
        if ([view isKindOfClass:[RGTextField class]]) {
            rgTf =(RGTextField*)view;
            if(![rgTf validate])break;
        }
    }
    return rgTf;
}

#pragma mark- ShowFirstErrorMessage
-(void) showFirstErrorPopUp
{
    RGTextField* tf = [self findFirstErrorInView:self.view];
    [tf tapOnError];
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

#pragma mark- Gestures
- (void) gestureHandle
{
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    [self hideKeyboard];
    
    NSArray* subViews = self.view.subviews;
    for (int i = 0; i < subViews.count; i ++) {
        UIView* view = [subViews objectAtIndex:i];
        if ([view isKindOfClass:[RGTextField class]]) {
            RGTextField* rgTf =(RGTextField*)view;
            [rgTf hidePopUps];
            break;
        }
    }
}
- (void) hideKeyboard
{
    [self.view endEditing:YES];
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
        [self performSegueWithIdentifier:@"goToLogIn" sender:nil];

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
