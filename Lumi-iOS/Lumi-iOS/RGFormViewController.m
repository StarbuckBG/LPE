//
//  RGFormViewController.m
//  PDL
//
//  Created by iOS Developer on 02/03/2016.
//  Copyright © 2016 iOS Developer. All rights reserved.
//

#import "RGFormViewController.h"

@interface RGFormViewController ()
@property UITextField* activeTF;
@end

@implementation RGFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self gestureHandle];
    [self setDelegates];
    [self setValidation];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setValidation];
}


- (void) setDelegates
{
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[RGTextField class]]) {
            RGTextField *tf = (RGTextField*)view;
            tf.rgdelegate = self;
        }
    }
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
-(void)setValidation {   }
-(void)loadDataToDictionary {   }

#pragma mark- ValidateBeforeNextViewController
- (void)proceedToNextSceeneWithSegueID:(NSString*)segueID {
    if ([self checkForErrors]) {
        [self performSegueWithIdentifier:segueID sender:self];
    } else {
        [self showFirstErrorPopUp];
    }
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
#pragma mark- KeyboardNotifications
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTF = textField;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView commitAnimations];
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView commitAnimations];
}
#pragma mark- ShowFirstErrorMessage
-(void) showFirstErrorPopUp
{
    RGTextField* tf = [self findFirstErrorInView:self.view];
    [tf tapOnError];
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
@end