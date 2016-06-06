//
//  BuubleView.m
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 6/6/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "BubbleView.h"
#import "BubbleStyleKit.h"

@implementation BubbleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    [BubbleStyleKit drawLumiViewWithInnerCircleColor:_innerColor outerCircleColor:_outerColor innerTextString:_text viewFrame:rect];
}


@end
