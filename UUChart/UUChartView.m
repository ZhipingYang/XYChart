//
//  UUChartView.m
//  UUChartView
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import "UUChartView.h"
#import "UULineChart.h"
#import "UUBarChart.h"
#import "UIColor+Random.h"

@interface UUChartView ()

@property (nonatomic, strong) UIView <UUChartContainer> *chartContainer;

@property (nonatomic, strong) NSMutableArray <UILabel *>* sectionLabels;

@end

@implementation UUChartView

- (id)initWithFrame:(CGRect)frame chartGroup:(id<UUChartGroup>)chartGroup
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sectionLabels = @[].mutableCopy;
        _chartGroup = chartGroup;
        [self setUpChart];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame chartGroup:nil];
}

- (void)setUpChart
{
    [_sectionLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_chartContainer removeFromSuperview];
    [_sectionLabels removeAllObjects];
    
    // 容器
    const CGSize size = self.bounds.size;
    if (_chartGroup.chartStyle == UUChartStyleLine) {
        _chartContainer = [[UULineChart alloc] initWithFrame:CGRectMake(UUChartYLabelWidth, 0, size.width-UUChartYLabelWidth, size.height)];
    } else {
        _chartContainer = [[UUBarChart alloc] initWithFrame:CGRectMake(UUChartYLabelWidth, 0, size.width-UUChartYLabelWidth, size.height)];
    }
    [self addSubview:_chartContainer];
    [_chartContainer setChartGroup:_chartGroup animation:NO];
    
    // 初始化
    [self setChartGroup:_chartGroup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    const CGSize size = self.bounds.size;
    
    CGFloat labelHeight = (size.height-UUChartXLabelHeight)/(_sectionLabels.count>1 ? _sectionLabels.count-1 : 1);
    
    [_sectionLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(0, labelHeight*(idx-0.5), UUChartYLabelWidth-4, labelHeight);
    }];
    
    _chartContainer.frame = CGRectMake(UUChartYLabelWidth, 0, size.width-UUChartYLabelWidth, size.height);
    [_chartContainer setNeedsLayout];
}

- (void)setChartGroup:(id<UUChartGroup>)chartGroup
{
    [self setChartGroup:chartGroup animation:_chartGroup ? NO : YES];
}

- (void)setChartGroup:(id<UUChartGroup>)chartGroup animation:(BOOL)animation
{
    _chartGroup = chartGroup;
    
    [_sectionLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_sectionLabels removeAllObjects];
    
    for (NSUInteger i=0; i<_chartGroup.ySectionNumber; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor random];
        CGFloat sectionValue = (chartGroup.maxValue-chartGroup.minValue)/(CGFloat) chartGroup.ySectionNumber;
        label.text = @(chartGroup.minValue + sectionValue*i).stringValue;
        [self addSubview:label];
        [_sectionLabels addObject:label];
    }
    [self setNeedsLayout];
}

- (void)reloadData:(BOOL)animation
{
    [self setChartGroup:_chartGroup animation:YES];
}

@end
