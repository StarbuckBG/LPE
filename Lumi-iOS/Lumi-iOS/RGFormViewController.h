//
//  RGFormViewController.h
//  PDL
//
//  Created by iOS Developer on 02/03/2016.
//  Copyright © 2016 iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGTextField.h"
#import <QuartzCore/QuartzCore.h>

@interface RGFormViewController : UIViewController <UITextFieldDelegate>

@property RGTextField* currentTextField;
@property (nonatomic, assign) CGSize keyboardSize;
-(void) showFirstErrorPopUp;

-(BOOL)checkForErrors;

@end
