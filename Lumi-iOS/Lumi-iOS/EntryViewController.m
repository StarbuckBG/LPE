
 //
//  EntryViewController.m
//  Lumi-iOS
//
//  Created by Peter Lazarov on 8/19/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "EntryViewController.h"
#import "LocalDataIntegration.h"

@interface EntryViewController ()
{
    LocalDataIntegration * data;
}
@end

@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
    data = [LocalDataIntegration sharedInstance];
    
    if ([data autoLogin]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"entryToHome" sender:nil];
//        });
    } else {
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"entryToLogin" sender:nil];
//        });
    }
}

- (void)didReceiveMemoryWarning {
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
