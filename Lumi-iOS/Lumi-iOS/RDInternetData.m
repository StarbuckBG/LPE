//
//  RDInternetData.m
//  Lumi-iOS
//
//  Created by Peter Lazarov on 8/8/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "RDInternetData.h"

@implementation RDInternetData
@synthesize hasInternet;

+ (instancetype)sharedInstance {
    static RDInternetData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RDInternetData alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        hasInternet = NO;
    }
    return self;
}

- (void) setHasInternet:(BOOL)internet {
    hasInternet = internet;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IntenetConnectionChanged" object:nil];
}


@end
