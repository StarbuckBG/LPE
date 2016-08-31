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

@interface ConnectViewController ()
{
    NSMutableSet <CBPeripheral *> *deviceList;
    NSString * nameOfDeviceToConnect;
    NSInteger currentPoints;
    NSTimer * aTimer;
    __weak IBOutlet NSLayoutConstraint *bubbleXConstraint;
}
@property (weak, nonatomic) IBOutlet RDCodeScannerView * codeScannerView;
@property (strong, nonatomic) CBCentralManager * centralManager;
@property (weak, nonatomic) IBOutlet BubbleView *bubbleView;
@property (weak, nonatomic) IBOutlet UITextView *connectionScreenInformationView;


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
    [aTimer invalidate];
    [self switchToDisconnected];
}

- (void) pointClicked
{
    self.bubbleView.text = [NSString stringWithFormat:@"%ld", (long)currentPoints++];
    
    if(bubbleXConstraint.constant <= self.view.bounds.size.width*2.0f/3.0f) bubbleXConstraint.constant += 0.001*bubbleXConstraint.constant;
    else
    {
        ;
    }
    
    [self.bubbleView setNeedsDisplay];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) switchToConnected
{
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
                     }
                     completion:^(BOOL finished) {
                         aTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(pointClicked) userInfo:nil repeats:YES];
                         
                     }];
}

- (void) switchToDisconnected
{
    [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.bubbleView.alpha = 0;
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

- (void)codeScanned:(RDCodeScannerView *)object codeData:(NSString *)codeData
{
    NSLog(@"%@",codeData);
    nameOfDeviceToConnect = codeData;
    [self connectToDeviceWithName:nameOfDeviceToConnect];
}

#pragma mark - CBCentralManagerDelegate

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    
    aTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(pointClicked) userInfo:nil repeats:YES];
    [self switchToConnected];
    
    
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self switchToDisconnected];
    currentPoints = 0;
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
    NSLog(@"%@", [characteristic.value base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

@end
