//
//  UULines.m
//  UUChartView
//
//  Created by Daniel on 2018/7/22.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

#import "XYLinesView.h"
#import "XYLineGradientLayer.h"

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateLinesShape];
}

- (void)setChartGroup:(id<UUChartGroup>)chartGroup
{
    _chartGroup = chartGroup;
    // clean
    [_sections enumerateObjectsUsingBlock:^(NSArray<CAGradientLayer *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    }];
    [_sections removeAllObjects];
    
    [_chartGroup.dataList enumerateObjectsUsingBlock:^(NSArray<id<UUChartItem>> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray <XYLineGradientLayer *>*mArr = @[].mutableCopy;
        for (int i=0; (i<obj.count-1 && obj.count>1); i++) {
            XYLineGradientLayer *gradient = [XYLineGradientLayer layerWithPre:obj.xy_safeIdx(i) next:obj.xy_safeIdx(i+1)];
            gradient.zPosition = -100;
            [self.layer addSublayer:gradient];
            [mArr addObject:gradient];
        }
        [_sections addObject:[NSArray arrayWithArray:mArr]];
    }];
    
    [self updateLinesShape];
}

- (void)updateLinesShape
{
    [_sections enumerateObjectsUsingBlock:^(NSArray<XYLineGradientLayer *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        const CGFloat itemWidth = uu_width(self)/(float)(obj.count>0 ? (obj.count+1) : 1);
        [obj enumerateObjectsUsingBlock:^(XYLineGradientLayer * _Nonnull gradient, NSUInteger sub_idx, BOOL * _Nonnull sub_stop) {
            CGFloat circleLenght = UUChartLineWidth*4;
            gradient.frame = CGRectMake(itemWidth * (sub_idx + 0.5),
                                        uu_height(self)*(1-MAX(gradient.pre.percent, gradient.next.percent))-circleLenght/2,
                                        itemWidth,
                                        uu_height(self)*fabs(gradient.pre.percent-gradient.next.percent)+circleLenght);
        }];
    }];
}

@end
