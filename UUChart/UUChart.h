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
#import "UUColor.h"
#import "UULineChart.h"
#import "UUBarChart.h"
//类型
typedef enum {
	UUChartLineStyle,
	UUChartBarStyle
} UUChartStyle;


@class UUChart;
@protocol UUChartDataSource <NSObject>

@required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart;

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart;

@optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart;

//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart;

#pragma mark 折线图专享功能
//标记数值区域
- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart;

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index;

//判断显示最大最小值
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index;
@end


@interface UUChart : UIView

//是否自动显示范围
@property (nonatomic, assign) BOOL showRange;

@property (assign) UUChartStyle chartStyle;

-(id)initwithUUChartDataFrame:(CGRect)rect withSource:(id<UUChartDataSource>)dataSource withStyle:(UUChartStyle)style;

- (void)showInView:(UIView *)view;

-(void)strokeChart;

@end
