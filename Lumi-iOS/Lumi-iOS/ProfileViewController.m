//
//  ProfileViewController.m
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "ProfileViewController.h"
#import "LocalDataIntegration.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LocalDataIntegration * data = [[LocalDataIntegration alloc]init];
    [data setAutoLogin:NO];
    
    
    
    //    if (self.rememberMeSwitch.on) {
    //        NSMutableDictionary* dic = [NSMutableDictionary new];
    //        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"dictionaryNotFilled"];
    //        USAFormPartOneViewController *viewController = (USAFormPartOneViewController *)[storyboard instantiateViewControllerWithIdentifier:@"usa1"];
    //        [self.navigationController pushViewController:viewController animated:YES];
    //
    //    } else {
    //        PasswordViewController *viewController1 = (PasswordViewController *)[storyboard instantiateViewControllerWithIdentifier:@"pass"];
    //        [self.navigationController pushViewController:viewController1 animated:YES];
    //    }
    //
    //
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    LocalDataIntegration * data = [[LocalDataIntegration alloc]init];
    if (![data autoLogin]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"goToLoginScreen" sender:nil];
        });
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
