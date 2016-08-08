//
//  AppDelegate.h
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "RDInternetData.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL hasInternet;
@property Reachability* reachability;

@end

