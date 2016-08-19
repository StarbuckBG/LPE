//
//  RGTextField.m
//  PDL
//
//  Created by iOS Developer on 22/02/2016.
//  Copyright © 2016 iOS Developer. All rights reserved.
//

#import "RGTextField.h"
#import "AMPopTip.h"

@interface RGTextField ()
@property AMPopTip* popTip;
@property NSString* regex;
@end

@implementation RGTextField

#pragma mark- DefaultValues
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _paydatesMaxDays = 11;
        _paydatesMinDays = 4;
        _maxLength = 256;
        _isMandatory = YES;
        self.delegate = self;
        _regex = @"^.{1,500}$";
    }
    return self;
}
- (void)setInputType:(InputType)inputType
{
    _inputType = inputType;
}

#pragma mark- DegatesTextFields
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self hidePopUps];
    [self.popTip removeFromSuperview];
    InputType type = self.inputType;
    
    switch (type) {
        case InputTypeText:
            break;
     
        default:
            return YES;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self hidePopUps];
     if (textField.text.length >= self.maxLength && range.length == 0) {
        return NO; // Change not allowed
    } else {
        return YES; // Change allowed
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if([_rgdelegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
        [_rgdelegate textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self validate];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger indexTag;
    indexTag = textField.tag;
    
    [textField resignFirstResponder];
    if ([[[self.superview viewWithTag:indexTag+1] text] isEqualToString:@""]){
        [[self.superview viewWithTag:indexTag+1] becomeFirstResponder];
    }
    return YES;
}

#pragma mark- ErrorPopUpMessage
- (void)tapOnError
{
    [self hidePopUps];
    [self.popTip removeFromSuperview];
    self.popTip = [AMPopTip popTip];
    [self.popTip showText:self.errorMessage direction:AMPopTipDirectionDown maxWidth:320 inView:self.superview fromFrame:self.frame];
    self.popTip.shouldDismissOnTap = YES;
}

- (void)showMessageError
{
    UIButton * btnError = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btnError addTarget:self action:@selector(tapOnError) forControlEvents:UIControlEventTouchUpInside];
    [btnError setBackgroundImage:[UIImage imageNamed:@"error.png"] forState:UIControlStateNormal];
    self.rightView = btnError;
    self.rightViewMode = UITextFieldViewModeUnlessEditing;
}

- (void)hidePopUps
{
    NSArray* subViews = [(UIViewController*)self.rgdelegate view].subviews;
    for (int i = 0; i < subViews.count; i++) {
        UIView*v = [subViews objectAtIndex:i];
        if ([v isKindOfClass:[AMPopTip class]]) {
            [(AMPopTip*)v hide];
        }
    }
}

- (void)removeMessageError
{
    self.rightViewMode = UITextFieldViewModeNever;
}

- (void)clearMessageError
{
    [self.popTip hide];
}

#pragma matk- Validation
-(BOOL)validate
{
    if (self.isMandatory) {
        if ([self.text isEqualToString:@""]) {
            [self showMessageError];
            return NO;
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.regex];
        BOOL isValid = [predicate evaluateWithObject:self.text];
        if (!isValid) {
            [self showMessageError];
        } else {
            [self removeMessageError];
        }
        return isValid;
    }
    return YES;
}
#pragma mark- ValidationHelpers
-(void)addValidationForTextFieldsWithUserName
{
    self.regex = @"^.{6,500}$";
    self.errorMessage = @"Please Fill This Field!";
    self.inputType = InputTypeText;
    self.maxLength = 500;
    self.keyboardType = UIKeyboardTypeDefault;
}
-(void)addValidationForTextFieldsWithPass
{
    self.regex = @"^.{6,500}$";
    self.errorMessage = @"Password must be more than 6 symbols!";
    self.inputType = InputTypeText;
    self.maxLength = 500;
    self.keyboardType = UIKeyboardTypeDefault;
}
-(void)addValidationForTextFieldsWithEmailAddress
{
    self.regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    self.errorMessage = @"Enter Valid Email Address!";
    self.inputType = InputTypeText;
    self.maxLength = 60;
    self.keyboardType = UIKeyboardTypeEmailAddress;
}

@end
