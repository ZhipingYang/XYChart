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

@property (nonatomic) XYChartType type;
@property (nonatomic) CGFloat sectionLabelWidth;

@property (nonatomic, strong) NSMutableArray <UILabel *>* sectionLabels;

@end

@implementation XYChart

- (XYRange)xy_autoVisibleRangeWithFallback:(XYRange)fallback
{
    NSUInteger sections = [self.dataSource numberOfSectionsInChart:self];
    NSUInteger rows = [self.dataSource numberOfRowsInChart:self];
    __block CGFloat minValue = CGFLOAT_MAX;
    __block CGFloat maxValue = -CGFLOAT_MAX;
    __block BOOL hasValue = NO;
    
    for (NSUInteger section = 0; section < sections; section++) {
        for (NSUInteger row = 0; row < rows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            id<XYChartItem> item = [self.dataSource chart:self itemOfIndex:indexPath];
            if (!item) {
                continue;
            }
            CGFloat value = item.value.doubleValue;
            minValue = MIN(minValue, value);
            maxValue = MAX(maxValue, value);
            hasValue = YES;
        }
    }
    
    if (!hasValue) {
        return fallback;
    }
    return XYChartExpandedRange(minValue, maxValue);
}

- (void)xy_commonInitWithType:(XYChartType)type
{
    self.sectionLabels = @[].mutableCopy;
    self.sectionLabelWidth = XYChartSectionLabelWidth;
    _horizonLines = @[].mutableCopy;
    _type = type;
    [self setUpChartElements];
}

- (id)initWithFrame:(CGRect)frame type:(XYChartType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self xy_commonInitWithType:type];
    }
    return self;
}

- (instancetype)initWithType:(XYChartType)type
{
    return [self initWithFrame:CGRectZero type:type];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self xy_commonInitWithType:XYChartTypeLine];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame type:XYChartTypeLine];
}

- (void)updateChartContainerFrame
{
    CGFloat containerX = self.sectionLabelWidth;
    _chartContainer.frame = CGRectMake(containerX, 0, MAX(xy_width(self) - containerX, 0), xy_height(self));
}

- (CGFloat)preferredSectionLabelWidth
{
    __block CGFloat width = XYChartSectionLabelWidth;
    [_sectionLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize fittingSize = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, 20.0)];
        width = MAX(width, ceil(fittingSize.width) + 8.0);
    }];
    return MIN(width, 72.0);
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
    
    if (_type == XYChartTypeLine) {
        _chartContainer = [[XYLineChart alloc] initWithChartView:self];
    } else if (_type == XYChartTypeBar) {
        _chartContainer = [[XYBarChart alloc] initWithChartView:self];
    }
    [self addSubview:_chartContainer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    const CGSize size = self.bounds.size;
    CGFloat sectionLabelWidth = self.sectionLabelWidth;
    CGFloat plotHeight = XYChartPlotHeight(size.height);
    
    CGFloat labelHeight = plotHeight / (_sectionLabels.count>1 ? _sectionLabels.count-1 : 1);
    
    [_sectionLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(0, labelHeight*(idx-0.5), MAX(sectionLabelWidth - 4.0, 0), labelHeight);
    }];
    
    [self updateChartContainerFrame];
    [_chartContainer setNeedsLayout];
    [self justLinesLayout];
}

#pragma mark - public

- (void)setDataSource:(id<XYChartDataSource>)dataSource
{
    [self setDataSource:dataSource animation:NO];
}

- (void)setDataSource:(id<XYChartDataSource>)dataSource animation:(BOOL)animation
{
    _dataSource = dataSource;
    
    [self resetSectionLabels];
    [self updateChartContainerFrame];
    [_chartContainer reloadData:animation];
    [self resetHorizonLines];
    [self setNeedsLayout];
}

- (void)setConfiguration:(XYChartConfiguration *)configuration
{
    _configuration = [configuration copy];
    if (self.dataSource) {
        [self reloadData:NO];
    } else {
        [self setNeedsLayout];
    }
}

- (XYChartConfiguration *)resolvedConfiguration
{
    XYChartConfiguration *resolved = nil;
    if (self.configuration) {
        resolved = [self.configuration copy];
    } else if ([(NSObject<XYChartDataSource> *)self.dataSource respondsToSelector:@selector(chartConfiguration:)]) {
        resolved = [[self.dataSource chartConfiguration:self] copy];
    }
    
    if (!resolved) {
        resolved = [XYChartConfiguration defaultConfiguration];
        if ([(NSObject<XYChartDataSource> *)self.dataSource respondsToSelector:@selector(visibleRangeInChart:)]) {
            resolved.visibleRange = [self.dataSource visibleRangeInChart:self];
        }
        if ([(NSObject<XYChartDataSource> *)self.dataSource respondsToSelector:@selector(numberOfLevelInChart:)]) {
            resolved.numberOfLevels = [self.dataSource numberOfLevelInChart:self];
        }
        if ([(NSObject<XYChartDataSource> *)self.dataSource respondsToSelector:@selector(rowWidthOfChart:)]) {
            resolved.rowWidth = [self.dataSource rowWidthOfChart:self];
        }
        if ([(NSObject<XYChartDataSource> *)self.dataSource respondsToSelector:@selector(autoSizingRowInChart:)]) {
            resolved.autoSizingRowWidth = [self.dataSource autoSizingRowInChart:self];
        }
    }
    
    if (resolved.automaticallyAdjustsVisibleRange) {
        resolved.visibleRange = [self xy_autoVisibleRangeWithFallback:resolved.visibleRange];
    }
    resolved.numberOfLevels = XYChartSafeLevels(resolved.numberOfLevels);
    return resolved;
}

#pragma mark - private

- (void)justLinesLayout
{
    const CGFloat pixel = XYChartPixel();
    const CGSize size = self.bounds.size;
    XYChartConfiguration *configuration = [self resolvedConfiguration];
    const NSUInteger levels = configuration.numberOfLevels;
    const CGFloat sectionLabelWidth = self.sectionLabelWidth;
    CGFloat count = levels;
    const CGFloat plotHeight = XYChartPlotHeight(size.height);
    const CGFloat sectionHeight = plotHeight / count;
    _leftSeparatedLine.frame = CGRectMake(sectionLabelWidth, 0, pixel, plotHeight);
    _rightSeparatedLine.frame = CGRectMake(MAX(size.width - pixel, sectionLabelWidth), 0, pixel, plotHeight);
    [_horizonLines enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(sectionLabelWidth, sectionHeight * idx, MAX(size.width - sectionLabelWidth, 0), pixel);
    }];
}

- (void)resetSectionLabels
{
    [_sectionLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_sectionLabels removeAllObjects];
    
    XYChartConfiguration *configuration = [self resolvedConfiguration];
    const NSUInteger levels = configuration.numberOfLevels;
    const XYRange range = configuration.visibleRange;
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
    self.sectionLabelWidth = [self preferredSectionLabelWidth];
}

- (void)resetHorizonLines
{
    [_horizonLines makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_horizonLines removeAllObjects];
    
    const NSUInteger levels = [self resolvedConfiguration].numberOfLevels;
    for (NSUInteger i=0; i<levels+1; i++) {
        CALayer *hori = [CALayer layer];
        hori.backgroundColor = [UIColor xy_separatedColor].CGColor;
        hori.zPosition = -1;
        [self.layer addSublayer:hori];
        [_horizonLines addObject:hori];
    }
    [self justLinesLayout];
}

#pragma mark - XYChartReload

- (void)reloadData:(BOOL)animation
{
    [self setDataSource:_dataSource animation:animation];
}

@end
