//
//  UUChart.h
//	Version 0.1
//  UUChart
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUChart.h"
#import "UUChartConst.h"
#import "UULineChart.h"
#import "UUBarChart.h"

typedef NS_ENUM(NSInteger, UUChartStyle){
    UUChartStyleLine = 0,
    UUChartStyleBar
};

@class UUChart;
@protocol UUChartDataSource <NSObject>

@required
//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart;

//数值多重数组
- (NSArray *)chartConfigAxisYValue:(UUChart *)chart;

@optional
//颜色数组
- (NSArray *)chartConfigColors:(UUChart *)chart;

//显示数值范围
- (CGRange)chartRange:(UUChart *)chart;

#pragma mark 折线图专享功能
//标记数值区域
- (CGRange)chartHighlightRangeInLine:(UUChart *)chart;

//判断显示横线条
- (BOOL)chart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index;

//判断显示最大最小值
- (BOOL)chart:(UUChart *)chart showMaxMinAtIndex:(NSInteger)index;
@end


@interface UUChart : UIView

@property (nonatomic) UUChartStyle chartStyle;


- (id)initWithFrame:(CGRect)rect dataSource:(id<UUChartDataSource>)dataSource style:(UUChartStyle)style;

- (void)showInView:(UIView *)view;

- (void)strokeChart;

@end
