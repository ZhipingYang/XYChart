//
//  XYChart.h
//  XYChart
//
//  Created by Daniel on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#include "XYChartProtocol.h"

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface XYChart : UIView<XYChartReload>

@property (nonatomic, weak, nullable) id<XYChartDataSource> dataSource;
@property (nonatomic, weak, nullable) id<XYChartDelegate> delegate;

@property (nonatomic, readonly) XYChartType type;

- (instancetype)initWithFrame:(CGRect)frame chartType:(XYChartType)chartType NS_DESIGNATED_INITIALIZER;

/**
 更新图标数据
 
 @param dataSource 数据
 @param animation 是否执行动画
 */
- (void)setDataSource:(id<XYChartDataSource>)dataSource animation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
