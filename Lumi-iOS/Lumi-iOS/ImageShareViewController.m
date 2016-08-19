//
//  ImageShareViewController.m
//  Lumi-iOS
//
//  Created by PETAR LAZAROV on 6/6/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "ImageShareViewController.h"

@interface ImageShareViewController ()
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@end

@implementation ImageShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"shareImageKey"];
    self.imageView.image = [UIImage imageWithData:data];
    self.navigationItem.title = @"Share";
    
    UIBarButtonItem* retakeButton = [[UIBarButtonItem alloc] initWithTitle:@"Retake" style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(retakeAction)];
    self.navigationItem.rightBarButtonItem = retakeButton;
    
    [self.shareButton.layer setBorderWidth:1];
    self.shareButton.layer.cornerRadius = 5;
    UIColor* color = [self.view tintColor];
    [self.shareButton.layer setBorderColor:[color CGColor]];
}

- (void)retakeAction {
    [self alertControllerForCameraGallery];
}

- (IBAction)shareClicked:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"shareImageKey"];
        [controller addImage:[UIImage imageWithData:data]];
        [self presentViewController:controller animated:YES completion:nil];
    }
}
-(void) alertControllerForCameraGallery {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo or Video"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                             picker.delegate = self;
                                                             picker.allowsEditing = YES;
                                                             picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                             
                                                             [self presentViewController:picker animated:YES completion:NULL];                                                          }];
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Photo Library"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                              picker.delegate = self;
                                                              picker.allowsEditing = YES;
                                                              picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                              
                                                              [self presentViewController:picker animated:YES completion:NULL];}];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             NSLog(@"Candel action"); }];
    [alert addAction:galleryAction];
    [alert addAction:cameraAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - Image Picker Controller delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
