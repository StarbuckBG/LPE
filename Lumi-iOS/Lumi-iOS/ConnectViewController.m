//
//  ConnectViewController.m
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "ConnectViewController.h"
#import "BubbleView.h"
#import "UIColor+Lumi.h"
#import "BubbleStyleKit.h"
#import "DatabaseIntegration.h"
#import "BButton/BButton.h"
#import "SCLAlertView_Objective_C/SCLAlertView.h"
#import "SAConfettiView-Swift.h"

#define pointsMultiplier 25

@interface ConnectViewController ()
{
    NSMutableSet <CBPeripheral *> *deviceList;
    NSString * nameOfDeviceToConnect;
    NSInteger currentPoints;
    __weak IBOutlet NSLayoutConstraint *bubbleXConstraint;
}
@property (weak, nonatomic) IBOutlet RDCodeScannerView * codeScannerView;
@property (strong, nonatomic) CBCentralManager * centralManager;
@property (weak, nonatomic) IBOutlet BubbleView *bubbleView;
@property (weak, nonatomic) IBOutlet UITextView *connectionScreenInformationView;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (strong, nonatomic) NSDate * startDateTime;
@property (strong, nonatomic) NSDate * endDateTime;

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    deviceList = [[NSMutableSet alloc] init];
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    currentPoints = 0;
    
    
    self.bubbleView.alpha = 0;
    self.bubbleView.innerColor = [BubbleStyleKit purpleInner];
    self.bubbleView.outerColor = [BubbleStyleKit purpleOuter];
    
    self.finishButton.alpha = 0;
    
    self.codeScannerView.delegate = self;
    [self.codeScannerView startReading];
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    
    
    bubbleXConstraint.constant = self.view.bounds.size.width/2.0f;
    
    [UIView animateWithDuration:5.0f delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.bubbleView.center = CGPointMake(self.bubbleView.center.x, self.bubbleView.center.y - 20);
    } completion:^(BOOL finished) {
        ;
    }];
    
}

- (void) viewDidDisappear:(BOOL)animated
{
    for (CBPeripheral * aPeripheral in deviceList)
    {
        if([aPeripheral.name isEqualToString:nameOfDeviceToConnect])
        {
            [self.centralManager cancelPeripheralConnection:aPeripheral];
            break;
        }
    }
}

- (void) incrementPoints: (NSInteger) value
{
    currentPoints += value;
    
    NSInteger pointsToPresent = currentPoints/pointsMultiplier;
    
    self.bubbleView.text = [NSString stringWithFormat:@"%ld", (long)pointsToPresent];
    
    if(bubbleXConstraint.constant <= self.view.bounds.size.width*2.0f/3.0f) bubbleXConstraint.constant += 0.0001*bubbleXConstraint.constant;
    else
    {
    }
    
    [self.bubbleView setNeedsDisplay];
}
- (void) pointClicked
{
    self.bubbleView.text = [NSString stringWithFormat:@"%ld", (long)currentPoints++];
    
    if(bubbleXConstraint.constant <= self.view.bounds.size.width*2.0f/3.0f) bubbleXConstraint.constant += 0.001*bubbleXConstraint.constant;
    else
    {
    }
    
    [self.bubbleView setNeedsDisplay];
    
    
}

- (void) presentYouHaveWonScreenWithPoints:(NSInteger) points
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) switchToConnected
{
    self.bubbleView.text = [NSString stringWithFormat:@"%ld", (long)currentPoints];
    [self.bubbleView setNeedsDisplay];
    
    self.startDateTime = [NSDate date];
    
    [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.codeScannerView.alpha = 0;
                         self.connectionScreenInformationView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:2.0f delay:2 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.bubbleView.alpha = 1;
                         self.finishButton.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void) switchToDisconnected
{
    self.endDateTime = [NSDate date];
    NSInteger pointsToPresent = currentPoints/pointsMultiplier;
    
    [[DatabaseIntegration sharedInstance] addToLogPoints:[NSString stringWithFormat:@"%d", pointsToPresent]
                                           onApplianceId:@"1"
                                           withIntensity:@"5"
                                                fromTime:self.startDateTime
                                                  toTime:self.endDateTime];
    SCLAlertView * alertView = [[SCLAlertView alloc] init];
    [alertView showSuccess:self title:@"Yayyy" subTitle:[NSString stringWithFormat:@"You have won %d Lumis", pointsToPresent] closeButtonTitle:@"Ok" duration:0.0f];
    
    currentPoints = 0;
    
    
    [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.bubbleView.alpha = 0;
                         self.finishButton.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:2.0f delay:2 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.codeScannerView.alpha = 1;
                         self.connectionScreenInformationView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - RDCodeScannerDelegate
- (void)codeScanned:(RDCodeScannerView *)object codeData:(NSString *)codeData
{
    NSLog(@"%@",codeData);
    nameOfDeviceToConnect = codeData;
    [self connectToDeviceWithName:nameOfDeviceToConnect];
}


- (void) connectToDeviceWithName: (NSString *) deviceName
{
    for(CBPeripheral * aPeripheral in deviceList)
    {
        if([aPeripheral.name isEqualToString:deviceName])
        {
            [self.centralManager connectPeripheral:aPeripheral options:nil];
            [self.centralManager stopScan];
            return;
        }
    }
    if([self.centralManager isScanning] == NO)
    {
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

#pragma mark - CBCentralManagerDelegate

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    [self switchToConnected];
    
    
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self switchToDisconnected];
    peripheral.delegate = nil;
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"%@", peripheral.name);
    [deviceList addObject:peripheral];
    if(nameOfDeviceToConnect != nil)
    {
        [self connectToDeviceWithName:nameOfDeviceToConnect];
    }
}


#pragma mark CBPeripheralDelegate


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for(CBService * aService in peripheral.services)
    {
        if([aService.UUID.UUIDString isEqualToString:@"180F"])
        {
            [peripheral discoverCharacteristics:nil forService:aService];
        }
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for(CBCharacteristic * aCharacteristic in service.characteristics)
    {
        if([aCharacteristic.UUID.UUIDString isEqualToString:@"2A19"])
        {
            [peripheral setNotifyValue:YES forCharacteristic:aCharacteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //NSLog(@"%@", [characteristic.value base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]);
    NSInteger energyValue = [[[NSString alloc] initWithData:characteristic.value
                                                   encoding:NSUTF8StringEncoding] characterAtIndex:0];
    [self incrementPoints:energyValue+1];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
}

#pragma mark - IB Event Handlers
- (IBAction)finishButtonPressed:(UIButton *)sender {
    
    for (CBPeripheral * aPeripheral in deviceList)
    {
        if([aPeripheral.name isEqualToString:nameOfDeviceToConnect])
        {
            [self.centralManager cancelPeripheralConnection:aPeripheral];
            break;
        }
    }
    
}



@end
