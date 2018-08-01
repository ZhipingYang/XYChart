//
//  XYChartProtocol.h
//  XYChart
//
//  Created by Daniel on 2018/7/21.
//  Copyright © 2018 uyiuyao. All rights reserved.
//

@import UIKit;
#import "XYChartConst.h"
#import "UIColor+XYChart.h"
#import "NSArray+XYChart.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - UUChartItem

/**
 单个数据展示
 */
@protocol XYChartItem

@required
/**
 值大小
 */
@property (nonatomic, readonly) NSNumber *value;
/**
 动画时间
 */
@property (nonatomic, readonly) NSTimeInterval duration;
/**
 当前颜色
 */
@property (nonatomic, readonly) UIColor *color;

@optional
/**
 名称
 */
@property (nonatomic, readonly, nullable) NSString *showName;

@end






#pragma mark - XYChartDataSource

@class XYChart;
/**
 多套对比数据展示
 */
@protocol XYChartDataSource

/**
 纵向行数 section
 */
- (NSUInteger)numberOfSectionsInChart:(XYChart *)chart;
- (NSUInteger)numberOfRowsInChart:(XYChart *)chart;
- (NSAttributedString *)chart:(XYChart *)chart titleOfRowAtIndex:(NSUInteger)index;
- (NSAttributedString *)chart:(XYChart *)chart titleOfSectionAtValue:(CGFloat)sectionValue;

- (id<XYChartItem>)chart:(XYChart *)chart itemOfIndex:(NSIndexPath *)index;

- (XYRange)visibleRangeInChart:(XYChart *)chart;

- (NSUInteger)numberOfLevelInChart:(XYChart *)chart;

- (CGFloat)rowWidthOfChart:(XYChart *)chart;
- (BOOL)autoSizingRowInChart:(XYChart *)chart;

@end


#pragma mark - XYChartDelegate

@protocol XYChartDelegate

- (BOOL)chart:(XYChart *)chart shouldShowMenu:(NSIndexPath *)index;

- (void)chart:(XYChart *)chart itemDidClick:(id<XYChartItem>)item;

- (CAAnimation *)chart:(XYChart *)chart clickAnimationOfIndex:(NSIndexPath *)index;

@end




#pragma mark - UUChartContainer

/**
 图标容器
 */
@protocol XYChartContainer

@property (nonatomic, weak, readonly) XYChart *chartView;
@property (nonatomic, weak) id<XYChartDataSource> dataSource;
@property (nonatomic, weak) id<XYChartDelegate> delegate;

/**
 更新图标数据
 
 @param dataSource 数据
 @param animation 是否执行动画
 */
- (void)setDataSource:(id<XYChartDataSource>)dataSource animation:(BOOL)animation;

/**
 重载数据
 
 @param animation 是否执行动画
 */
- (void)reloadData:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
