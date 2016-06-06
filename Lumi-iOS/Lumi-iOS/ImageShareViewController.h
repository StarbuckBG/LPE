//
//  ImageShareViewController.h
//  Lumi-iOS
//
//  Created by PETAR LAZAROV on 6/6/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface ImageShareViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@property(strong, nonatomic) SLComposeServiceViewController* slComposeViewController;
@property(strong, nonatomic) NSData* imageToShare;

@end
