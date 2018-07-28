//
//  XYChart.m
//  XYChart
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

@property (nonatomic, strong) UIView <XYChartContainer> *chartContainer;

@property (nonatomic) XYChartType chartType;

@property (nonatomic, strong) NSMutableArray <UILabel *>* sectionLabels;

@end

@implementation XYChart

- (id)initWithFrame:(CGRect)frame chartType:(XYChartType)chartType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sectionLabels = @[].mutableCopy;
        _horizonLines = @[].mutableCopy;
        _chartType = chartType;
        [self setUpChartElements];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame chartType:XYChartTypeLine];
}

- (void)setUpChartElements
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
    
    if (_chartType == XYChartTypeLine) {
        _chartContainer = [[XYLineChart alloc] initWithChartView:self];
    } else if (_chartType == XYChartTypeBar) {
        _chartContainer = [[XYBarChart alloc] initWithChartView:self];
    }
    [self addSubview:_chartContainer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    const CGSize size = self.bounds.size;
    
    CGFloat labelHeight = (size.height-XYChartRowLabelHeight)/(_sectionLabels.count>1 ? _sectionLabels.count-1 : 1);
    
    [_sectionLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(0, labelHeight*(idx-0.5), XYChartSectionLabelWidth-4, labelHeight);
    }];
    
    _chartContainer.frame = CGRectMake(XYChartSectionLabelWidth, 0, size.width-XYChartSectionLabelWidth, size.height);
    [_chartContainer setNeedsLayout];
    [self justLinesLayout];
}

- (void)setDataSource:(id<XYChartDataSource>)dataSource
{
    [self setDataSource:dataSource animation:_dataSource ? NO : YES];
}

- (void)setDelegate:(id<XYChartDelegate>)delegate
{
    _delegate = delegate;
    _chartContainer.delegate = delegate;
}

- (void)setDataSource:(id<XYChartDataSource>)dataSource animation:(BOOL)animation
{
    _dataSource = dataSource;
    
    // 容器
    _chartContainer.frame = CGRectMake(XYChartSectionLabelWidth, 0, xy_width(self)-XYChartSectionLabelWidth, xy_height(self));
    [_chartContainer setDataSource:dataSource animation:animation];
    
    [self resetSectionLabels];
    [self resetHorizonLines];
    [self setNeedsLayout];
}

- (void)reloadData:(BOOL)animation
{
    [self setDataSource:_dataSource animation:animation];
}

- (void)justLinesLayout
{
    const CGFloat pixel = 1/[UIScreen mainScreen].scale;
    const CGSize size = self.bounds.size;
    const NSUInteger levels = [_dataSource numberOfLevelInChart:self];
    CGFloat count = levels>0 ? levels : 1;
    const CGFloat sectionHeight = (size.height-XYChartRowLabelHeight)/count;
    _leftSeparatedLine.frame = CGRectMake(XYChartSectionLabelWidth, 0, pixel, size.height-XYChartRowLabelHeight);
    _rightSeparatedLine.frame = CGRectMake(size.width-pixel, 0, pixel, size.height-XYChartRowLabelHeight);
    [_horizonLines enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(XYChartSectionLabelWidth, sectionHeight * idx, size.width-XYChartSectionLabelWidth, pixel);
    }];
}

- (void)resetSectionLabels
{
    [_sectionLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_sectionLabels removeAllObjects];
    
    const NSUInteger levels = [_dataSource numberOfLevelInChart:self];
    const XYRange range = [_dataSource visibleRangeInChart:self];
    const CGFloat sectionValue = (range.max-range.min)/(CGFloat)levels;
    
    for (NSUInteger i=0; i<levels+1; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentRight;
        CGFloat value = range.max - sectionValue*i;
        
        if ([(NSObject<XYChartDataSource> *)_dataSource respondsToSelector:@selector(chart:titleOfSectionAtValue:)]) {
            label.attributedText = [_dataSource chart:self titleOfSectionAtValue:value];
        } else {
            label.font = [UIFont systemFontOfSize:11];
            label.textColor = [UIColor lightGrayColor];
            label.text = [NSString stringWithFormat:@"%.f",range.max - sectionValue*i];
        }
        [self addSubview:label];
        [_sectionLabels addObject:label];
    }
}

- (void)resetHorizonLines
{
    [_horizonLines makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_horizonLines removeAllObjects];
    
    for (int i=0; i<[_dataSource numberOfLevelInChart:self]+1; i++) {
        CALayer *hori = [CALayer layer];
        hori.backgroundColor = [UIColor xy_separatedColor].CGColor;
        hori.zPosition = -1;
        [self.layer addSublayer:hori];
        [_horizonLines addObject:hori];
    }
    [self justLinesLayout];
}

@end
