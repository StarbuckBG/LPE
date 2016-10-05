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
#import "BButton/BButton.h"
#import "SCLAlertView_Objective_C/SCLAlertView.h"
#import "SAConfettiView-Swift.h"

@interface ExchangeViewController ()
@property (weak, nonatomic) IBOutlet BButton *convertButton;

@end

@implementation ExchangeViewController
NSInteger pointsValue;
DatabaseIntegration* interactions;
NSMutableArray * transactionCompanies;
NSNumber * changeRate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getUserDetails];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdatedNotificationHandler:) name:USERDATA_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdatedNotificationHandler:) name:COMPANIES_DATA_UPDATED object:nil];
    pointsValue = [[[[DatabaseIntegration sharedInstance] userdata] objectForKey:@"points_balance"] integerValue];
    totalPoints.text =  [NSString stringWithFormat:@"%ld", pointsValue];
    interactions = [[DatabaseIntegration alloc] init];
    changeRate = [NSNumber numberWithInteger:0];
    username.text = [[[DatabaseIntegration sharedInstance] userdata] objectForKey:@"username"];
    pointsConversion.text = [NSString stringWithFormat:@"%ld", (NSInteger)(slider.value/10000 * pointsValue)];
    
    self.convertButton.buttonCornerRadius = @(4.0f);
    [self.convertButton setType: BButtonTypePurple];
    //[self.convertButton setStyle:BButtonStyleBootstrapV2];
    [self.convertButton setColor:[UIColor LumiPinkColor]];
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [self setSliderImageViewOnThumb];
}

- (void) setSliderImageViewOnThumb
{
    UIImageView * thumbImageView = [slider.subviews lastObject];
    UILabel * thumbLabel = [[UILabel alloc] initWithFrame:thumbImageView.bounds];
    thumbLabel.text = @"<>";
    thumbLabel.textAlignment = NSTextAlignmentCenter;
    [thumbImageView addSubview:thumbLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction) slider:(id)sender
{
    pointsConversion.text = [NSString stringWithFormat:@"%ld", (NSInteger)(slider.value/10000 * pointsValue)];
    pointsCurency.text = [NSString stringWithFormat:@"%ld",(long)((float)slider.value/10000 * pointsValue * [changeRate floatValue])];
    
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
    
    
    SCLAlertView * alertView = [[SCLAlertView alloc] init];
    //alertView.view = [[SAConfettiView alloc]initWithFrame:alertView.view.frame];
    [alertView showSuccess:self title:@"Yayyy" subTitle:[NSString stringWithFormat: @"You just converted %@ points", pointsConversion.text] closeButtonTitle:@"Ok" duration:0.0f];
    
    
    
//    NSString* string = [NSString stringWithFormat:];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Announcement"
//                                                                   message:string
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
//                                                            style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {
//                                                              NSLog(@"You pressed button OK");
//                                                          }];
//    [alert addAction:defaultAction];
//    [self presentViewController:alert animated:YES completion:nil];
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
    pointsCurency.text = [NSString stringWithFormat:@"%ld",(long)((float)(NSInteger)(slider.value/10000 * pointsValue) * [changeRate floatValue])];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) dataUpdatedNotificationHandler: (NSNotification*) aNotification
{
    totalPoints.text =  [NSString stringWithFormat:@"%ld", pointsValue];
    pointsConversion.text = [NSString stringWithFormat:@"%ld", (NSInteger)slider.value];
    [self.tableView reloadData];
}

@end
