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
@class XYChart;
@protocol XYChartItem

@required
/**
 百分比值，value == (max-min)*percent
 */
@property (nonatomic, readonly) CGFloat percent;
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
@property (nonatomic, readonly, nullable) NSString *name;

@end


#pragma mark - UUChartGroup

/**
 多套对比数据展示
 */
@protocol XYChartDataSource

/**
 类型
 */
@property (nonatomic, readonly) XYChartStyle chartStyle;

/**
 纵向行数 section
 */
- (NSUInteger)numberOfSections;

- (id<XYChartItem>)chart:(XYChart *)chart itemOfIndex:(NSIndexPath *)index;

- (NSAttributedString *)chart:(XYChart *)chart titleOfRowAtIndex:(NSInteger *)index;

- (NSRange)visibleRangeInChart:(XYChart *)chart;

- (BOOL)autoSizingRowInChart:(XYChart *)chart ;

- (NSAttributedString *)chart:(XYChart *)chart titleOfSectionAtValue:(CGFloat)sectionValue;




/**
 横轴底部标签文案，要求： names.count 和 dataList 每个子数组的 count 一致
 */
@property (nonatomic, readonly) NSArray <NSAttributedString *> *names;

/**
 最小值
 */
@property (nonatomic, readonly) CGFloat minValue;

/**
 最大值
 */
@property (nonatomic, readonly) CGFloat maxValue;

@property (nonatomic, readonly) NSUInteger numberOfSections;

/**
 横向 row 的宽度，在 autoSizingRowWidth==false 时可用，否则 widthOfRow = scrollViewWidth/count
 */
@property (nonatomic, readonly) CGFloat widthOfRow;

/**
 自适应横向 row 的宽度 = scrollViewWidth/count
 */
@property (nonatomic, readonly) BOOL autoSizingRowWidth;

/**
 多条链对比展示
 子元素要求：装着UUChartItem的数组，且每个数组的UUChartItem个数要求一致
 */
@property (nonatomic, readonly) NSArray <NSArray <id<XYChartItem>>*> *dataList;

/**
 配置纵轴上标签文案，根据传入的 float => 富文本， 比如：0.34 => “P：34%”
 */
@property (nonatomic, readonly, nullable) NSAttributedString *(^configYLabelBlock)(CGFloat value);

@end


#pragma mark - UUChartContainer

/**
 图标容器
 */
@protocol XYChartContainer

@property (nonatomic, readonly) id<XYChartDataSource>chartGroup;

/**
 更新图标数据

 @param chartGroup 对组数据
 @param animation 是否执行动画
 */
- (void)setChartGroup:(id<XYChartDataSource>)chartGroup animation:(BOOL)animation;

/**
 重载数据
 
 @param animation 是否执行动画
 */
- (void)reloadData:(BOOL)animation;

@end


NS_ASSUME_NONNULL_END
