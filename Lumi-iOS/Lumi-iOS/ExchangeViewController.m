//
//  ExchangeViewController.m
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "ExchangeViewController.h"
#import "DatabaseIntegration.h"

@interface ExchangeViewController ()

@end

@implementation ExchangeViewController
NSInteger sliderValue;
NSInteger pointsValue;
DatabaseIntegration* interactions;
//userDataSaving *data;
NSMutableArray * transactionCompanies;
NSNumber * changeRate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getUserDetails];
//    DatabaseIntegration *database = [[DatabaseIntegration alloc]init];
//    data = [[userDataSaving alloc]init];
//    points.text = [NSString stringWithFormat:@"%d",[database getPoints:[data currentUser] withPass:[data currentPassword]]];
    pointsValue = [totalPoints.text intValue];
    interactions = [[DatabaseIntegration alloc] init];
    changeRate = [NSNumber numberWithInteger:0];
//    username.text = [NSString stringWithFormat:@"%@",[data currentUser]];
    
    NSDictionary* company1 = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Riot Games", @"Name", @"1.52", @"rate", nil];
    NSDictionary* company2 = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"TAO Games", @"Name", @"1.12", @"rate", nil];
    NSDictionary* company3 = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Apple Inc", @"Name", @"5.12", @"rate", nil];
    NSDictionary* company4 = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Blizzard Ent.", @"Name", @"2.314", @"rate", nil];
    NSDictionary* company5 = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Steam Powered", @"Name", @"0.721", @"rate", nil];
    NSDictionary* company6 = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Origin", @"Name", @"1.445", @"rate", nil];
    
    
    transactionCompanies = [NSMutableArray arrayWithObjects:company1,company2,company3, company4, company5, company6,nil];
    
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
    
//    [interactions pointsTransactionWithUserName:[data currentUser] withPass:[data currentPassword] withPoints:pointsForTransaction];
    
    
    
    
    
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
    DatabaseIntegration *database = [[DatabaseIntegration alloc]init];
//    data = [[userDataSaving alloc]init];
//    points.text = [NSString stringWithFormat:@"%d",[database getPoints:[data currentUser] withPass:[data currentPassword]]];
    pointsValue = [totalPoints.text intValue];
    
}

- (void) getUserDetails
{
//    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
//     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//         if (!error) {
//             self.FBuserid = [[FBSDKAccessToken currentAccessToken] userID];
//             self.FBusername = [result valueForKey:@"name"];
//             NSLog(@"Username got from getUserDetails = %@", self.FBusername);
//             username.text = self.FBusername;
//             // NSString *email =  [result valueForKey:@"email"];
//         }
//         else{
//             NSLog(@"%@",error.localizedDescription);
//         }
//     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [transactionCompanies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
//    NSManagedObject *device = [transactionCompanies objectAtIndex:indexPath.row];
    
//    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [device valueForKey:@"Name"]]];
    
//    [cell.detailTextLabel setText:[device valueForKey:@"rate"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    changeRate = [NSNumber numberWithFloat:1/[[[transactionCompanies objectAtIndex:indexPath.row] valueForKey:@"rate"] floatValue]];
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
