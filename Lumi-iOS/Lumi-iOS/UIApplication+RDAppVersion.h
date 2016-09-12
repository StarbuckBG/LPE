//
//  UIApplication+RDAppVersion.h
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 9/11/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIApplication(RDAppVersion)

+ (NSString *) appVersion;
+ (NSString *) build;
+ (NSString *) versionBuild;

@end
