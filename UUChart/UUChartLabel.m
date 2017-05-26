//
//  PNChartLabel.m
//  PNChart
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUChartLabel.h"
#import "UUChartConst.h"

@implementation UUChartLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.minimumScaleFactor = 5.0f;
        self.numberOfLines = 1;
        self.font = [UIFont boldSystemFontOfSize:9.0f];
        self.textColor = [UUColor darkGrayColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}


@end
