//
//  DatabaseIntegration.m
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 6/5/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "DatabaseIntegration.h"

@implementation DatabaseIntegration

+ (instancetype)sharedInstance
{
    static DatabaseIntegration *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DatabaseIntegration alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        self.userdata = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) updateAllData
{
    [self updatePlaygrounds];
    [self updateCompaniesAndRates];
    [self updateUserLogs];
}

- (void) updatePointsData
{
    [self updateUserData];
    [self updateUserLogs];
}

- (void) updateUserData
{
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     getUserData (GET https://rapiddevcrew.com/lumi_v2/getUserData/)
     */
    
    NSURL* URL = [NSURL URLWithString:@"https://rapiddevcrew.com/lumi_v2/getUserData/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    // Headers
    
    [request addValue:[NSString stringWithFormat:@"{\"username\":\"%@\"}", [[LocalDataIntegration sharedInstance] username]] forHTTPHeaderField:@"Data"];
    
    
    __block NSMutableArray * responseArray = [[NSMutableArray alloc] init];
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            responseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
            self.userdata = [responseArray objectAtIndex:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:USERDATA_UPDATED object:self];
            [self updateUserLogs];
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
            [[NSNotificationCenter defaultCenter] postNotificationName:CONNECTION_PROBLEMS object:self];
        }
    }];
    [task resume];
    
    
    
}

- (void) loginWithUsername: (NSString *) username andPassword: (NSString *) password
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     Login with username (GET http://rapiddevcrew.com/lumi_v2/)
     */
    
    NSURL* URL = [NSURL URLWithString:@"https://rapiddevcrew.com/lumi_v2/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    // Headers
    NSString * headerField = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}", username, password];
    [request addValue:headerField forHTTPHeaderField:@"Credentials"];
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            if((((NSHTTPURLResponse*)response).statusCode) == 200)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESSFUL object:self];
                [self updateUserData];
                NSLog(@"Succesful login");
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOT_SUCCESSFUL object:self];
                NSLog(@"Not succesful login");
            }
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
            [[NSNotificationCenter defaultCenter] postNotificationName:CONNECTION_PROBLEMS object:self];
        }
    }];
    [task resume];
}





- (void) registerUserWithUsername: (NSString *) username andPassword: (NSString *) password andEmail: (NSString *) email
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     Register with email (POST http://rapiddevcrew.com/lumi_v2/register/)
     */
    
    NSURL* URL = [NSURL URLWithString:@"https://rapiddevcrew.com/lumi_v2/register/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    // JSON Body
    
    NSDictionary* bodyObject = @{
                                 @"email": email,
                                 @"username": username,
                                 @"password": password
                                 };
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyObject options:kNilOptions error:NULL];
    
    
    __block NSMutableArray * responseArray = [[NSMutableArray alloc] init];
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
            responseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"requestSuccessful" object:self];
            if((((NSHTTPURLResponse*)response).statusCode) == 200)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:REGISTRATION_SUCCESSFUL object:self];
            }
            else if((((NSHTTPURLResponse*)response).statusCode) == 406)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:REGISTRATION_USERNAME_NOT_AVAILABLE object:self];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:REGISTRATION_NOT_SUCCESSFUL object:self];
            }
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionProblems" object:self];
        }
    }];
    [task resume];
    
}

- (void) updatePlaygrounds
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     Get Playground Locations (GET http://rapiddevcrew.com/lumi_v2/getPlaygrounds/)
     */
    
    NSURL* URL = [NSURL URLWithString:@"https://rapiddevcrew.com/lumi_v2/getPlaygrounds/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    
    __block NSMutableArray * responseArray = [[NSMutableArray alloc] init];
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
            responseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
            self.playgrounds = responseArray;
            [[NSNotificationCenter defaultCenter] postNotificationName:PLAYGROUNDS_DATA_UPDATED object:self];
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionProblems" object:self];
        }
    }];
    [task resume];
}

- (void) updateCompaniesAndRates
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     Get Companies (GET http://rapiddevcrew.com/lumi_v2/getCompanies/)
     */
    
    NSURL* URL = [NSURL URLWithString:@"https://rapiddevcrew.com/lumi_v2/getCompanies/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    
    __block NSMutableArray * responseArray = [[NSMutableArray alloc] init];
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            responseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
            self.companies = responseArray;
            [[NSNotificationCenter defaultCenter] postNotificationName:COMPANIES_DATA_UPDATED object:self];
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionProblems" object:self];
        }
    }];
    [task resume];
    
}

- (void) updateUserLogs
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     Get logs for user (GET https://rapiddevcrew.com/lumi_v2/getLogsForUser/)
     */
    
    NSURL* URL = [NSURL URLWithString:@"https://rapiddevcrew.com/lumi_v2/getLogsForUser/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    // Headers
    
    [request addValue:[NSString stringWithFormat:@"{\"user_id\":\"%@\"}", [self.userdata objectForKey:@"id"]] forHTTPHeaderField:@"Data"];
    
    
    __block NSMutableArray * responseArray = [[NSMutableArray alloc] init];
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
            responseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
            self.logs = responseArray;
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGS_UPDATED object:self];
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionProblems" object:self];
        }
    }];
    [task resume];
}

- (void) addToLogPoints: (NSString *) points onApplianceId: (NSString *) applicanceId withIntensity: (NSString *) intensity fromTime: (NSDate *) startTime toTime: (NSDate *) endTime;
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     addLog (POST https://rapiddevcrew.com/lumi_v2/addLog/)
     */
    
    NSURL* URL = [NSURL URLWithString:@"https://rapiddevcrew.com/lumi_v2/addLog/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    // JSON Body
    
    NSDictionary* bodyObject = @{
                                 @"points": points,
                                 @"appliance_id": applicanceId,
                                 @"user_id": [[self userdata] objectForKey:@"id"],
                                 @"intensity": intensity,
                                 @"start_time": [formatter stringFromDate:startTime],
                                 @"end_time": [formatter stringFromDate:endTime]
                                 };
    
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyObject options:kNilOptions error:NULL];
    
    
    __block NSMutableArray * responseArray = [[NSMutableArray alloc] init];
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
            responseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
            [[NSNotificationCenter defaultCenter] postNotificationName:LOG_ADDED object:self];
            
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionProblems" object:self];
        }
    }];
    [task resume];
    
}

- (void)addTransfer:(NSString *)points toCompanyId:(NSString *)companyId
{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     addTransfer (POST https://rapiddevcrew.com/lumi_v2/addTransfer/)
     */
    
    NSURL* URL = [NSURL URLWithString:@"https://rapiddevcrew.com/lumi_v2/addTransfer/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    // JSON Body
    
    NSDictionary* bodyObject = @{
                                 @"user_id": [[self userdata] objectForKey:@"id"],
                                 @"points": points,
                                 @"company_id":companyId
                                 };
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyObject options:kNilOptions error:NULL];
    
    
    __block NSMutableArray * responseArray = [[NSMutableArray alloc] init];
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
            responseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"requestSuccessful" object:self];
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionProblems" object:self];
        }
    }];
    [task resume];

}

@end
