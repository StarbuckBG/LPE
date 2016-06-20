//
//  ConnectViewController.m
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "ConnectViewController.h"

@interface ConnectViewController ()
@property (weak, nonatomic) IBOutlet RDCodeScannerView * codeScannerView;

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void) viewWillAppear:(BOOL)animated
{
     self.codeScannerView.delegate = self;
    [self.codeScannerView startReading];
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

- (void)codeScanned:(RDCodeScannerView *)object codeData:(NSString *)codeData
{
    NSLog(@"%@:",codeData);
}

@end
