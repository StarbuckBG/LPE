//
//  RGTextField.h
//  PDL
//
//  Created by iOS Developer on 22/02/2016.
//  Copyright © 2016 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h> 


typedef NS_ENUM(int, InputType)
{
    InputTypeText = 0
};

@interface RGTextField : UITextField<UITextFieldDelegate>
@property (nonatomic, weak) id <UITextFieldDelegate> rgdelegate;
@property (nonatomic, strong) IBOutlet UIView* presentationView;

@property (nonatomic ,strong) NSString* errorMessage;
@property (nonatomic, assign) NSInteger paydatesMinDays;
@property (nonatomic, assign) NSInteger paydatesMaxDays;


@property BOOL isMandatory;
@property BOOL isYear;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, assign) InputType inputType;
@property (nonatomic, strong) NSArray * pickerArray;

- (void)removeMessageError;
- (void)clearMessageError;
- (void)hidePopUps;
- (void)showMessageError;
- (void)tapOnError;
-(void)addValidationForTextFieldsWithWord;
-(void)addValidationForTextFieldsWithPass;
-(void)addValidationForTextFieldsWithEmailAddress;
-(BOOL)validate;

@end
