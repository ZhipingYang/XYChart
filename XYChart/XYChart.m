//
//  UUChartView.m
//  UUChartView
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import "XYChart.h"
#import "XYLineChart.h"
#import "XYBarChart.h"

@interface XYChart ()
{
    CALayer *_leftSeparatedLine;
    CALayer *_rightSeparatedLine;
    NSMutableArray <CALayer *>*_horizonLines;
}

@property (nonatomic, strong) UIView <UUChartContainer> *chartContainer;

@property (nonatomic, strong) NSMutableArray <UILabel *>* sectionLabels;

@end

@implementation XYChart

- (id)initWithFrame:(CGRect)frame chartGroup:(id<UUChartGroup>)chartGroup
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sectionLabels = @[].mutableCopy;
        _horizonLines = @[].mutableCopy;
        [self setUpChart];
        // 初始化
        self.chartGroup = _chartGroup;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame chartGroup:nil];
}

- (void)setUpChart
{
    if (!_leftSeparatedLine) {
        _leftSeparatedLine = [CALayer layer];
        _leftSeparatedLine.backgroundColor = [UIColor xy_separatedColor].CGColor;
        _leftSeparatedLine.zPosition = -1;
        [self.layer addSublayer:_leftSeparatedLine];
    }
    if (!_rightSeparatedLine) {
        _rightSeparatedLine = [CALayer layer];
        _rightSeparatedLine.backgroundColor = [UIColor xy_separatedColor].CGColor;
        _rightSeparatedLine.zPosition = -1;
        [self.layer addSublayer:_rightSeparatedLine];
    }
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
    [self justLinesLayout];
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
    
    // 图表类型都改变了
    if (_chartContainer && _chartGroup.chartStyle != _chartContainer.chartGroup.chartStyle) {
        [_chartContainer removeFromSuperview];
        _chartContainer = nil;
    }
    
    // 容器
    const CGSize size = self.bounds.size;
    if (_chartGroup.chartStyle == UUChartStyleLine && !_chartContainer) {
        _chartContainer = [[XYLineChart alloc] initWithFrame:CGRectMake(UUChartYLabelWidth, 0, size.width-UUChartYLabelWidth, size.height)];
    } else if (_chartGroup.chartStyle == UUChartStyleBar && !_chartContainer) {
        _chartContainer = [[XYBarChart alloc] initWithFrame:CGRectMake(UUChartYLabelWidth, 0, size.width-UUChartYLabelWidth, size.height)];
    }
    [self addSubview:_chartContainer];
    [_chartContainer setChartGroup:_chartGroup animation:NO];
    
    for (NSUInteger i=0; i<_chartGroup.ySectionNumber+1; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentRight;
        CGFloat sectionValue = (chartGroup.maxValue-chartGroup.minValue)/(CGFloat)chartGroup.ySectionNumber;
        CGFloat value = chartGroup.maxValue - sectionValue*i;
        if (_chartGroup.configYLabelBlock) {
            label.attributedText = _chartGroup.configYLabelBlock(value);
        } else {
            label.font = [UIFont systemFontOfSize:11];
            label.textColor = [UIColor lightGrayColor];
            label.text = [NSString stringWithFormat:@"%.f",chartGroup.maxValue - sectionValue*i];
        }
        [self addSubview:label];
        [_sectionLabels addObject:label];
    }
    [self updateHorizonLines];
    [self setNeedsLayout];
}

- (void)reloadData:(BOOL)animation
{
    [self setChartGroup:_chartGroup animation:YES];
}

- (void)justLinesLayout
{
    const CGFloat pixel = 1/[UIScreen mainScreen].scale;
    const CGSize size = self.bounds.size;
    CGFloat count = _chartGroup.ySectionNumber>0 ? _chartGroup.ySectionNumber : 1;
    const CGFloat sectionHeight = (size.height-UUChartXLabelHeight)/count;
    _leftSeparatedLine.frame = CGRectMake(UUChartYLabelWidth, 0, pixel, size.height-UUChartXLabelHeight);
    _rightSeparatedLine.frame = CGRectMake(size.width-pixel, 0, pixel, size.height-UUChartXLabelHeight);
    [_horizonLines enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(UUChartYLabelWidth, sectionHeight * idx, size.width-UUChartYLabelWidth, pixel);
    }];
}

- (void)updateHorizonLines
{
    [_horizonLines makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_horizonLines removeAllObjects];
    
    for (int i=0; i<_chartGroup.ySectionNumber+1; i++) {
        CALayer *hori = [CALayer layer];
        hori.backgroundColor = [UIColor xy_separatedColor].CGColor;
        hori.zPosition = -1;
        [self.layer addSublayer:hori];
        [_horizonLines addObject:hori];
    }
    [self justLinesLayout];
}

@end
