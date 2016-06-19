//
//  LocalDataIntegration.h
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 6/6/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalDataIntegration : NSObject
{
    NSUserDefaults * userDefaults;
}
@property (strong, nonatomic) NSString * username;
@property (strong, nonatomic) NSString * password;
@property (strong, nonatomic) NSString * facebookId;
@property (strong, nonatomic) NSString * userId;

@property (assign, nonatomic) bool rememberPassword;
@property (assign, nonatomic) bool autoLogin;

@property (strong, nonatomic) NSMutableDictionary * savedUserdata;

+ (instancetype)sharedInstance;
- (void) syncData;

@end
