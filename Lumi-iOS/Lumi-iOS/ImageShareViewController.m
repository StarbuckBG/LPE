//
//  ImageShareViewController.m
//  Lumi-iOS
//
//  Created by PETAR LAZAROV on 6/6/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "ImageShareViewController.h"

@interface ImageShareViewController ()

@end

@implementation ImageShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self doUpload];
}

-(void)doUpload
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload a photo" message:nil delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Take a photo", @"Choose existing", nil];
    
    alert.alertViewStyle = UIAlertActionStyleDefault;
    [alert show];
}
- (IBAction)chooseNew:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload a photo" message:nil delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Take a photo", @"Choose existing", nil];
    
    alert.alertViewStyle = UIAlertActionStyleDefault;
    [alert show];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
    if (buttonIndex == 2) {
        UIImagePickerController * imagePicker2 = [[UIImagePickerController alloc] init];
        imagePicker2.delegate = self;
        [self presentViewController:imagePicker2 animated:YES completion:NULL];
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageToShare = UIImageJPEGRepresentation(image, 1.0);
    [self.imageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)shareClicked:(id)sender {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller addURL:[NSURL URLWithString:@"http://www.playgroundenrgy.com"]];
        [controller addImage:[UIImage imageWithData:self.imageToShare]];
        
        [self presentViewController:controller animated:YES completion:NULL];
        
    }
    
    
    
    
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
