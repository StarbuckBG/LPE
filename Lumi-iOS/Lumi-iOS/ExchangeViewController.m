//
//  ExchangeViewController.m
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "ExchangeViewController.h"
#import "DatabaseIntegration.h"
#import "UIColor+Lumi.h"

@interface ExchangeViewController ()

@end

@implementation ExchangeViewController
NSInteger sliderValue;
NSInteger pointsValue;
DatabaseIntegration* interactions;
NSMutableArray * transactionCompanies;
NSNumber * changeRate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getUserDetails];
    pointsValue = [[[[DatabaseIntegration sharedInstance] userdata] objectForKey:@"points_balance"] integerValue];
    totalPoints.text =  [NSString stringWithFormat:@"%ld", pointsValue];
    interactions = [[DatabaseIntegration alloc] init];
    changeRate = [NSNumber numberWithInteger:0];
    username.text = [[[DatabaseIntegration sharedInstance] userdata] objectForKey:@"username"];
    
    [self.tableView reloadData];
    NSInteger i;
    i = pointsValue/2;
    pointsConversion.text = [NSString stringWithFormat:@"%ld", i];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction) slider:(id)sender
{
    sliderValue = slider.value/10000 * pointsValue;
    pointsConversion.text = [NSString stringWithFormat:@"%ld", sliderValue];
    pointsCurency.text = [NSString stringWithFormat:@"%ld",(long)((float)sliderValue * [changeRate floatValue])];
    
}
- (IBAction)convertButton:(id)sender
{
    NSInteger pointsForTransaction;
    NSInteger pointAll;
    pointAll = [totalPoints.text intValue];
    pointsForTransaction = [pointsConversion.text intValue];
    pointAll = pointAll - pointsForTransaction;
    pointsValue = [[[[DatabaseIntegration sharedInstance] userdata] objectForKey:@"points_balance"] integerValue];
    
    NSLog(@"Change rate: %f", [changeRate floatValue]);
    if([changeRate floatValue] <= 0)
    {
        NSString* string = [NSString stringWithFormat:@"Must select company to send points"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:string
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button OK");
                                                              }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    
    
    NSString* string = [NSString stringWithFormat:@"You just converted %@ points", pointsConversion.text];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Announcement"
                                                                   message:string
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button OK");
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    slider.value = 0;
    pointsConversion.text = [NSString stringWithFormat:@"0"];
    pointsCurency.text = [NSString stringWithFormat:@"0"];
    totalPoints.text = [NSString stringWithFormat:@"%ld", pointAll];
    
    
}

- (void) getUserDetails
{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[[DatabaseIntegration sharedInstance] companies] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompaniesTableViewIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CompaniesTableViewIdentifier"];
    }
    
    cell.textLabel.text = [[[[DatabaseIntegration sharedInstance] companies] objectAtIndex:indexPath.row] valueForKey: @"name"];
    cell.detailTextLabel.text = [[[[DatabaseIntegration sharedInstance] companies] objectAtIndex:indexPath.row] valueForKey: @"rate"];
    
    UIView * backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor LumiPinkColorAlpha];
    backgroundView.layer.cornerRadius = 10.0f;
    cell.selectedBackgroundView = backgroundView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    changeRate = [NSNumber numberWithFloat:1/[[[[[DatabaseIntegration sharedInstance] companies] objectAtIndex:indexPath.row] valueForKey: @"rate"] floatValue]];
    pointsCurency.text = [NSString stringWithFormat:@"%ld",(long)((float)sliderValue * [changeRate floatValue])];
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
