//
//  DatabaseIntegration.h
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 6/5/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseIntegration : NSObject

#define CONNECTION_PROBLEMS @"connectionProblems"

#define LOGIN_SUCCESSFUL @"LoginSuccessful"
#define LOGIN_NOT_SUCCESSFUL @"LoginUnsuccessful"

#define REGISTRATION_SUCCESSFUL @"RegistrationSuccessful"
#define REGISTRATION_NOT_SUCCESSFUL @"RegisterNotSuccessful"
#define REGISTRATION_USERNAME_NOT_AVAILABLE @"RegistrationUsernameNotAvailable"

#define USERDATA_UPDATED @"UserdataUpdated"
#define LOGS_UPDATED @"LogsUpdated"
#define LOG_ADDED @"LogAdded"

#define COMPANIES_DATA_UPDATED @"CompaniesDataUpdated"
#define PLAYGROUNDS_DATA_UPDATED @"PlaygroundDataUpdatd"
#define APPLICANCES_DATA_UPDATED @"AppliancesDataUpdated"

@property (nonatomic, strong) __block NSMutableDictionary * userdata;
@property (nonatomic, strong) __block NSMutableArray * logs;
@property (nonatomic, strong) __block NSMutableArray * playgrounds;
@property (nonatomic, strong) __block NSMutableArray * appliances;
@property (nonatomic, strong) __block NSMutableArray * companies;

+(instancetype)sharedInstance;

- (void) loginWithUsername: (NSString *) username andPassword: (NSString *) password;
- (void) registerUserWithUsername: (NSString *) username andPassword: (NSString *) password andEmail: (NSString *) email;
- (void) registerUserWithFacebookId: (NSString *) facebookId andPassword: (NSString *) password andUsername: (NSString *) username;
- (void) updatePlaygrounds;
- (void) updateAppliances;
- (void) updateAppliancesForPlaygroundId: (NSString *) playgroundId;
- (void) addToLogPoints: (NSString *) points onApplianceId: (NSString *) applicanceId withIntensity: (NSString *) intensity fromTime: (NSDate *) startTime toTime: (NSDate *) endTime;
- (void) getLogs;





@end
