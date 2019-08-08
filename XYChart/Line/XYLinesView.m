//
//  UULines.m
//  XYChart
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYLinesView.h"
#import "XYLineGradientLayer.h"
#import "XYChart.h"

@interface XYLinesView()

@property (nonatomic, strong) NSMutableArray <NSArray <XYLineGradientLayer *>*>* sections;
    
@end

@implementation XYLinesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _sections = @[].mutableCopy;
    }
    return self;
}

- (instancetype)initWithChartView:(XYChart *)chartView;
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _chartView = chartView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateLinesShape:NO];
}

- (void)reloadData:(BOOL)animation
{
    // clean
    [_sections enumerateObjectsUsingBlock:^(NSArray<CAGradientLayer *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    }];
    [_sections removeAllObjects];
    
    
    NSUInteger section = [_chartView.dataSource numberOfSectionsInChart:_chartView];
    NSUInteger row = [_chartView.dataSource numberOfRowsInChart:_chartView];
    XYRange range = [_chartView.dataSource visibleRangeInChart:_chartView];
    
    for (int sectionIdx=0; sectionIdx<section; sectionIdx++) {
        NSMutableArray <XYLineGradientLayer *>*mArr = @[].mutableCopy;
        for (int rowIdx=0; rowIdx<row-1; rowIdx++) {
            NSIndexPath *preIndex = [NSIndexPath indexPathForRow:rowIdx inSection:sectionIdx];
            NSIndexPath *nextIndex = [NSIndexPath indexPathForRow:rowIdx+1 inSection:sectionIdx];
            id<XYChartItem> preItem = [_chartView.dataSource chart:_chartView itemOfIndex:preIndex];
            id<XYChartItem> nextItem = [_chartView.dataSource chart:_chartView itemOfIndex:nextIndex];
            
            XYLineGradientLayer *gradient = [XYLineGradientLayer layerWithPre:preItem next:nextItem range:range];
            gradient.zPosition = -100;
            [self.layer addSublayer:gradient];
            [mArr addObject:gradient];
        }
        [self.sections addObject:[NSArray arrayWithArray:mArr]];
    }
    
    [self updateLinesShape:animation];
}

- (void)updateLinesShape:(BOOL)animate
{
    XYRange range = [_chartView.dataSource visibleRangeInChart:_chartView];

    [_sections enumerateObjectsUsingBlock:^(NSArray<XYLineGradientLayer *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        const CGFloat itemWidth = xy_width(self)/(float)(obj.count>0 ? (obj.count+1) : 1);
        [obj enumerateObjectsUsingBlock:^(XYLineGradientLayer * _Nonnull gradient, NSUInteger sub_idx, BOOL * _Nonnull sub_stop) {
            CGFloat circleLenght = XYChartLineWidth*4;
            CGFloat prePercent = (gradient.pre.value.floatValue-range.min)/(range.max-range.min);
            CGFloat nextPercent = (gradient.next.value.floatValue-range.min)/(range.max-range.min);
            gradient.frame = CGRectMake(itemWidth * (sub_idx + 0.5),
                                        xy_height(self)*(1-MAX(prePercent, nextPercent))-circleLenght/2,
                                        itemWidth,
                                        xy_height(self)*fabs(prePercent-nextPercent)+circleLenght);
            [gradient startAnimate:animate];
        }];
    }];
}

@end
