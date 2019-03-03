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
 多少条并行对比数据，折线图表现多条线，柱状图表现一列中有几条柱状图
 */
- (NSUInteger)numberOfSectionsInChart:(XYChart *)chart;

/**
 完整的周期内，数据的个数，横向列数
 */
- (NSUInteger)numberOfRowsInChart:(XYChart *)chart;

/**
 x坐标的标题
 */
- (NSAttributedString *)chart:(XYChart *)chart titleOfRowAtIndex:(NSUInteger)index;

/**
 x坐标的标题
 */
- (NSAttributedString *)chart:(XYChart *)chart titleOfSectionAtValue:(CGFloat)sectionValue;

/**
 index下的数据模型
 */
- (id<XYChartItem>)chart:(XYChart *)chart itemOfIndex:(NSIndexPath *)index;

/**
 标记y轴方向高亮区间
 */
- (XYRange)visibleRangeInChart:(XYChart *)chart;

/**
 y轴方向分段，5就分5段
 */
- (NSUInteger)numberOfLevelInChart:(XYChart *)chart;

/**
 横向一栏的宽度
 */
- (CGFloat)rowWidthOfChart:(XYChart *)chart;

/**
 自适应平均分横向栏目的宽度
 */
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

@property (nonatomic, weak, readonly, nullable) XYChart *chartView;
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
