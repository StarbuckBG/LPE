//
//  HomeViewController.m
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
{
    DatabaseIntegration * database;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    database = [DatabaseIntegration sharedInstance];
    [database loginWithUsername:@"starbuck" andPassword:@"12348765"];
    [database registerUserWithUsername:@"lumiUser1" andPassword:@"12348765" andEmail:@"lumiUser1@playgroundenergy.com"];
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
