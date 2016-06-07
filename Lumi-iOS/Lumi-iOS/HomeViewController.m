//
//  HomeViewController.m
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "HomeViewController.h"
#import "BubbleView.h"
#import "BubbleStyleKit.h"
@interface HomeViewController ()
{
    DatabaseIntegration * database;
}
@property (weak, nonatomic) IBOutlet BubbleView *topLeftBubbleView;
@property (weak, nonatomic) IBOutlet BubbleView *topRightBubbleView;
@property (weak, nonatomic) IBOutlet BubbleView *centerBubbleView;
@property (weak, nonatomic) IBOutlet BubbleView *bottomRightBubbleView;
@property (weak, nonatomic) IBOutlet BubbleView *bottomLeftBubbleView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    database = [DatabaseIntegration sharedInstance];
    [database loginWithUsername:@"starbuck" andPassword:@"12348765"];
    [database registerUserWithUsername:@"lumiUser1" andPassword:@"12348765" andEmail:@"lumiUser1@playgroundenergy.com"];
    
    self.topLeftBubbleView.innerColor = [BubbleStyleKit greenInner];
    self.topLeftBubbleView.outerColor = [BubbleStyleKit greenOuter];
    self.topLeftBubbleView.text = @"Connect";
    
    self.topRightBubbleView.innerColor = [BubbleStyleKit cyanInner];
    self.topRightBubbleView.outerColor = [BubbleStyleKit cyanOuter];
    self.topRightBubbleView.text = @"Share";
    
    self.centerBubbleView.innerColor = [BubbleStyleKit blueInner];
    self.centerBubbleView.outerColor = [BubbleStyleKit blueOuter];
    self.centerBubbleView.text = @"1523";
    
    self.bottomLeftBubbleView.innerColor = [BubbleStyleKit redInner];
    self.bottomLeftBubbleView.outerColor = [BubbleStyleKit redOuter];
    self.bottomLeftBubbleView.text = @"Map";
    
    self.bottomRightBubbleView.innerColor = [BubbleStyleKit purpleInner];
    self.bottomRightBubbleView.outerColor = [BubbleStyleKit purpleOuter];
    self.bottomRightBubbleView.text = @"Exchange";
    
}

- (void) viewDidAppear:(BOOL)animated
{
    if([[UIScreen mainScreen] bounds].size.width <= 320)
    {
        CGRect topLeftSmall = self.topLeftBubbleView.frame;
        topLeftSmall.size.width = 150;
        topLeftSmall.size.height = 150;
        self.topLeftBubbleView.frame = topLeftSmall;
        
        
        CGRect bottomLeft = self.bottomLeftBubbleView.frame;
        bottomLeft.size.width = 150;
        bottomLeft.size.height = 150;
        self.bottomLeftBubbleView.frame = bottomLeft;
        
        
        CGRect topRightSmall = self.topRightBubbleView.frame;
        topRightSmall.size.width = 150;
        topRightSmall.size.height = 150;
        CGPoint topRightCenter = self.topRightBubbleView.center;
        topRightCenter.x += (self.topRightBubbleView.frame.size.width - topRightSmall.size.width)/2;
        self.topRightBubbleView.frame = topRightSmall;
        self.topRightBubbleView.center = topRightCenter;
        
        CGRect bottomRight = self.bottomRightBubbleView.frame;
        bottomRight.size.width = 150;
        bottomRight.size.height = 150;
        CGPoint bottomRightCenter = self.bottomRightBubbleView.center;
        bottomRightCenter.x += (self.bottomRightBubbleView.frame.size.width - bottomRight.size.width)/2;
        self.bottomRightBubbleView.frame = bottomRight;
        self.bottomRightBubbleView.center = bottomRightCenter;
        
    }
    
    
    [UIView animateWithDuration:5.0f delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.centerBubbleView.center = CGPointMake(self.centerBubbleView.center.x, self.centerBubbleView.center.y - 20);
    } completion:^(BOOL finished) {
        ;
    }];
    
    [UIView animateWithDuration:4.0f delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.topLeftBubbleView.center = CGPointMake(self.topLeftBubbleView.center.x, self.topLeftBubbleView.center.y - 20);
    } completion:^(BOOL finished) {
        ;
    }];
    
    [UIView animateWithDuration:6.0f delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.topRightBubbleView.center = CGPointMake(self.topRightBubbleView.center.x, self.topRightBubbleView.center.y - 20);
    } completion:^(BOOL finished) {
        ;
    }];
    
    [UIView animateWithDuration:5.5f delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.bottomLeftBubbleView.center = CGPointMake(self.bottomLeftBubbleView.center.x, self.bottomLeftBubbleView.center.y - 20);
    } completion:^(BOOL finished) {
        ;
    }];
    
    [UIView animateWithDuration:4.0f delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.bottomRightBubbleView.center = CGPointMake(self.bottomRightBubbleView.center.x, self.bottomRightBubbleView.center.y - 20);
    } completion:^(BOOL finished) {
        ;
    }];
    
    
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

#pragma mark - gestureRecognizers

- (IBAction)topLeftTapGestureRegonized:(UITapGestureRecognizer *)sender {
    self.tabBarController.selectedIndex = 1;
}

- (IBAction)topRightTapGestureRecognized:(UITapGestureRecognizer *)sender {
    //self.tabBarController.selectedIndex = 2;
    [self performSegueWithIdentifier:@"shareImageSegue" sender:nil];

}

- (IBAction)bottomRightTapGestureRecognized:(UITapGestureRecognizer *)sender {
    self.tabBarController.selectedIndex = 3;
}

- (IBAction)bottomLeftTapGestureRecognized:(UITapGestureRecognizer *)sender {
    self.tabBarController.selectedIndex = 4;
}



@end
