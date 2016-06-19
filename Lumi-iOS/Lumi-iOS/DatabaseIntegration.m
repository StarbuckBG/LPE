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


@end
