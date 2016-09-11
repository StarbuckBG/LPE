//
//  LocalDataIntegration.m
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 6/6/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "LocalDataIntegration.h"

@implementation LocalDataIntegration
+ (instancetype)sharedInstance
{
    static LocalDataIntegration *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LocalDataIntegration alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}


- (NSString *) username
{
    return [userDefaults objectForKey:@"username"];
}

- (void) setUsername:(NSString *)username
{
    [userDefaults setObject:username forKey:@"username"];
}

- (NSString *) password
{
    return [userDefaults objectForKey:@"password"];
}

- (void) setPassword:(NSString *)password
{
    [userDefaults setObject:password forKey:@"password"];
}


- (NSString *) facebookId
{
    return [userDefaults objectForKey:@"facebookId"];
}

- (void) setFacebookId:(NSString *)facebookId
{
    [userDefaults setObject:facebookId forKey:@"facebookId"];
}

- (bool) rememberPassword
{
    return [userDefaults boolForKey:@"rememberPassword"];
}

- (void)setRememberPassword:(bool)rememberPassword
{
    [userDefaults setBool:rememberPassword forKey:@"rememberPassword"];
}

- (bool) autoLogin
{
    return [userDefaults boolForKey:@"autoLogin"];
}

- (void) setAutoLogin:(bool)autoLogin
{
    [userDefaults setBool:autoLogin forKey:@"autoLogin"];
}

- (NSMutableDictionary *) savedUserdata
{
    return [userDefaults objectForKey:@"savedUserdata"];
}

- (void) setSavedUserdata:(NSMutableDictionary *)savedUserdata
{
    [userDefaults setObject:savedUserdata forKey:@"savedUserdata"];
}

- (void) syncData
{
    [userDefaults synchronize];
}

- (void) clearDataForCurrentUser {
    [self setUsername:@""];
    [self setPassword:@""];
    [self setAutoLogin:NO];
    [self syncData];
}

- (void) logout
{
    [self clearDataForCurrentUser];
}

@end
