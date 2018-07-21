//
//  UULineChart.m
//  UUChartView
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import "UULineChart.h"

@interface UULineChart ()

@property (nonatomic, strong) UIScrollView *scrolView;

@end

@implementation UULineChart

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setChartGroup:(id<UUChartGroup>)chartGroup
{
    [self setChartGroup:chartGroup animation:_chartGroup ? NO : YES];
}

- (void)setChartGroup:(id<UUChartGroup>)chartGroup animation:(BOOL)animation
{
    _chartGroup = chartGroup;
}

- (void)reloadData:(BOOL)animation
{
    
}

@end
