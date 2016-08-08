//
//  RDInternetData.h
//  Lumi-iOS
//
//  Created by Peter Lazarov on 8/8/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDInternetData : NSObject {
    BOOL hasInternet;
}

@property (nonatomic, assign) BOOL hasInternet;

+ (instancetype)sharedInstance;

- (void) setHasInternet:(BOOL)hasInternet;

@end

